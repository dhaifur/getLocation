import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

import '../../app/app.locator.dart';

class HomeViewModel extends BaseViewModel {
  Position? current_position;
  var targetLat = -7.777225675172034 * 0.0174533;
  var targetLon = 110.38356833500242 * 0.0174533;
  var R = 6317;
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
      print(current_position!.latitude);
      print(current_position!.longitude);
      var currentLat = position.latitude * 0.0174533;
      var currentLon = position.longitude * 0.0174533;
      var a = (targetLon - currentLon) * cos((currentLat + targetLat) / 2);
      var b = targetLat - currentLat;
      distanceInMeters = (sqrt(pow(a, 2) + pow(b, 2)) * R) * 1000;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
