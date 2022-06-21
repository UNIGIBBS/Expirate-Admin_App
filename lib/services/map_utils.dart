import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (!await launchUrl(
      Uri.parse(googleUrl),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch ${Uri.parse(googleUrl)}';
    }
  }
}