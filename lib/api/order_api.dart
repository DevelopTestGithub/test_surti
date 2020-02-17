//
//

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/models/order_group.dart';
import 'package:surtiSP/models/order_sp.dart';
import 'package:surtiSP/models/order_item.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/http/request.dart';
import 'package:surtiSP/util/user_Controller.dart';

enum EditProductAction {
  EDIT,
  ADD,
  DELETE,
}

class OrderApi {
  static Future<OrderGroup> getOrders(BuildContext context, {bool isClient = true}) async {
    if (Global.env.debugConf.offlineOrders) {
      var url = HTTP.getLocalAddress(Service.ORDER_GET);
      String data = await rootBundle.loadString(url);

      return OrderGroup.fromJson(
        json.decode(data),
      );
    }

    var url = HTTP.getAddress(Service.ORDER_GET);

    var userId = UserController.me.userId;
    if (isClient) {
      userId = UserController.client.userId;
    }

    var combinedURL = "$url$userId";

    GetRequest service = await Request.get(combinedURL, context);

    if (service.complete) {
      return OrderGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }

  static Future<ExtOrderGroup> getActiveOrders(BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_GET_ALL_ACTIVE);

    GetRequest service = await Request.get(url, context);

    if (service.complete) {
      return ExtOrderGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }

  static Future<List<OrderSP>> getOrders2Deliver(BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_GET_2_DELIVER);
    print(url);
    GetRequest service = await Request.get(url, context);

    if (service.complete) {
      var orders = json.decode(service.response);
      var ordersList = orders['entregas'] as List;
      var orders2deliver = ordersList.map((i) => OrderSP.fromJson(i)).toList();

      return orders2deliver;

    } else {
      return null;
    }
  }

  static Future<List<OrderSP>> getActiveOrdersByCustomer(OrderActiveByCustomer params, BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_GET_CUSTOMER_ACTIVE);
    var combinedURL = "$url${params.toString()}";

    print(combinedURL);
    GetRequest service = await Request.get(combinedURL, context);

    if (service.complete) {
      var orders = json.decode(service.response);
      var ordersList = orders['entregas'] as List;
      var orders2deliver = ordersList.map((i) => OrderSP.fromJson(i)).toList();

      return orders2deliver;

    } else {
      return null;
    }
  }

  static Future<List<OrderItem>> getUnifiedOrder(BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_GET_UNIFIED);

    print(url);

    GetRequest service = await Request.get(url, context);

    var unifiedOrder = json.decode(service.response);
    var itemsDynamic = unifiedOrder['consolidadoItem'] as List;
    var itemsReady = itemsDynamic.map((i) => OrderItem.fromJson(i)).toList();

    if (service.complete) {
      return itemsReady;
    } else {
      return null;
    }
  }

  static Future<ExtOrderGroup> getOrderById(int _orderId, BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_GET_BY_ID);
    var combinedURL = "$url${_orderId.toString()}";

    print('$combinedURL');

    GetRequest service = await Request.get(combinedURL, context);
    print('${json.decode(service.response)}');

    if (service.complete) {
      return ExtOrderGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }

  static Future<String> cancelOrder(int orderId, BuildContext context) async {
    if (Global.env.debugConf.offlineOrders) {
      var url = HTTP.getLocalAddress(Service.ORDER_CANCEL) + orderId.toString();
      String data = await rootBundle.loadString(url);
      return data; //OrderGroup.fromJson(
      //json.decode(data),
      //);
    }

    var url = HTTP.getAddress(Service.ORDER_CANCEL);
    var combinedURL = "$url${orderId}";

    GetRequest service = await Request.post(combinedURL, context);

    if (service.complete) {
      return service
          .response; //OrderGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }

  static Future<String> shipOrder(int orderId, VoidCallback complete, BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_SHIPPED);
    var combinedURL = "$url$orderId";
    print(combinedURL);
    GetRequest service = await Request.put(combinedURL, context);
    if (service.complete) {
      complete();
      return service.response;
    } else {
      complete();
      return null;
    }
  }

  static Future<String> deliverOrder(int orderId, VoidCallback complete, BuildContext context) async {
    var url = HTTP.getAddress(Service.ORDER_DELIVERED);
    var combinedURL = "$url$orderId";
    print(combinedURL);
    GetRequest service = await Request.put(combinedURL, context);
    if (service.complete) {
      complete();
      return service.response;
    } else {
      complete();
      return null;
    }
  }

  static Future<bool> editProduct(
      EditProductAction action,
      int orderId,
      int productId,
      int quantity,
      BuildContext context,
    ) async {

    var url = HTTP.getAddress(Service.ORDER_UPDATE_PRODUCT);
    GetRequest service;

    switch(action){

      case EditProductAction.EDIT:
        // TODO: Handle this case.
        break;
      case EditProductAction.ADD:
        String combinedURL = url + "?order_id=$orderId&product_id=$productId&quantity=${quantity.toString()}";
        print(combinedURL);
        service = await Request.post(combinedURL, context);
        break;
      case EditProductAction.DELETE:
        String combinedURL = url + "?order_id=$orderId&product_id=$productId&quantity=0";
        print(combinedURL);
        service = await Request.delete(combinedURL, context);
        break;
    }

    if (service.complete) {
      print('${service.response}');
      if(service.response.contains("Ok")){
        return true;
      } else {
      return null;
      }
    }

  }

}

class OrderActiveByCustomer {
  String customerId;

  OrderActiveByCustomer(this.customerId);

  String toString() {
    return "/customer/$customerId?limit=250&page=1";
  }
}
