
import 'package:url_launcher/url_launcher.dart';

class Navigate {
  static void to(double lat, double long, String name) async {
    String url =
        "https://waze.com/ul?q=$name&ll=$lat,$long&navigate=yes";

    await launch(url);
  }
}
