//
//

import 'package:surtiSP/enums/environment_type.dart';
import 'package:surtiSP/models/debug_config.dart';
import 'package:surtiSP/models/env.dart';

/// PROFILE
///
/// Debug for Q/A
/// flutter run --profile

class ProfileEnv {
  static final Env env = Env(
    //

    vendorMode: false,
    environmentType: EnvironmentType.PROFILE,

    //!!!! TODO: CAMBIAR LNK
    baseUrl: "https://surti-test-nopc.azurewebsites.net/",
    //
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
        user: "1.0.5-alpha",
        pasword: "",        
      ),
    ),
  );
}
