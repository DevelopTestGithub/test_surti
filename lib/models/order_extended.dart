//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/models/order.dart';
import 'package:surtiSP/models/address.dart';
import 'package:surtiSP/models/order_item.dart';

import 'consts/texts_es.dart';

class OrderExtended {
  int id;
  int customerId;
  OrderStatusType status;
  OrderShippingStatusType shippingStatus;
  double orderTotal;
  List<OrderItem> items;
  DateTime orderDate;
  Address shippingAddress;

  OrderExtended({
    @required this.id,
    @required this.customerId,
    @required this.status,
    @required this.shippingStatus,
    @required this.orderTotal,
    //@required this.totalItems,
    @required this.items,
    @required this.orderDate,
    @required this.shippingAddress,
  });

  factory OrderExtended.fromJson(Map<String, dynamic> json) {
    var jsonString = json.toString();
    var itemsDynamic = json['order_items'] as List;
    var itemsReady =  itemsDynamic.map((i)=> OrderItem.fromJson(i)).toList();

    return OrderExtended(
        id: json['id'],
        customerId: json['customer_id'],
        status: statusFromString(json['order_status']),
        shippingStatus: shippingStatusFromString(json['shipping_status']),
        orderTotal: json['order_total'],
        items:  itemsReady,
        shippingAddress: Address.fromJson(json['shipping_address']),
        orderDate: DateTime.parse(json['created_on_utc'].substring(0, 10) + " " + json['created_on_utc'].substring(11, 23)),
    );
  }

  static OrderStatusType statusFromString(String status) {
    switch (status) {
      case OrderStatusString.CANCELLED:
        return OrderStatusType.CANCELLED;
      case OrderStatusString.LOADING:
        return OrderStatusType.LOADING;
      case OrderStatusString.ORDERED:
        return OrderStatusType.ORDERED;
      case OrderStatusString.ON_THE_WAY:
        return OrderStatusType.ON_THE_WAY;
      case OrderStatusString.DELIVERED:
        return OrderStatusType.DELIVERED;
      case OrderStatusString.CANCELLED:
      default:
        return OrderStatusType.CANCELLED;
    }
  }

  static String statusFromType(OrderStatusType _status){
    switch(_status){

      case OrderStatusType.DELIVERED:
        return T.ORDER_DELIVERED_BTN;
        break;
      case OrderStatusType.ON_THE_WAY:
        return T.ORDER_ON_THE_WAY_BTN;
        break;
      case OrderStatusType.CANCELLED:
        return T.ORDER_CANCELLED_BTN;
        break;
      case OrderStatusType.ORDERED:
        return T.ORDER_ORDERED_BTN;
        break;
      case OrderStatusType.LOADING:
        return T.ORDER_LOADING_BTN;
        break;
    }

  }

  
  static OrderShippingStatusType shippingStatusFromString(String status) {
    switch (status) {
      case OrderShippingStatusString.LOADING:
        return OrderShippingStatusType.LOADING;
      case OrderShippingStatusString.ORDERED:
        return OrderShippingStatusType.ORDERED;
      case OrderShippingStatusString.ON_THE_WAY:
        return OrderShippingStatusType.ON_THE_WAY;
      case OrderShippingStatusString.DELIVERED:
        return OrderShippingStatusType.DELIVERED;
      case OrderShippingStatusString.CANCELLED:
      default:
        return OrderShippingStatusType.CANCELLED;
    }
  }

}
