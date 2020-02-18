import 'package:dart_compiler_bug/classes/user_location.dart';
import 'package:geolocator/geolocator.dart';

class Requests {
  static Future<bool> finishOrCancelRecover(
    int localId,
    bool aBool, [
    UserLocation userLocation,
  ]) async {
    print(
        'The value of \'localId\' now changed to $localId and now it is a \'double\'');
    return Future.delayed(Duration(milliseconds: 1000), () => true);
  }
}
