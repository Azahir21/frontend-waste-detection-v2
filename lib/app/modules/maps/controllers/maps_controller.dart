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
import 'package:frontend_waste_management/app/widgets/app_icon.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
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
  final isPlaying = false.obs;
  Timer? _sliderTimer;
  final mapsMode = "marker".obs;
  final showFilter = false.obs;
  final showTimeSeries = false.obs;
  final showMapsType = false.obs;
  final filterDataType = "all".obs;
  final filterStatus = "all".obs;
  String previousFilterDataType = "all";
  String previousFilterStatus = "all";
  final MapController mapController = MapController();
  TickerProvider? tickerProvider;

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
    // await loadFacilityData();
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
    if (!await _tokenService.checkToken()) return;

    try {
      final response = await ApiServices().get(
          "${UrlConstants.sampah}?data_type=${filterDataType.value}&status=${filterStatus.value}");
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['detail'];
        showFailedSnackbar(
          AppLocalizations.of(Get.context!)!.waste_data_error,
          message,
        );
        throw ('Sampah error: ${response.body}');
      }

      sampahsData.value = parseSampahDetail(response.body);
      // Update map data using the helper functions.
      _updateMapData(sampahsData.value);
    } catch (e) {
      debugPrint('${AppLocalizations.of(Get.context!)!.waste_data_error}: $e');
    }
  }

  Future<void> getTimeseriesData() async {
    if (!await _tokenService.checkToken()) return;

    // Prepare UI for new timeseries data.
    alignPositionOnUpdate.value = AlignOnUpdate.always;
    alignPositionStreamController.value = StreamController<double?>();
    isLoading.value = true;

    final url =
        "${UrlConstants.sampah}/timeseries?start_date=${firstDate.value.toIso8601String()}&end_date=${lastDate.value.toIso8601String()}&data_type=${filterDataType.value}&status=${filterStatus.value}";
    final response = await ApiServices().get(url);

    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['detail'];
      showFailedSnackbar(
        AppLocalizations.of(Get.context!)!.waste_time_series_error,
        message,
      );
      // resetTimeSeries();
      isLoading.value = false;
      throw ('Timeseries error: ${response.body}');
    }

    timeseriesData.value = parseSampahDetail(response.body);

    if (timeseriesData.isEmpty) {
      showFailedSnackbar(
        AppLocalizations.of(Get.context!)!.no_data,
        AppLocalizations.of(Get.context!)!.show_previous_data,
      );
    } else {
      difference.value = lastDate.value.difference(firstDate.value).inDays + 1;
      // Call sliderChanged(1) to update the markers and weighted data.
      sliderChanged(1);
    }

    isLoading.value = false;
  }

  /// Resets the timeseries filters and shows all data.
  void resetTimeSeries() {
    firstDateController.value.text = "";
    lastDateController.value.text = "";
    selectedDay.value = 1;
    difference.value = 1;
    timeseriesData.clear();

    // Reload all sampah data.
    getAllSampah();

    showSuccessSnackbar(
      AppLocalizations.of(Get.context!)!.time_series_reset,
      AppLocalizations.of(Get.context!)!.all_data_displayed,
    );
    superclusterController.value.replaceAll(markers.value);
  }

  /// Called when the slider value changes.
  /// Updates the markers and weighted points based on the selected day and mode.
  void sliderChanged(double value) {
    selectedDay.value = value.toInt();

    // Filter the timeseries data based on whether we are in cumulative or daily mode.
    final filteredData = timeseriesData.where((element) {
      final dayDifference =
          element.captureTime!.difference(firstDate.value).inDays;
      return switcher.value
          ? dayDifference <= selectedDay.value - 1 // Cumulative mode
          : dayDifference == selectedDay.value - 1; // Daily mode
    }).toList();

    weightedLatLng.value = filteredData.map(_buildWeightedLatLng).toList();
    markers.value = filteredData.map(_buildMarker).toList();

    // Notify listeners and update clustering.
    weightedLatLng.refresh();
    markers.refresh();
    superclusterController.value.replaceAll(markers.value);
    streamController.value.add(null);
  }

  /// Updates the map data (markers and weighted points) for the given list.
  void _updateMapData(List<dynamic> data) {
    weightedLatLng.value = data.map(_buildWeightedLatLng).toList();
    markers.value = data.map(_buildMarker).toList();
    superclusterController.value.replaceAll(markers.value);
  }

  /// Returns a WeightedLatLng instance for the given data element.
  WeightedLatLng _buildWeightedLatLng(dynamic element) {
    return WeightedLatLng(
      element.geom!,
      element.totalSampah!.toDouble(),
    );
  }

  /// Returns a Marker widget for the given data element.
  Marker _buildMarker(dynamic element) {
    return Marker(
      width: 40.0,
      height: 40.0,
      point: element.geom!,
      rotate: true,
      child: GestureDetector(
        onTap: () {
          selectedMarkerDetail.value = element;
          animateMapMove(element.geom!,
              mapController.camera.zoom <= 12 ? 12 : mapController.camera.zoom);
        },
        child: Obx(
          () => AppIcon.custom(
            appIconName: element.id == selectedMarkerDetail.value?.id
                ? (element.isWastePile!
                    ? AppIconName.pileSelected
                    : AppIconName.pcsSelected)
                : element.isPickup!
                    ? (element.isWastePile!
                        ? AppIconName.pileCollected
                        : AppIconName.pcsCollected)
                    : (element.isWastePile!
                        ? AppIconName.pileUncollected
                        : AppIconName.pcsUncollected),
            context: Get.context!,
          ),
        ),
      ),
    );
  }

  void animateMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: mapController.camera.zoom,
      end: destZoom,
    );

    var controllerAnim = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: tickerProvider!);
    Animation<double> animation =
        CurvedAnimation(parent: controllerAnim, curve: Curves.fastOutSlowIn);

    controllerAnim.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controllerAnim.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerAnim.dispose();
      }
    });

    controllerAnim.forward();
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

  Map<double, MaterialColor> defaultGradient = {
    0.25: Colors.blue,
    0.55: Colors.green,
    0.85: Colors.yellow,
    1.0: Colors.red,
  };

  void playSlider() {
    // Start or resume the timer
    isPlaying.value = true;
    _sliderTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (selectedDay.value < difference.value) {
        selectedDay.value++; // Move to the next day
        sliderChanged(selectedDay.value.toDouble());
      } else {
        stopSlider(); // Stop when we reach the last day
      }
    });
  }

  void stopSlider() {
    // Stop the timer
    _sliderTimer?.cancel();
    isPlaying.value = false;
  }

  void restartSlider() {
    // Reset the slider to the first day and restart playback
    selectedDay.value = 1;
    sliderChanged(selectedDay.value.toDouble());
    playSlider(); // Start playing again from day 1
  }

  void togglePlayPause() {
    if (selectedDay.value == difference.value) {
      // If slider is at the end, restart from the beginning
      restartSlider();
    } else if (isPlaying.value) {
      // Pause the slider if it is playing
      stopSlider();
    } else {
      // Play the slider if it is paused
      playSlider();
    }
  }
}
