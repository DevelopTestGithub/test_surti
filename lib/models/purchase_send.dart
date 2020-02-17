
import 'package:surtiSP/models/user.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/util/user_Controller.dart';

class PurchaseSend {
  final User user;
  final String newUser;
  final String address;
  final String id;
  final String code;
  final int phoneNumber;

  final bool vendor;

  PurchaseSend(
      {this.user,
      this.newUser = "",
      this.phoneNumber = 0,
      this.vendor = false,
      this.id,
      this.code,
      this.address
      });
  factory PurchaseSend.fromJson(Map<String, dynamic> json) {
    return PurchaseSend(user: json['username']);
  }
  String toString() {
    var map = new Map<String, dynamic>();
    map["username"] = user;

    // Changes for vendor, id is extracted FROM selected client
    if (Global.env.vendorMode) {
      return "/?inc_customer_id=${UserController.client.userId}&name=$newUser&number=$phoneNumber&vendor=$vendor&id=$id&code=$code&address=$address";
    } else {
      return "/?inc_customer_id=${UserController.client.userId}";
    }
  }
}
