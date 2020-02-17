
import 'package:flutter/material.dart';

/// Debug Configuration
/// 
/// 
/// 
/// 

class DebugConf {
  //

  AutoLogin userAuth = AutoLogin(pasword: "", user: "");

  bool
      //
      offlineLogin, //false
      offlineProducts, //false
      offlineCart, //false
      offlineOrders, //false
      offlineDiscounts, //false
      useUserAuth //false
      //
      ;

  DebugConf({
    this.userAuth,
    this.useUserAuth = false,
    this.offlineCart = false,
    this.offlineProducts = false,
    this.offlineLogin = false,
    this.offlineOrders = false,
    this.offlineDiscounts = false,
  });

}

class AutoLogin {
  final String user, pasword;
  AutoLogin({this.user = "", this.pasword = ''});
}
