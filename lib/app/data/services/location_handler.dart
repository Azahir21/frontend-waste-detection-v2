import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Get.snackbar(
        'Location services are disabled', 'Please enable the services');
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar(
          'Location permissions are denied', 'Please enable the permissions');
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Get.snackbar('Location permissions are permanently denied',
        'We cannot request permissions.');
    return false;
  }
  return true;
}

Future<String> getAddressFromLatLng(LatLng position) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  } catch (e) {
    debugPrint(e.toString());
    throw Exception('Failed to get address from coordinates');
  }
}
