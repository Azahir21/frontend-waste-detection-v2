import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:frontend_waste_management/app/modules/maps/controllers/maps_controller.dart';
import 'package:frontend_waste_management/app/modules/maps/views/widgets/maps_type_dialog.dart';
import 'package:frontend_waste_management/app/modules/maps/views/widgets/popup.dart';
import 'package:frontend_waste_management/app/modules/maps/views/widgets/timeseries_filter_widget.dart';
import 'package:frontend_waste_management/app/modules/maps/views/widgets/waste_type_filter_widget.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/custom_snackbar.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/app/widgets/text_button.dart';
import 'package:frontend_waste_management/core/theme/theme_data.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> with TickerProviderStateMixin {
  final controller = Get.find<MapsController>();
  List<Map<double, MaterialColor>> gradients = [
    HeatMapOptions.defaultGradient,
  ];

  @override
  void initState() {
    super.initState();
    controller.tickerProvider = this;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).appColors;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => Visibility(
                visible: !controller.isLoading.value,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: Obx(
                  () => FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: controller.curruntPosition.value,
                      initialZoom: 10,
                      maxZoom: 18,
                      minZoom: 5,
                      cameraConstraint: CameraConstraint.contain(
                        bounds: LatLngBounds(
                          const LatLng(-90, -180),
                          const LatLng(90, 180),
                        ),
                      ),
                      onPositionChanged:
                          (MapPosition position, bool hasGesture) {
                        if (hasGesture &&
                            controller.alignPositionOnUpdate !=
                                AlignOnUpdate.never) {
                          setState(() {
                            controller.alignPositionOnUpdate.value =
                                AlignOnUpdate.never;
                          });
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            // 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                        // 'https://tiles.stadiamaps.com/tiles/alidade_satellite/{z}/{x}/{y}{r}.jpg',
                        // retinaMode: true,
                        tileProvider: CancellableNetworkTileProvider(
                          silenceExceptions: true,
                        ),
                      ),
                      Obx(
                        () {
                          // Show layer based on the selected mode
                          if (controller.mapsMode.value == 'heatmap') {
                            return controller.weightedLatLng.isNotEmpty
                                ? HeatMapLayer(
                                    heatMapDataSource:
                                        InMemoryHeatMapDataSource(
                                      data: controller.weightedLatLng.toList(),
                                    ),
                                    heatMapOptions: HeatMapOptions(
                                      gradient: gradients[0],
                                      minOpacity: 0.1,
                                    ),
                                    reset: controller
                                        .streamController.value.stream,
                                  )
                                : Center(
                                    child: AppText.labelSmallDefault(
                                      AppLocalizations.of(context)!
                                          .no_data_found,
                                      context: context,
                                    ),
                                  );
                          } else if (controller.mapsMode.value == 'cluster') {
                            return controller.markers.isNotEmpty
                                ? SuperclusterLayer.mutable(
                                    initialMarkers: controller.markers.toList(),
                                    controller:
                                        controller.superclusterController.value,
                                    clusterWidgetSize: const Size(40, 40),
                                    indexBuilder: IndexBuilders.rootIsolate,
                                    builder: (context, position, markerCount,
                                        extraClusterData) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: controller.interpolateColor(
                                            markerCount / 20,
                                            controller.defaultGradient,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            markerCount.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: AppText.labelSmallDefault(
                                      AppLocalizations.of(context)!
                                          .no_data_found,
                                      context: context,
                                    ),
                                  );
                          } else if (controller.mapsMode.value == 'marker') {
                            return controller.markers.isNotEmpty
                                ? MarkerLayer(
                                    markers: controller.markers.toList())
                                : Center(
                                    child: AppText.labelSmallDefault(
                                      AppLocalizations.of(context)!
                                          .no_data_found,
                                      context: context,
                                    ),
                                  );
                          } else {
                            return Container(); // Default empty layer if no mode matches
                          }
                        },
                      ),
                      const MapCompass.cupertino(
                          hideIfRotatedNorth: true,
                          padding: EdgeInsets.fromLTRB(32, 304, 35, 32)),
                      CurrentLocationLayer(
                        alignPositionStream: controller
                            .alignPositionStreamController.value.stream,
                        alignPositionOnUpdate:
                            controller.alignPositionOnUpdate.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomIconButton.secondary(
                    iconName: AppIconName.backButton,
                    onTap: () {
                      Get.back();
                    },
                    context: context),
              ),
            ),

            Positioned(
              top: 32,
              right: 32,
              child: CustomIconButton.secondary(
                iconName: AppIconName.filter,
                onTap: () {
                  controller.showFilter.value = !controller.showFilter.value;
                  if (controller.showFilter.value == true &&
                      (controller.filterDataType.value !=
                              controller.previousFilterDataType ||
                          controller.filterStatus.value !=
                              controller.previousFilterStatus)) {
                    controller.filterDataType.value =
                        controller.previousFilterDataType;
                    controller.filterStatus.value =
                        controller.previousFilterStatus;
                  }
                  if (controller.showTimeSeries.value == true ||
                      controller.showMapsType.value == true) {
                    controller.showTimeSeries.value = false;
                    controller.showMapsType.value = false;
                  }
                },
                context: context,
              ),
            ),
            // WasteTypeFilterWidget.
            const WasteTypeFilterWidget(),
            // Timeseries Filter Button.
            Positioned(
              top: 100,
              right: 32,
              child: CustomIconButton.secondary(
                iconName: AppIconName.timeseries,
                onTap: () {
                  controller.showTimeSeries.value =
                      !controller.showTimeSeries.value;
                  if (controller.showFilter.value == true ||
                      controller.showMapsType.value == true) {
                    controller.showFilter.value = false;
                    controller.showMapsType.value = false;
                    controller.filterDataType.value =
                        controller.previousFilterDataType;
                    controller.filterStatus.value =
                        controller.previousFilterStatus;
                  }
                },
                context: context,
              ),
            ),
            // Timeseries Filter Widget.
            const TimeSeriesFilterWidget(),
            // Maps Type switcher button.
            Positioned(
              top: 168,
              right: 32,
              child: Obx(
                () => CustomIconButton.activeBordered(
                  iconName: controller.mapsMode.value == 'marker'
                      ? AppIconName.markermap
                      : controller.mapsMode.value == 'cluster'
                          ? AppIconName.cluster
                          : AppIconName.heatmap,
                  onTap: () {
                    controller.showMapsType.value =
                        !controller.showMapsType.value;
                    if (controller.showFilter.value == true ||
                        controller.showTimeSeries.value == true) {
                      controller.showFilter.value = false;
                      controller.showTimeSeries.value = false;
                      controller.filterDataType.value =
                          controller.previousFilterDataType;
                      controller.filterStatus.value =
                          controller.previousFilterStatus;
                    }
                  },
                  context: context,
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.showMapsType.value,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 168, 100, 32),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: MapsTypeDialog(),
                  ),
                ),
              ),
            ),

            // Maps Type Dialog.
            if (controller.showMapsType.value)
              Positioned(
                top: 168,
                right: 100,
                child: MapsTypeDialog(),
              ),
            // My Location Button.
            Positioned(
              top: 236,
              right: 32,
              child: CustomIconButton.secondary(
                iconSize: 24,
                iconName: AppIconName.myLocation,
                onTap: () {
                  setState(
                    () => controller.alignPositionOnUpdate.value =
                        AlignOnUpdate.always,
                  );
                  controller.alignPositionStreamController.value.add(18);
                },
                context: context,
              ),
            ),

            // Inside your widget where the slider box is located
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(32),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible: controller.timeseriesData
                        .isNotEmpty, // Show only if timeseries data exists
                    child: Container(
                      width: double.infinity,
                      height: 138,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextButton.primary(
                                  text: AppLocalizations.of(context)!.reset,
                                  onPressed: () {
                                    controller.resetTimeSeries();
                                  },
                                  context: context,
                                ),
                                // Play/Pause/Restart Button
                                GestureDetector(
                                  onTap: () {
                                    controller
                                        .togglePlayPause(); // Toggle play/pause/restart
                                  },
                                  child: Icon(
                                    controller.selectedDay.value ==
                                            controller.difference.value
                                        ? Icons
                                            .restart_alt // Show restart icon if at the last day
                                        : controller.isPlaying.value
                                            ? Icons
                                                .pause // Show pause icon if playing
                                            : Icons.play_arrow,
                                    // Show play icon if paused
                                  ),
                                ),
                                AppText.labelSmallEmphasis(
                                  AppLocalizations.of(context)!
                                      .day_count(controller.selectedDay.value),
                                  context: context,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Slider(
                              value: controller.selectedDay.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  controller.sliderChanged(value);
                                });
                              },
                              min: 1,
                              max: controller.difference.toDouble(),
                              thumbColor: color.iconDefault,
                              activeColor: color.iconDefault,
                              divisions: controller.difference.value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 5),
                            child: Obx(() => SizedBox(
                                  height: 35,
                                  child: ToggleButtons(
                                    isSelected: [
                                      !controller.switcher.value,
                                      controller.switcher.value
                                    ],
                                    onPressed: (int index) {
                                      controller.switcher.value = index == 1;
                                      controller.sliderChanged(controller
                                          .selectedDay.value
                                          .toDouble());
                                    },
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: AppText.labelTinyDefault(
                                          AppLocalizations.of(context)!
                                              .daily_data,
                                          context: context,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: AppText.labelTinyDefault(
                                          AppLocalizations.of(context)!
                                              .cumulative_data,
                                          context: context,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.selectedMarkerDetail.value != null) {
                return Popup(detail: controller.selectedMarkerDetail.value!);
              }
              return Container(); // Return empty container when no marker is selected
            }),
          ],
        ),
      ),
    );
  }

  Widget filterDialog() {
    return AlertDialog(
      title: AppText.labelDefaultEmphasis(
          AppLocalizations.of(context)!.filter_timeseries,
          context: context),
      content: IntrinsicHeight(
        child: Column(
          children: [
            Obx(
              () => TextFormField(
                controller: controller.firstDateController.value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.start_date,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), // Default to current date
                    firstDate: DateTime(2024, 5), // Start from May 2024
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      controller.firstDate.value = pickedDate;
                      controller.firstDateController.value.text =
                          pickedDate.toString();
                    });
                  }
                },
              ),
            ),
            Obx(
              () => TextFormField(
                controller: controller.lastDateController.value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.end_date,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  // Open the date picker for the "End Date"
                  if (controller.firstDateController.value.text.isNotEmpty) {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          controller.firstDate.value, // Start from Start Date
                      firstDate: controller
                          .firstDate.value, // End date must be after Start Date
                      lastDate: DateTime.now(),
                    );

                    // If a date is picked, update the end date controller
                    if (pickedDate != null) {
                      setState(() {
                        controller.lastDate.value = pickedDate;
                        controller.lastDateController.value.text =
                            pickedDate.toString();
                      });
                    }
                  } else {
                    showFailedSnackbar(
                      AppLocalizations.of(context)!.failed_to_pick_end_date,
                      AppLocalizations.of(context)!
                          .please_input_start_date_first,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.firstDateController.value.text = "";
            controller.lastDateController.value.text = "";
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            controller.getTimeseriesData();
            Get.back();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }
}
