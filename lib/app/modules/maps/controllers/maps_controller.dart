import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:frontend_waste_management/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/simply_translate.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapsController extends GetxController {
  //TODO: Implement MapsController
  final isLoading = false.obs;
  final isHeatmap = false.obs;
  final curruntPosition = const LatLng(0, 0).obs;
  final sampahsData = <SampahDetail>[].obs;
  final alignPositionOnUpdate = AlignOnUpdate.always.obs;
  final alignPositionStreamController = StreamController<double?>().obs;
  final streamController = StreamController().obs;
  final markers = <Marker>[].obs;
  final weightedLatLng = <WeightedLatLng>[].obs;
  final firstDate = DateTime.now().obs;
  final lastDate = DateTime.now().obs;
  final firstDateController = TextEditingController().obs;
  final lastDateController = TextEditingController().obs;
  final timeseriesData = <SampahDetail>[].obs;
  final RxInt difference = 1.obs;
  final _tokenService = TokenService();
  final selectedDay = 1.obs;
  final switcher = false.obs;
  late final Rx<SuperclusterMutableController> superclusterController;
  final selectedMarkerDetail = Rx<SampahDetail?>(null);

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    superclusterController = SuperclusterMutableController().obs;
    alignPositionOnUpdate.value = AlignOnUpdate.always;
    alignPositionStreamController.value = StreamController<double?>();
    streamController.value = StreamController.broadcast();
    firstDateController.value.text = "";
    lastDateController.value.text = "";
    await getAllSampah();
    isLoading.value = false;
  }

  @override
  void onClose() {
    alignPositionStreamController.value.close();
    streamController.value.close();
    superclusterController.value.dispose();
    super.onClose();
  }

  Future<void> getAllSampah() async {
    if (!await _tokenService.checkToken()) {
      return;
    }
    try {
      final response = await ApiServices().get(UrlConstants.sampah);
      if (response.statusCode != 200) {
        // var message = await translate(jsonDecode(response.body)['detail']);
        var message = jsonDecode(response.body)['detail'];

        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.waste_data_error, message);
        throw ('Sampah error: ${response.body}');
      }
      sampahsData.value = parseSampahDetail(response.body);
      weightedLatLng.value = sampahsData
          .map(
            (e) => WeightedLatLng(
              e.geom!,
              e.totalSampah!.toDouble(),
            ),
          )
          .toList();
      markers.value = sampahsData
          .map(
            (e) => Marker(
              width: 80.0,
              height: 80.0,
              point: e.geom!,
              rotate: true,
              child: GestureDetector(
                onTap: () {
                  selectedMarkerDetail.value = e;
                },
                child: Icon(
                  Icons.location_on,
                  color: interpolateColor(
                      (e.totalSampah! / 20.0), defaultGradient),
                  size: 40.0,
                ),
              ),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('${AppLocalizations.of(Get.context!)!.waste_data_error}: $e');
    }
  }

  Future<void> getTimeseriesData() async {
    try {
      if (!await _tokenService.checkToken()) {
        return;
      }
      alignPositionOnUpdate.value = AlignOnUpdate.always;
      alignPositionStreamController.value = StreamController<double?>();
      isLoading.value = true;

      final response =
          await ApiServices().post("${UrlConstants.sampah}/timeseries", {
        "start_date": firstDate.value.toIso8601String(),
        "end_date": lastDate.value.toIso8601String(),
      });

      if (response.statusCode != 200) {
        var message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
            AppLocalizations.of(Get.context!)!.waste_time_series_error,
            message);
        throw ('Timeseries error: ${response.body}');
      }

      timeseriesData.value = parseSampahDetail(response.body);

      if (timeseriesData.isEmpty) {
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.no_data,
          AppLocalizations.of(Get.context!)!.show_previous_data,
        );
      } else {
        difference.value =
            lastDate.value.difference(firstDate.value).inDays + 1;
        weightedLatLng.value = timeseriesData
            .map(
              (e) => WeightedLatLng(
                e.geom!,
                e.totalSampah!.toDouble(),
              ),
            )
            .toList();
        markers.value = timeseriesData
            .map(
              (e) => Marker(
                width: 80.0,
                height: 80.0,
                point: e.geom!,
                rotate: true,
                child: GestureDetector(
                  onTap: () {
                    selectedMarkerDetail.value = e;
                  },
                  child: Icon(
                    Icons.location_on,
                    color: interpolateColor(
                        (e.totalSampah! / 20.0), defaultGradient),
                    size: 40.0,
                  ),
                ),
              ),
            )
            .toList();
        sliderChanged(1);
      }

      isLoading.value = false;
    } catch (e) {
      debugPrint(
          '${AppLocalizations.of(Get.context!)!.waste_time_series_error}: $e');
    }
  }

  void resetTimeSeries() {
    firstDateController.value.text = "";
    lastDateController.value.text = "";
    selectedDay.value = 1;
    difference.value = 1;
    timeseriesData.clear();
    getAllSampah();
    showSuccessSnackbar(
      "Time Series Reset",
      "All data is now displayed without any date filter.",
    );
    superclusterController.value.replaceAll(markers.value);
  }

  void sliderChanged(double value) {
    selectedDay.value = value.toInt(); // Update selected day

    if (switcher.value) {
      // Cumulative Data Mode
      // Accumulate data from Day 1 to the selected day
      final cumulativeWeightedLatLng = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays <=
              selectedDay.value - 1)
          .map((e) => WeightedLatLng(e.geom!, e.totalSampah!.toDouble()))
          .toList();

      final cumulativeMarkers = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays <=
              selectedDay.value - 1)
          .map((e) => Marker(
                width: 80.0,
                height: 80.0,
                point: e.geom!,
                rotate: true,
                child: GestureDetector(
                  onTap: () {
                    selectedMarkerDetail.value = e;
                  },
                  child: Icon(
                    Icons.location_on,
                    color: interpolateColor(
                        (e.totalSampah! / 20.0), defaultGradient),
                    size: 40.0,
                  ),
                ),
              ))
          .toList();

      // Update cumulative data
      weightedLatLng.value = [...cumulativeWeightedLatLng];
      markers.value = [...cumulativeMarkers];
    } else {
      // Daily Data Mode
      // Clear and show only data for the selected day
      final dailyWeightedLatLng = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays ==
              selectedDay.value - 1)
          .map((e) => WeightedLatLng(e.geom!, e.totalSampah!.toDouble()))
          .toList();

      final dailyMarkers = timeseriesData
          .where((element) =>
              element.captureTime!.difference(firstDate.value).inDays ==
              selectedDay.value - 1)
          .map((e) => Marker(
                width: 80.0,
                height: 80.0,
                point: e.geom!,
                rotate: true,
                child: GestureDetector(
                  onTap: () {
                    selectedMarkerDetail.value = e;
                  },
                  child: Icon(
                    Icons.location_on,
                    color: interpolateColor(
                        (e.totalSampah! / 20.0), defaultGradient),
                    size: 40.0,
                  ),
                ),
              ))
          .toList();

      // Update daily data
      weightedLatLng.value = [...dailyWeightedLatLng];
      markers.value = [...dailyMarkers];
    }

    weightedLatLng.refresh();
    markers.refresh();
    superclusterController.value.replaceAll(markers.value);
    streamController.value.add(null);
  }

  Color interpolateColor(double value, Map<double, Color> gradient) {
    List<double> keys = gradient.keys.toList()..sort();
    for (int i = 0; i < keys.length - 1; i++) {
      double lower = keys[i];
      double upper = keys[i + 1];
      if (value <= upper) {
        double range = upper - lower;
        double rangeRatio = (value - lower) / range;
        Color lowerColor = gradient[lower]!;
        Color upperColor = gradient[upper]!;
        return Color.lerp(lowerColor, upperColor, rangeRatio)!;
      }
    }
    return gradient[keys.last]!;
  }

  Map<double, Color> defaultGradient = {
    0.25: Colors.blue,
    0.55: Colors.green,
    0.85: Colors.yellow,
    1.0: Colors.red,
  };
}
