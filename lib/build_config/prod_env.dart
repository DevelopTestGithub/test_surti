//
//

import 'package:surtiSP/enums/environment_type.dart';
import 'package:surtiSP/models/debug_config.dart';
import 'package:surtiSP/models/env.dart';

/// RELEASE
///
/// DEBUGGING
///
/// Use debug mode during development, when you want to use hot reload.
/// usage: flutter run


class ProdEnv {
  static final Env env = Env(
    //

    vendorMode: false,
    environmentType: EnvironmentType.PRODUCTION,
    baseUrl: "https://surti-produ-nopc.azurewebsites.net",
    //baseUrl: "https://surti-test-nopc.azurewebsites.net",
  
    debugConf: DebugConf(
      //
      /*Default: false*/
      //
      useUserAuth: false,
      /*Default: false*/
      offlineCart: false,
      /*Default: false*/
      offlineLogin: false,
      /*Default: false*/
      offlineOrders: false,
      /*Default: false*/
      offlineProducts: false,
      /*Default: false*/
      offlineDiscounts: false,
      //
    ),
  );
}

