//
//

import 'package:flutter/cupertino.dart';
import 'package:surtiSP/api/cart_api.dart';
import 'package:surtiSP/models/user_status.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/wrappers/connection.dart';

class HttpCheck {
  ///Intermideary to check if the user has an active cart
  static void isUserActiveRoutine(
      UserStatusCallback cartActiveCallback, BuildContext context) {
    UserChecking.checkUserStatus((userActivity) {
      cartActiveCallback(userActivity);
    }, context);
  }
}

class UserChecking {
  static bool cartCheckInProcess = false;

  /// Asyncronous cart check online, this is sent to [UserController.cart]
  static void checkUserStatus(
      UserStatusCallback cartActive, BuildContext context) async {
    if (cartCheckInProcess) return;
    cartCheckInProcess = true;

    if (!Connection.isConnectedOnline()) {
//OFFLINE
      bool offlineActive = UserController.cart.getNumberOfProducts() > 0;
      int offlineCartCount = UserController.cart.getNumberOfProducts();
      double offlineCartValue = UserController.cart.getTotalInCart();
      UserStatus offline = UserStatus(
          activeOrdersNumber: 222,
          cartCount: offlineCartCount,
          cartValue: offlineCartValue,
          isActiveOrder: offlineActive,
          isCartActive: offlineActive);
      cartActive(offline);
      UserController.cart.allegedCartActive = offlineActive;
      UserController.cart.allegedCartCount = offlineCartCount;
      UserController.cart.allegedCartValue = offlineCartValue;
      UserController.me.hasActiveOrders = offlineActive;
    } else {
//ONLINE
      UserStatus user = await CartApi.isCartActive(context);

      //bool isCartActive = cartState.isItActive;
      UserController.cart.allegedCartActive = user.isCartActive;
      UserController.cart.allegedCartCount = user.cartCount;
      UserController.cart.allegedCartValue = user.cartValue;
      UserController.me.hasActiveOrders = user.isActiveOrder;
      cartActive(user);
      cartCheckInProcess = false;
    }
  }
}
