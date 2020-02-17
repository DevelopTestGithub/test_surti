
import 'package:surtiSP/models/product.dart';

class OrderItem {
  final int id;
  final double priceWithTax;
  final double priceNoTax;
  final Product item;
  int quantity;

  OrderItem({
    this.id,
    this.quantity,
    this.priceWithTax,
    this.priceNoTax,
    this.item,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    json['product']['ammount'] = json['quantity'];
    var product = Product.fromJson(json['product']);
    
    return OrderItem(
      id: json['name'],
      quantity: json['quantity'],
      priceNoTax: json['price_excl_tax'],
      priceWithTax: json['price_incl_tax'],
      item: product,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity; //supposed this works
    map["price_incl_tax"] = priceWithTax;
    map["prince_excl_tax"] = priceNoTax;
    map["order_items"] = item;
    return map;
  }
}
