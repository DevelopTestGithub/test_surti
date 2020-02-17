//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/models/jwt_token.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/wrappers/jwt.dart';

class Login {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final bool tokenValidated;
  final String userId;

  Login({this.accessToken, this.tokenType, this.refreshToken, this.tokenValidated, this.userId});

  factory Login.fromJson(Map<String, dynamic> json,
      {@required String audience}) {
    var jsonString = json.toString();
    String token = json['access_token'];
    String refreshToken = json['refresh_token'];
    var jwtData = JWTToken.process(token, aud: audience);

    if (jwtData == null) {
      return Login(
          accessToken: "", tokenType: "", userId: "", tokenValidated: false);
    }

    if (jwtData.isValid) {
      UserController.me.token = token;
      JWT.injectToCode(jwtData, refreshToken: refreshToken);
    }

    return Login(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        refreshToken: json['refresh_token'],
        userId: jwtData.id,
        tokenValidated: jwtData.isValid);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["access_token"] = accessToken;
    map["token_type"] = tokenType;
    return map;
  }
}
