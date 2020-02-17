//
//

//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/wrappers/jwt.dart';

class JWTToken {
  final bool isValid;
  final String id;
  final String vegetablesId;
  final String promosId;
  final String lacteosId;
  final DateTime expiry;

  JWTToken({
    @required this.isValid,
    @required this.id,
    @required this.vegetablesId,
    @required this.promosId,
    @required this.lacteosId,
    @required this.expiry
  });

  factory JWTToken.jsonProcessedFromToken(
      Map<String, dynamic> json, JWTResponseData jwData, bool validation) {

    print(" ID FROM TOKEN VEG=${json['vegetales_id']} VEG=${UserController.me.currentId}");
    return JWTToken(
      id: json['customer_id'],
      vegetablesId: json['vegetales_id'],
      promosId: json['promos_id'],
      lacteosId: json['lacteos_id'],
      expiry: jwData.claim.expiry,
      isValid: validation,
    );

  }

  factory JWTToken.process(String token, {@required String aud}) {
    bool tokenValidity = false;
    var jwtData = JWT.validate(token, audience: aud);
    if (jwtData.success) {
      UserController.me.token = token;
      print('token: ${UserController.me.token}');
      tokenValidity = true;
    }
    var toParse = jwtData.claim;
    if(toParse == null){
      return null;
    }
    var jsonFromToken = toParse.toJson();
    return JWTToken.jsonProcessedFromToken(jsonFromToken, jwtData, tokenValidity);
  }

}
