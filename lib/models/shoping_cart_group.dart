//
//

//
//

import 'package:surtiSP/models/cart_product.dart';

  //TODO: sku, stock_quantity, has_tier_prices, manufacturer_ids, category_ids[], short_description


enum DeliveryEstimatedTimeType {
  TODAY,
  TOMORROW,
}

class DeliveryEstimatedString {
  static const String TODAY = "Mañana", //enviado
      TOMORROW = "Lunes";
}

class ShopingCarts {
  final List<CartProduct> products;
  final DeliveryEstimatedTimeType type;
  ShopingCarts({this.products, this.type});

  factory ShopingCarts.fromJson(Map<String, dynamic> json) {
    var productsDynamic = json['shopping_carts'] as List;
    print("PRODUCTS LOADED    _ ${productsDynamic}");
    var productsParsed = productsDynamic.map((i) => CartProduct.fromJson(i)).toList();
    
    return ShopingCarts(products: productsParsed, type: estimatedTimeFromString(json['delivery_date'])); //estimated_time
  }

  factory ShopingCarts.empty(){
    return ShopingCarts(products: List<CartProduct>());
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["shopping_carts"] = products; //supposed this works
    map["delivery_date"] = type;
    return map;
  }

  static DeliveryEstimatedTimeType estimatedTimeFromString(String status) {
    switch (status) {
      case DeliveryEstimatedString.TODAY:
        return DeliveryEstimatedTimeType.TODAY;
      case DeliveryEstimatedString.TOMORROW:
        return DeliveryEstimatedTimeType.TOMORROW;
      default:
        return DeliveryEstimatedTimeType.TOMORROW;
    }
  }
}
