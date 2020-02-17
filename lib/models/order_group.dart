


import 'package:surtiSP/models/order.dart';
import 'package:surtiSP/models/order_extended.dart';

class OrderGroup {
  final List<Order> orders;
  final int id;

  OrderGroup({this.id, this.orders});

  factory OrderGroup.fromJson(Map<String, dynamic> json) {

    var productsDynamic = json['orders'] as List;
    var productsParsed = productsDynamic.map((i) => Order.fromJson(i)).toList();
    
    return OrderGroup(id: json['id'], orders: productsParsed);
  }
}

class ExtOrderGroup {
  final List<OrderExtended> orders;

  ExtOrderGroup({this.orders});

  factory ExtOrderGroup.fromJson(Map<String, dynamic> json) {

    var productsDynamic = json['orders'] as List;
    
    /* In case orders is not the correct one */
    if(productsDynamic == null){
      productsDynamic = json['consolidadoItem'] as List;
    }

    print("PRODUCT NUM ${productsDynamic.length}");
    var productsParsed = productsDynamic.map((i) => OrderExtended.fromJson(i)).toList();

    return ExtOrderGroup(orders: productsParsed);
  }
}