
import 'discount.dart';

class DiscountGroup {
  final List<Discount> discounts;
  final int id;

  DiscountGroup({this.id, this.discounts});

  factory DiscountGroup.fromJson(Map<String, dynamic> json) {

    var discountsDynamic = json['discounts'] as List;
    var discountsParsed = discountsDynamic.map((i) => Discount.fromJson(i)).toList();

    return DiscountGroup(id: json['id'], discounts: discountsParsed);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    //!FIX: not list serialized
    map["discounts"] = discounts; //supposed this works
    return map;
  }
}

