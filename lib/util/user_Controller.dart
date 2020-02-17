//
//

// To manage interfaced api data

import 'package:surtiSP/models/user.dart';
import 'package:surtiSP/util/user/cart_data.dart';
import 'package:surtiSP/util/money/discount_data.dart';

class UserController {
  /// Seller
  static User me;
  static User client;
  static CartData cart;
  static DiscountsUtil discounts;
  

  ///Discounts is not innited
  static void init() {
    me = User();
    client = User();
    cart = new CartData();
    discounts = new DiscountsUtil();
    cart.initCart();
  }
}
