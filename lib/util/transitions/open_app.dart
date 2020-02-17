

import 'package:flutter_appavailability/flutter_appavailability.dart';

class OpenApp {
  static launch (String packageName, String appName){
    AppAvailability.launchApp(packageName);
  }
}