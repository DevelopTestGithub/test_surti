

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:surtiSP/models/cart_product.dart';
import 'package:surtiSP/models/editedCartProduct.dart';
import 'package:surtiSP/models/user_status.dart';
import 'package:surtiSP/models/shoping_cart_group.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/http/request.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/wrappers/connection.dart';


enum CartDeleteType {
  PRODUCT,
  CLEAR,
}

class CartApi {
  static Future<UserStatus> isCartActive(BuildContext context) async {
    
    if (!Connection.isConnectedOnline()) return localCartActive();

    var url = HTTP.getAddress(Service.CART_ACTIVE);
    var combinedURL = "$url/${UserController.client.userId}";

    GetRequest service = await Request.get(combinedURL, context);

    if (service.complete) {
      return UserStatus.fromJson(json.decode(service.response));
    } else {
      return UserStatus(isCartActive: false);
    }
  }

  static Future<UserStatus> localCartActive() async {
    return UserStatus(
        isCartActive: UserController.cart.cartList.length > 0,
        activeOrdersNumber: 0,
        cartCount: UserController.cart.allegedCartCount,
        isActiveOrder: UserController.cart.allegedCartActive,
        cartValue: UserController.cart.allegedCartValue);
  }

  static Future<ShopingCarts> addProduct(
      CartPost params, BuildContext context, CartProduct product) async {
    // Change for client
    params.userId = UserController.client.userId;

    if (!Connection.isConnectedOnline()) return addLocalProduct(product);

    var url = HTTP.getAddress(Service.CART_ITEM_ADD);
    var combinedURL = "$url${params.toString()}";
    print(combinedURL);
    GetRequest service = await Request.post(combinedURL, context);
    /*  */
    if (service.complete) {
      UserController.cart.setCartAsActive();
      return ShopingCarts.fromJson(json.decode(service.response));
    } else {
      return ShopingCarts.empty();
    }

  }

  static Future<EditedCartProduct> editProductOrder(
      CartOrderEdit params, String id, BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_UPDATE_PRODUCT);
    var combinedURL = "$url${params.toString()}";

    GetRequest service = await Request.put(combinedURL, context);
    /*  */
    if (service.complete) {
      UserController.cart.setCartAsActive();
      return EditedCartProduct.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }

  static Future<EditedCartProduct> editProduct(
      CartEdit params, BuildContext context) async {
    if (!Connection.isConnectedOnline()) {
      UserController.cart.deleteProducts(int.parse(params.productId));
      return EditedCartProduct(
          deliveryDate: "offline",
          editedProduct: ShopingCarts(
              products: UserController.cart.cartList,
              type: DeliveryEstimatedTimeType.TODAY));
    }

    params.userId = UserController.client.userId;
    var url = HTTP.getAddress(Service.CART_ITEM_EDIT);
    var combinedURL = "$url${params.toString()}";

    GetRequest service = await Request.put(combinedURL, context);
    /*  */
    if (service.complete) {
      UserController.cart.setCartAsActive();
      return EditedCartProduct.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }

  static Future<bool> deleteProduct(
      CartDeleteProduct params, BuildContext context) async {
    if (!Connection.isConnectedOnline()) {
      UserController.cart.deleteProducts(params.productId);
      return true;
    }

    params.userId = UserController.client.userId;
    var url = HTTP.getAddress(Service.CART_ITEM_DELETE);
    var combinedURL = "$url${params.toString()}";

    print('$combinedURL');

    GetRequest service = await Request.delete(combinedURL, context);

    if (service.complete) {
      return service.response.contains("Ok") ? true : false;
    } else {
      return false;
    }
  }

  static Future<bool> clear(CartClear params, BuildContext context) async {
    var url = HTTP.getAddress(Service.CART_CLEAR);
    var combinedURL = "$url${params.toString()}";

    if (!Connection.isConnectedOnline()) {
      UserController.cart.deleteAllProducts();
      return true;
    }

    params.userId = UserController.client.userId;
    GetRequest service = await Request.delete(combinedURL, context);

    if (service.complete) {
      return service.response.contains("Ok") ? true : false;
    } else {
      return false;
    }
  }

  /* NOTE: poner a carrito offline, no significa que esta en online */
  static Future<ShopingCarts> addLocalProduct(CartProduct product) async {
    UserController.cart.addToCart(product);

    return ShopingCarts(products: UserController.cart.cartList);
  }

  static Future<ShopingCarts> viewCart(BuildContext context) async {
    if (!Connection.isConnectedOnline()) {
      return ShopingCarts(
          products: UserController.cart.cartList,
          type: DeliveryEstimatedTimeType.TODAY);
    }

    var url = HTTP.getAddress(Service.CART_ITEM_VIEW);
    var combinedURL = "$url/${UserController.client.userId}";

    GetRequest service = await Request.get(combinedURL, context);

    if (service.complete) {
      return ShopingCarts.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }
}

class CartPost {
  String userId;
  final String productId;
  final int quantity;

  CartPost(this.productId, {this.quantity = 1}) {
    userId = UserController.client.userId;
  }

  String toString() {
    return "/?inc_customer_id=${UserController.client.userId}&inc_product_id=$productId&inc_quantity=$quantity";
  }
}

class CartOrderEdit {
  final String productId;
  final String orderId;
  final int quantity;

  CartOrderEdit(this.productId, this.orderId, {this.quantity = 1});

  String toString() {
    return "?order_id=$orderId&product_id=$productId&quantity=$quantity";
  }
}

class CartEdit {
  String userId;
  final String productId;
  final int quantity;

  CartEdit(this.productId, {this.quantity = 1}) {
    userId = UserController.client.userId;
  }

  String toString() {
    return "$productId?quantity=$quantity&customerId=$userId";
  }
}

class CartDeleteProduct {
  String userId;
  final int productId;

  CartDeleteProduct(this.productId) {
    userId = UserController.client.userId;
  }

  String toString() {
    return '/?cart_item_id=$productId&inc_customer_id=${UserController.client.userId}';
  }
}

class CartClear {
  String userId;

  CartClear() {
    userId = UserController.client.userId;
  }

  String toString() {
    return '/?inc_customer_id=${UserController.client.userId}';
  }
}
