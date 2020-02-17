//
//

import 'package:surtiSP/models/product.dart';

//TODO: sku, stock_quantity, has_tier_prices, manufacturer_ids, category_ids[], short_description

class ProductGroup {
  final List<Product> products;
  final int id;

  ProductGroup({this.id, this.products});

  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    var jsonString = json.toString();
    var productsDynamic = json['products'] as List;
    var productsParsed =
        productsDynamic.map((i) => Product.fromJson(i)).toList();
    return ProductGroup(id: json['id'], products: productsParsed);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    //!FIX: not list serialized
    map["products"] = products; //supposed this works
    return map;
  }
}
