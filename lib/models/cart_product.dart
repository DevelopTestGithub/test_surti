

//
//

import 'package:surtiSP/models/product.dart';

//TODO: sku, stock_quantity, has_tier_prices, manufacturer_ids, category_ids[], short_description


class CartProduct {
  final Product product;
  int quantity;
  final int id;

  CartProduct({this.product, this.quantity, this.id});

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    print(" product image ${json['images'].toString()} ");

    return CartProduct(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      id: json['id'],
    );
    
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    //! FIX: Image list needs desearializing in array format
    map["product"] = product.toMap();
    map["quantity"] = quantity;
    map["id"] = id;
    return map;
  }
}
