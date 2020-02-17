//
//

import 'package:surtiSP/models/image.dart';
import 'package:surtiSP/models/order_item.dart';

//TODO: sku, stock_quantity, has_tier_prices, manufacturer_ids, category_ids[], short_description

class Product {
  final String name;
  final List<ImageDataReceived> images;
  final String description;
  int ammount;
  final int id;
  final double price;
  final List<int> discountIds;

  int numberForCart = 1;
  final Map<String, dynamic> jsonLoaded;

  Product(
      {this.name,
      this.images,
      this.description,
      this.price,
      this.jsonLoaded,
      this.ammount,
      this.id,
      this.discountIds});

  void setAmmountForCart(int ammount) {
    numberForCart = ammount;
  }

  int getAmmountForCart() {
    return numberForCart;
  }

  //TODO: Ammount of products,

  factory Product.fromJson(Map<String, dynamic> json) {
    var imageListDyna = json['images'] as List;
    var imagesReady =
        imageListDyna.map((i) => ImageDataReceived.fromJson(i)).toList();

    List<int> discountIds = new List<int>();
    List discountIdsInDynamic = json['discount_ids'];
    if (discountIdsInDynamic != null) {
      int cachedSize = discountIdsInDynamic.length;
      for (int i = 0; i < cachedSize; i++) {
        discountIds.add(discountIdsInDynamic[i]);
      }
    }

    return Product(
      name: json['name'],
      images: imagesReady,
      price: json['price'],
      ammount: json['ammount'],
      jsonLoaded: json,
      id: json['id'],
      description: json['full_description']
          .toString()
          .replaceAll("<p>", "")
          .replaceAll("</p>", ""),
      discountIds: discountIds,
    );
  }

  factory Product.fromProduct(Product product) {
    return Product.fromJson(product.jsonLoaded);
  }

  String getDataHash() {
    return "$name$description$price";
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    //! FIX: Image list needs desearializing in array format
    map["name"] = name;
    map["images"] = images; //supposed this works
    map["price"] = price;
    map["short_description"] = images;
    return map;
  }
}
