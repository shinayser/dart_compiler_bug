import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'utils.dart' as utils;

class UserLocation {
  double latitude;
  double longitude;
  String deviceId;

  UserLocation({
    @required this.latitude,
    @required this.longitude,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "deviceId": deviceId,
      };

  static Future<UserLocation> buildFromPosition(Position position) async {
    if (position == null) return null;

    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      deviceId: await utils.deviceId,
    );
  }
}
