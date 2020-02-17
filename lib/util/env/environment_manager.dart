//
//

import 'package:surtiSP/build_config/debug_env.dart';
import 'package:surtiSP/build_config/prod_env.dart';
import 'package:surtiSP/build_config/profile_env.dart';
import 'package:surtiSP/enums/environment_type.dart';
import 'package:surtiSP/models/env.dart';

class EnvironmentMn {
  static Env getEnvironment() {
    EnvironmentType type = _detectEnvironment();

    print("${EnvironmentType.DEBUG}");
    switch (type) {
      case EnvironmentType.PRODUCTION:
        return ProdEnv.env;
        break;
      case EnvironmentType.PROFILE:
        return ProfileEnv.env;
        break;
      case EnvironmentType.DEBUG:
      default:
        return DebugEnv.env;
    }
  }

  static EnvironmentType _detectEnvironment() {
    /* if in production we find dart.vm.product */
    if (const bool.fromEnvironment('dart.vm.product')) {
      return EnvironmentType.PRODUCTION; /*release*/
    }

    /* setup first, yes we can*/
    var result = EnvironmentType.PROFILE;

    assert(() {
      /* We can only asset in debug mode*/
      result = EnvironmentType.DEBUG;
      return true;
    }());

    return result;
  }
}
