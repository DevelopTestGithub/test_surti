
class OrderSP {
  final int id;
  final String firstName;
  final String lastName;
  final String businessName;
  final String code;
  final String address;
  final double priceTotal;
  final String phoneNumber;
  final String orderStatus;

  OrderSP({
    this.id,
    this.businessName,
    this.firstName,
    this.lastName,
    this.address,
    this.code,
    this.priceTotal,
    this.phoneNumber,
    this.orderStatus,
  });

  factory OrderSP.fromJson(Map<String, dynamic> json) {

    return OrderSP(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      priceTotal: json['price_total'],
      phoneNumber: json['phone_number'],
      orderStatus: json['order_status'],
      code: json['code'],
      businessName: json['business_name'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["address"] = address;
    map["price_total"] = priceTotal;
    map["phone_number"] = phoneNumber;
    map["code"] = code;
    map["order_status"] = orderStatus;
    map["business_name"] = businessName;
    return map;
  }

  String getStatus(){

    String status = "";
    if( "Pending" == orderStatus){
      status = "Ordenada";
    } else if("Processing" == orderStatus){
      status = "En camino";
    } else if ( "Complete" == orderStatus){
      status = "Entregada";
    } else if ( "Cancelled" == orderStatus){
      status = "Cancelada";
    }

    return status;
  }
}


