import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:frontend_waste_management/app/data/models/sampah_detail_model.dart';
import 'package:frontend_waste_management/app/data/services/api_service.dart';
import 'package:frontend_waste_management/app/data/services/token_chacker.dart';
import 'package:frontend_waste_management/core/values/const.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

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
  final RxInt difference = 0.obs;
  final _tokenService = TokenService();

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
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
    super.onClose();
  }

  Future<void> getAllSampah() async {
    if (!await _tokenService.checkToken()) {
      return;
    }
    try {
      final response = await ApiServices().get(UrlConstants.sampah);
      sampahsData.value = parseSampahDetail(response);
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
                  Get.toNamed('/report-detail', arguments: e.id);
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
      debugPrint('Error getting all sampah: $e');
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
      difference.value = lastDate.value.difference(firstDate.value).inDays;
      final response =
          await ApiServices().post("${UrlConstants.sampah}/timeseries", {
        "start_date": firstDate.value.toIso8601String(),
        "end_date": lastDate.value.toIso8601String(),
      });
      timeseriesData.value = parseSampahDetail(response);
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
              child: Icon(
                Icons.location_on,
                color:
                    interpolateColor((e.totalSampah! / 20.0), defaultGradient),
                size: 40.0,
              ),
            ),
          )
          .toList();
      isLoading.value = false;
      print(isLoading.value);
    } catch (e) {
      debugPrint('Error getting all sampah: $e');
    }
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
