
enum DiscountType{
  DEFAULT,
  TOTAL,
  TO_PRODUCT,
//TODO: add more
}

class Discount {
  final int id;
  final String name;
  final int discountType;
  final bool isPercentage;
  final double discountAmount;
  final double discountPercentage;

  Discount({
    this.name,
    this.discountType,
    this.isPercentage,
    this.discountAmount,
    this.discountPercentage,
    this.id
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    print(" discountId: ${json['id'].toString()} - discountType: ${json['discount_type'].toString()}");

    return Discount(
      name: json['name'],
      discountType: json['discount_type'],
      isPercentage: json['is_percentage'],
      discountAmount: json['discount_amount'],
      discountPercentage: json['discount_percentage'],
      id: json['id'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    //! FIX: Image list needs desearializing in array format
    map["name"] = name;
    map["discount_type"] = discountType; //supposed this works
    map["is_percentage"] = isPercentage;
    map["discount_amount"] = discountAmount;
    map["discount_percentage"] = discountPercentage;
    map["id"] = id;
    return map;
  }

}