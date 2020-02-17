import 'package:flutter/material.dart';

enum OrderStatusType {
  DELIVERED, //enviado
  ON_THE_WAY,
  CANCELLED,
  ORDERED,
  LOADING
}

enum OrderShippingStatusType {
  DELIVERED, //enviado
  ON_THE_WAY,
  CANCELLED,
  ORDERED,
  LOADING
}

class OrderStatusString {
  static const String //
      DELIVERED = "Complete", //enviado
      ON_THE_WAY = "Processing",
      CANCELLED = "Cancelled",
      ORDERED = "Pending",
      LOADING = "LOADING";
}

class OrderShippingStatusString {
  static const String //
      DELIVERED = "Delivered", //enviado
      ON_THE_WAY = "Shipped",
      CANCELLED = "CANCELED",
      ORDERED = "NotYetShipped",
      LOADING = "LOADING";
}


class Order {
  OrderStatusType status;
  OrderShippingStatusType shippingStatus;
  double orderTotal;
  int totalItems;
  int id;
  DateTime orderDate;

  Order({
    @required this.status,
    @required this.shippingStatus,
    @required this.orderTotal,
    @required this.totalItems,
    @required this.id,
    @required this.orderDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      status: statusFromString(json['order_status']),
      shippingStatus: shippingStatusFromString(json['shipping_status']),
      orderTotal: json['order_total'],
      totalItems: json['order_items'],
      id: json['id'],
      orderDate: DateTime.parse(json['created_on_utc'].substring(0, 10) + " " + json['created_on_utc'].substring(11, 23)),
    );
  }

  static OrderStatusType statusFromString(String status) {
    switch (status) {
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
