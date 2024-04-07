import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample/utils/app_log.dart';

class LocationUtil {
  static CustomLocation? _lastKnownLocation;
  static CustomLocation? get lastKnownLocation => _lastKnownLocation;

  static Future<bool> get isGrantedPermission async {
    final status = await Geolocator.checkPermission();
    return isGranted(status);
  }

  static bool isGranted(LocationPermission status) {
    return status == LocationPermission.whileInUse ||
        status == LocationPermission.always;
  }

  static Future<CustomLocation?> getSafeCurrentPosition() async {
    try {
      return await currentPosition();
    } catch (e, s) {
      AppLog.e('LocationUtil', 'getSafeCurrentPosition failed: error $e', e, s);
      return _lastKnownLocation;
    }
  }

  static Future<CustomLocation?> currentPosition([int? timeout = 5]) async {
    if (Platform.isIOS) {
      var pos = await _currentPosition(timeout);
      if (pos != null) {
        return CustomLocation(
          latitude: pos.latitude,
          longitude: pos.longitude,
          timestamp: pos.timestamp,
        );
      }

      return _lastKnownLocation;
    }
    var location = convertFormGeoPosition(await _currentPosition(timeout));
    location ??= convertFormGeoPosition(
        await _currentPosition(timeout, forceAndroidLocationManager: true));
    if (location == null) return _lastKnownLocation;
    _lastKnownLocation = location;
    return location;
  }

  static Future<Position?> _currentPosition(int? timeout,
      {bool forceAndroidLocationManager = false}) async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeLimit: timeout == 0
            ? const Duration(seconds: 5)
            : Duration(seconds: timeout ?? 5),
      );
    } on Exception {
      debugPrint("can not get current location");
      return null;
    }
  }

  static Stream<Position> getStreamPosition() {
    return Geolocator.getPositionStream().doOnData((event) {
      _lastKnownLocation = convertFormGeoPosition(event);
    });
  }

  static CustomLocation? convertFormGeoPosition(Position? pos) {
    if (pos != null) {
      return CustomLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
        timestamp: pos.timestamp,
      );
    }
    return null;
  }

  // static CustomLocation? convertFormGoogleLatLng(LatLng? pos) {
  //   if (pos != null) {
  //     return CustomLocation(
  //       latitude: pos.latitude,
  //       longitude: pos.longitude,
  //     );
  //   }
  //   return null;
  // }

  // static LatLng? convertToGoogleLatLng(CustomLocation? pos) {
  //   if (pos != null) {
  //     return LatLng(
  //       pos.latitude,
  //       pos.longitude,
  //     );
  //   }
  //   return null;
  // }

  static Future? askPermission({
    VoidCallback? onGranted,
    VoidCallback? onDenied,
    VoidCallback? onDisableLocationService,
  }) async {
    bool grantedPermission = await isGrantedPermission;
    if (!grantedPermission) {
      grantedPermission = isGranted(await Geolocator.requestPermission());
    }
    if (!grantedPermission) {
      onDenied?.call();
      return;
    }
    final isServiceEnable = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnable) {
      onDisableLocationService?.call();
      return;
    }
    onGranted?.call();
  }

  static Position simulatePos = Position(
    latitude: 37.56648210,
    longitude: 126.98510375,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 1,
    headingAccuracy: 1,
  );

  static Position metaCrewPosition = Position(
    latitude: 10.7991792,
    longitude: 106.7220504,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 1,
    headingAccuracy: 1,
  );
}

class CustomLocation extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  const CustomLocation({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        timestamp,
      ];
}
