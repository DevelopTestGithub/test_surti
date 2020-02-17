//
//

import 'package:surtiSP/models/user_status.dart';

class User {

  String user = "";
  String temporalPassword = "";
  
  bool loggedIn = false;
  bool hasActiveOrders = false;

  String name = "John";
  String lastName = "Stevens";

  DateTime tokenExpiry;

  String token = "";  
  String refreshToken = "";
  
  String userId = "";
  String promosId = "";
  String vegetablesId = "";
  String lacteosId = "";

  String currentId = "";

  double money = 200;

  // New PT_Code
  String ptCode = "";

  bool intent = false;

}
