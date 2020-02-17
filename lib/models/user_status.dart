//
//

class UserStatus {
  bool isCartActive;
  bool isActiveOrder;
  final int cartCount;
  final int activeOrdersNumber;
  final double cartValue;

  UserStatus({
    this.isCartActive = false,
    this.cartCount = 0,
    this.activeOrdersNumber = 0,
    this.isActiveOrder = false,
    this.cartValue = 0,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    print("USER STATUS: ${json.toString()}");
    int activeOrdersNumber = json['ActiveOrders'];
    return UserStatus(
        isCartActive: !json['Response'],
        cartCount: json['Count'],
        cartValue: json['Value'],
        activeOrdersNumber: activeOrdersNumber,
        isActiveOrder: (activeOrdersNumber > 0) );
  }
  
  Map toMap() {
    var map = new Map<String, dynamic>();
    //! FIX: Image list needs desearializing in array format
    map["Response"] = !isCartActive;
    map["Count"] = cartCount;
    map["Value"] = cartValue;
    map['Order'] = activeOrdersNumber;
    return map;
  }

}
