import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/models/shoping_cart_group.dart';

//TODO: sku, stock_quantity, has_tier_prices, manufacturer_ids, category_ids[], short_description


class EditedCartProduct {

  final String deliveryDate;
  final ShopingCarts editedProduct;

  EditedCartProduct({this.deliveryDate, this.editedProduct});

  factory EditedCartProduct.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    //print(" product image ${json['images'].toString()} ");

    return EditedCartProduct(
      deliveryDate: json['delivery_date'],
    );

  }

}