import 'package:flutter/material.dart';
import 'package:surtiSP/enums/environment_type.dart';
import 'package:surtiSP/models/debug_config.dart';

/// Environment data
///
///[baseUrl] is the main domain for the environment.
///
///[debugConf] contains all the specialized data you can modify in that environment
///
class Env {
  String baseUrl;
  bool vendorMode;
  EnvironmentType environmentType;
  DebugConf debugConf;
  Env(
      {@required this.baseUrl,
      @required this.debugConf,
      @required this.environmentType,
      @required this.vendorMode});

  String toString() {
    switch (environmentType) {
      case EnvironmentType.PRODUCTION:
        return "";
        break;
      case EnvironmentType.PROFILE:
        return "App is in PROFILE Mode";
        break;
      case EnvironmentType.DEBUG:
      default:
        return "App is in DEBUG Mode";
    }
  }
}
