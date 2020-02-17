//
//

import 'package:surtiSP/enums/environment_type.dart';
import 'package:surtiSP/models/debug_config.dart';
import 'package:surtiSP/models/env.dart';

/// DEBUGGING
///
/// Use debug mode during development, when you want to use hot reload.
/// usage: flutter run

class DebugEnv {
  static final Env env = Env(
    //
    vendorMode: false,
    environmentType: EnvironmentType.DEBUG,
    baseUrl: "https://surti-test-nopc.azurewebsites.net",
    debugConf: DebugConf(

      /*Default: false*/
      useUserAuth: true,
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
      
      userAuth: AutoLogin(
        user: "jchauvin@mardisresearch.com", //fholguin@mardisresearch.com
        pasword: "Surt1-test-api",
      ),
    ),
  );
}
