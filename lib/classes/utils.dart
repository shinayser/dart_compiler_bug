import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

extension ContextX on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
  NavigatorState get navigator => Navigator.of(this);
  NavigatorState get rootNavigator => Navigator.of(this, rootNavigator: true);
  FocusScopeNode get focusScope => FocusScope.of(this);
  ScaffoldState get scaffold => Scaffold.of(this);
}

Future<String> get deviceId async {
  final deviceInfo = DeviceInfoPlugin();

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return info.androidId;
      break;

    case TargetPlatform.iOS:
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return info.identifierForVendor;
      break;

    default:
      throw Exception("Plataform not supported for getting DeviceId");
      break;
  }
}

Future<Position> get lastKnownLocation async =>
    Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
