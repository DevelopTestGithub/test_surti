//
//

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/models/jwt_token.dart';
import 'package:surtiSP/models/login.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/util/app_events/events.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/http/request.dart';
import 'package:surtiSP/util/persistency/persistentData.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/wrappers/jwt.dart';


enum LoginState { LOADING, LOADED, INNACTIVE, FAILED, TIME_OUT }

class LoginApi {
  static const BURNED_AUDIENCE = "community@chariotentertainment.com";

  static Future<Login> connect(LoginSend params, BuildContext context) async {
    if (Global.env.debugConf.offlineLogin) {
      return localLogin(context);
    }
    
    var url = HTTP.getAddress(Service.LOGIN);
    var combinedURL = "$url${params.toString()}";
    
    print("LOGIN URL: $combinedURL");

    GetRequest service = await Request.post(combinedURL, context);

    if (service.complete) {
      return Login.fromJson(json.decode(service.response),
          audience: params.user);
    } else {
      return null;
    }
  }

  static Future<Login> localLogin(BuildContext context) async {
    var url = HTTP.getLocalAddress(Service.LOGIN);
    String data = await rootBundle.loadString(url);

    return Login.fromJson(json.decode(data), audience: BURNED_AUDIENCE);
  }

  static Future<String> refreshLoginWithRefreshToken(
      BuildContext context) async {
    var url = HTTP.getAddress(Service.REFRESH_TOKEN);
    var combinedURL = "$url/?refresh_token=${UserController.me.refreshToken}";
    print("$combinedURL");
    GetRequest service = await Request.post(combinedURL, context);
    if (service.complete) {
      Login response = Login.fromJson(json.decode(service.response));

      PersistentData.saveLoginTokens(
          response.accessToken, response.refreshToken);

      var jwtData =
          JWTToken.process(response.accessToken, aud: null); //cambiar audiencia

      if (jwtData == null) {
        Events.restartApp(context);
        return null;
      }

      JWT.injectToCode(jwtData, refreshToken: response.refreshToken);
      return response.refreshToken;
    } else {
      return null;
    }
  }

  // Creates Login session
  static void loginSessionCoroutine(LoginSend loginParams,
      LoginCallback callback, BuildContext context) async {
    callback(null, LoginState.LOADING);

    Login login = await LoginApi.connect(loginParams, context);

    if (login == null) {
      callback(null, LoginState.FAILED);
      return;
    }

    if (login.tokenValidated) {
      PersistentData.saveLoginTokens(login.accessToken, login.refreshToken);
      callback(null, LoginState.LOADED);
      return;
    }

    //null
    callback(null, LoginState.FAILED);
  }
}

class LoginSend {
  final String user;
  final String psw;
  LoginSend({this.user, this.psw});
  factory LoginSend.fromJson(Map<String, dynamic> json) {
    return LoginSend(user: json['username'], psw: json['password']);
  }
  String toString() {
    var map = new Map<String, dynamic>();
    map["username"] = user;
    map["password"] = psw;
    return "?username=$user&password=$psw";
  }
}

class RefreshToken {
  final String refreshToken;
  final String token;
  RefreshToken({this.refreshToken, this.token});
  factory RefreshToken.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return RefreshToken(
        refreshToken: json['refresh_token'], token: json['access_token']);
  }
}
