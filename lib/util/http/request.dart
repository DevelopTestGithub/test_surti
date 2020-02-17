
//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:surtiSP/api/login_api.dart';
import 'package:surtiSP/util/app_events/events.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/http/http_errors.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/util/user_Controller.dart';

enum RequestType { POST, PUT, GET, DELETE }

class Request {
  static Future<GetRequest> post(String url, BuildContext context,
      {MessageCallback callback}) async {
    bool tokenRestartValid = await isTokenExpired(context);
    if (!tokenRestartValid) {
      return null;
    }
    return http.post(url, headers: {
      HttpHeaders.authorizationHeader: HTTP.getHeader(),
      'Content-Type': 'application/json'
    }).then(
      (http.Response response) {
        final int statusCode = response.statusCode;

        return GetRequest(url, utf8.decode(response.bodyBytes), statusCode,
            RequestType.POST, context);
      },
    );
  }

  static Future<GetRequest> put(String url, BuildContext context,
      {MessageCallback callback}) async {
    bool tokenRestartValid = await isTokenExpired(context);
    if (!tokenRestartValid) {
      return null;
    }
    return http.put(url, headers: {
      HttpHeaders.authorizationHeader: HTTP.getHeader(),
      'Content-Type': 'application/json'
    }).then(
      (http.Response response) {
        final int statusCode = response.statusCode;
        return GetRequest(url, utf8.decode(response.bodyBytes), statusCode,
            RequestType.PUT, context);
      },
    );
  }

  static Future<GetRequest> get(String url, BuildContext context,
      {MessageCallback callback}) async {
    bool tokenRestartValid = await isTokenExpired(context);
    if (!tokenRestartValid) {
      return null;
    }
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader: HTTP.getHeader(),
      'Content-Type': 'application/json'
    }).then(
      (http.Response response) {
        final int statusCode = response.statusCode;
        return GetRequest(url, utf8.decode(response.bodyBytes), statusCode,
            RequestType.GET, context);
      },
    );
  }

  static Future<GetRequest> delete(String url, BuildContext context,
      {MessageCallback callback}) async {
    bool tokenRestartValid = await isTokenExpired(context);
    if (!tokenRestartValid) {
      return null;
    }
    return http.delete(url, headers: {
      HttpHeaders.authorizationHeader: HTTP.getHeader(),
      'Content-Type': 'application/json'
    }).then(
      (http.Response response) {
        final int statusCode = response.statusCode;
        return GetRequest(url, utf8.decode(response.bodyBytes), statusCode,
            RequestType.DELETE, context);
      },
    );
  }

  static Future<bool> isTokenExpired(BuildContext context) async {
    if (UserController.me == null) {
      return true;
    }
    if (UserController.me.token == null ||
        UserController.me.tokenExpiry == null ||
        UserController.me.refreshToken == null) {
      return true;
    }

    int timeExpiry = UserController.me.tokenExpiry.millisecondsSinceEpoch;
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    int timeLimit = 86400000; //<-    24 HORAS
    //int timeLimit = 86400000 * 2 - 60000 * 3; //<- 48 HORAS - 1 MINUTO

    int tokenRefreshExpiry = timeExpiry - timeLimit;
      
    print(
        " expiry = $timeExpiry  refreshExpiry = $tokenRefreshExpiry  timeNow = $timeNow  ");

    /* Si se se pasa del tiempo en time Limit se reinicia */
    if (tokenRefreshExpiry < timeNow) {
      UserController.me.tokenExpiry = null;
      String newToken = await LoginApi.refreshLoginWithRefreshToken(context);
      if (newToken == null) {
        Events.restartApp(context);
        return false;
      }
      return true;
    } else {
      return true;
    }
  }
}

class GetRequest {
  bool complete = false;
  String response = "";
  int status = 0;

  GetRequest.empty() {
    this.response = null;
    this.status = 0;
    this.complete = false;
  }

  GetRequest(String url, String response, int status, RequestType type,
      BuildContext context) {
    this.response = response;
    this.status = status;

    /* Token Invalid */
    if (status == HttpErrors.SERVER_ERROR || status == HttpErrors.FORBIDDEN) { //TO CONSTANTS
      Events.restartApp(context);
      return;
    }

    /* reconnection error */
    if (status == HttpErrors.SITE_NOT_FOUND_WHERE) {
      print("RECONNECTING:$url , statusCode:$status, type:$type");
      login((loginReturn, loginState) {
        if (loginState == LoginState.LOADED) {}
      }, context);
    }

    /* Connection error */
    if (status < 200 || status > 400 || response == null) {
      print(
          "Error loading: fetching data url:$url , statusCode:$status, type:$type");
      this.complete = false;
      return;
    }

    /* cool */
    this.complete = true;
    return;
  }

  login(LoginCallback callback, BuildContext context) {
    LoginSend loginParams = new LoginSend(
      user: UserController.me.user /*loginData.user*/,
      psw: UserController.me.temporalPassword /*loginData.pasword*/,
    );
    LoginApi.loginSessionCoroutine(loginParams, callback, context);
  }

  void _requestCallback(RequestType type, String url,
      GetRequestCallback callback, BuildContext context) async {
    GetRequest request;
    switch (type) {
      case RequestType.POST:
        request = await Request.post(url, context);
        break;
      case RequestType.PUT:
        request = await Request.put(url, context);
        break;
      case RequestType.GET:
        request = await Request.get(url, context);
        break;
      case RequestType.DELETE:
        request = await Request.delete(url, context);
        break;
    }
    callback(request);
  }
}