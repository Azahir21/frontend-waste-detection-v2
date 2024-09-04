import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:frontend_waste_management/app/modules/maps/controllers/maps_controller.dart';
import 'package:frontend_waste_management/app/widgets/app_text.dart';
import 'package:frontend_waste_management/app/widgets/icon_button.dart';
import 'package:frontend_waste_management/core/values/app_icon_name.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SmallScreenMapsView extends StatefulWidget {
  const SmallScreenMapsView({super.key});

  @override
  State<SmallScreenMapsView> createState() => _SmallScreenMapsViewState();
}

class _SmallScreenMapsViewState extends State<SmallScreenMapsView> {
  final controller = Get.find<MapsController>();
  List<Map<double, MaterialColor>> gradients = [
    HeatMapOptions.defaultGradient,
  ];

  @override
  Widget build(BuildContext context) {
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
                child: FlutterMap(
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
                    onPositionChanged: (MapPosition position, bool hasGesture) {
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
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      // 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                      // 'https://tiles.stadiamaps.com/tiles/alidade_satellite/{z}/{x}/{y}{r}.jpg',
                      // retinaMode: true,
                      tileProvider: CancellableNetworkTileProvider(
                        silenceExceptions: true,
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        //loading data
                        visible: !controller.isLoading.value,
                        child: Visibility(
                          // switch heatmap and cluster
                          visible: !controller.isHeatmap.value,
                          replacement: HeatMapLayer(
                            heatMapDataSource: InMemoryHeatMapDataSource(
                                data: controller.weightedLatLng.toList()),
                            heatMapOptions: HeatMapOptions(
                                gradient: this.gradients[0], minOpacity: 0.1),
                            reset: controller.streamController.value.stream,
                          ),
                          child: controller.markers.isEmpty
                              ? Center(
                                  child: AppText.labelSmallDefault(
                                      AppLocalizations.of(context)!
                                          .no_data_found,
                                      context: context),
                                )
                              : SuperclusterLayer.immutable(
                                  initialMarkers: controller.markers.toList(),
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
                                            controller.defaultGradient),
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
                                ),
                        ),
                      ),
                    ),
                    const MapCompass.cupertino(
                        hideIfRotatedNorth: true,
                        // padding: EdgeInsets.fromLTRB(32, 230, 35, 32), base position apabila ada 3 button di atas
                        padding: EdgeInsets.fromLTRB(32, 168, 35, 0)),
                    CurrentLocationLayer(
                      alignPositionStream:
                          controller.alignPositionStreamController.value.stream,
                      alignPositionOnUpdate:
                          controller.alignPositionOnUpdate.value,
                    ),
                  ],
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

            Obx(
              () => Padding(
                padding: const EdgeInsets.all(32),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CustomIconButton.secondary(
                    iconName: controller.isHeatmap.value
                        ? AppIconName.markermap
                        : AppIconName.heatmap,
                    onTap: () {
                      controller.isHeatmap.value = !controller.isHeatmap.value;
                    },
                    context: context,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(32, 100, 32, 32),
              child: Align(
                alignment: Alignment.topRight,
                child: CustomIconButton.secondary(
                  iconSize: 24,
                  iconName: AppIconName.cursor,
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
            ),

            // filter button jangan dihapus
            // Padding(
            //   padding: const EdgeInsets.all(32.0),
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: CustomIconButton.secondary(
            //         iconName: AppIconName.filter,
            //         onTap: () {
            //           Get.dialog(
            //             barrierDismissible: false,
            //             filterDialog(),
            //           );
            //         },
            //         context: context),
            //   ),
            // ),

            // heatmap button jangan dihapus
            // Obx(
            //   () => Padding(
            //     padding: const EdgeInsets.fromLTRB(32, 100, 32, 32),
            //     child: Align(
            //       alignment: Alignment.topRight,
            //       child: CustomIconButton.secondary(
            //         iconName: controller.isHeatmap.value
            //             ? AppIconName.markermap
            //             : AppIconName.heatmap,
            //         onTap: () {
            //           controller.isHeatmap.value = !controller.isHeatmap.value;
            //         },
            //         context: context,
            //       ),
            //     ),
            //   ),
            // ),

            // centered camera button jangan dihapus
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(32, 168, 32, 32),
            //   child: Align(
            //     alignment: Alignment.topRight,
            //     child: CustomIconButton.secondary(
            //       iconSize: 24,
            //       iconName: AppIconName.cursor,
            //       onTap: () {
            //         setState(
            //           () => controller.alignPositionOnUpdate.value =
            //               AlignOnUpdate.always,
            //         );
            //         controller.alignPositionStreamController.value.add(18);
            //       },
            //       context: context,
            //     ),
            //   ),
            // ),

            // Padding(
            //   padding: const EdgeInsets.all(32),
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       width: double.infinity,
            //       height: 100,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(15),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.5),
            //             spreadRadius: 5,
            //             blurRadius: 7,
            //             offset: const Offset(0, 3),
            //           ),
            //         ],
            //       ),
            //       child: Column(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.fromLTRB(0, 10, 18, 5),
            //             child: Align(
            //               alignment: Alignment.topRight,
            //               child: AppText.labelSmallEmphasis(
            //                   AppLocalizations.of(context)!.day_count(controller.difference.value),
            //                   context: context),
            //             ),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.fromLTRB(0, 0, 18, 5),
            //             child: Align(
            //               alignment: Alignment.bottomRight,
            //               child: Slider(
            //                 value: 0,
            //                 onChanged: (value) {},
            //                 min: 0,
            //                 max: controller.difference.toDouble(),
            //                 thumbColor: color.iconDefault,
            //                 activeColor: color.iconDefault,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
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
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      controller.lastDate.value = pickedDate;
                      controller.lastDateController.value.text =
                          pickedDate.toString();
                    });
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
