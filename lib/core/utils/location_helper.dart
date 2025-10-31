import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<String> getCurrentLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return 'Lokasi tidak tersedia';

      final position = await Geolocator.getCurrentPosition();
      return '${position.latitude}, ${position.longitude}';
    } catch (e) {
      return 'Lokasi gagal diambil';
    }
  }
}