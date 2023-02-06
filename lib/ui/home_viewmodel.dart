import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

import '../app/app.locator.dart';

class HomeViewModel extends BaseViewModel {
  Position? current_position;
  var target_latitude = -7.7769602;
  var target_longitude = 110.3835469;
  var r = 6371000;
  var distanceInMeters = 0.0;
  final _navigationService = locator<NavigationService>();

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        SnackBar(content: Text('Location permissions are denied'));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      current_position = position;
      print(current_position);
      var phi_1 = radians(current_position!.latitude);
      var phi_2 = radians(target_latitude);
      var delta_phi = radians(target_latitude - current_position!.latitude);
      var delta_lambda =
          radians(target_longitude - current_position!.longitude);
      var a = pow(sin(delta_phi / 2.0), 2) +
          cos(phi_1) * cos(phi_2) * pow(sin(delta_lambda / 2.0), 2);
      var c = 2 * atan2(sqrt(a), sqrt(1 - a));
      distanceInMeters = r * c;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getDistance() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      current_position = position;

      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
