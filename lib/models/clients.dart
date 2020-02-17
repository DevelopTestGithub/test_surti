import 'package:surtiSP/models/shipping.dart';
import 'package:surtiSP/models/user.dart';

class Client {

  String ruc;
  String email;
  String firstName;
  String lastName;
  String businessName;
  ShippingAddress shippingAddress;
  bool isBasic;
  int id;

  Client({
    this.id,
    this.ruc,
    this.email,
    this.firstName,
    this.lastName,
    this.businessName,
    this.shippingAddress,
    this.isBasic,
  });

  factory Client.fromJson(Map<String, dynamic> json) {

    var shippingAddressReceived = json['shipping_address'];
    var shipping = ShippingAddress.fromJson(shippingAddressReceived);
    return Client(
      id: json['id'],
      ruc: json['ruc'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      businessName: json['business_name'],
      isBasic: json["is_basic"],
      shippingAddress: shipping
    );
  }

   User fromClient(){

     User user = User();
     user.userId = this.id.toString();
     user.name= this.businessName.toString();
     user.lastName=this.lastName.toString();
     return user;
   }
}
