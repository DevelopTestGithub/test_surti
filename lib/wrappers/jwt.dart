import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:surtiSP/models/jwt_token.dart';
import 'package:surtiSP/util/user_Controller.dart';

class JWT {
  static const SHARED_SECRET = 'IHopeAShortKeyWorks';


  static injectToCode(JWTToken jwtData, {@required String refreshToken}){    
      UserController.me.userId = jwtData.id;
      UserController.me.vegetablesId = jwtData.vegetablesId;
      UserController.me.promosId = jwtData.promosId;
      UserController.me.lacteosId = jwtData.lacteosId;
      UserController.me.tokenExpiry = jwtData.expiry;
      UserController.me.refreshToken = refreshToken;
      print("REFRESH TOKEN = $refreshToken");
  }

  static String senderCreatesJwt(String audience) {
    // Create a claim set

    final claimSet = new JwtClaim(
      issuer: 'fern', //NAME?
      subject: 'something ',
      audience: <String>['client1.example.com', 'client2.example.com'],
      jwtId: _randomString(32),
      otherClaims: <String, dynamic>{
        'typ': 'authnresponse',
        'pld': {'k': 'v'}
      },
      maxAge: const Duration(minutes: 5),
    );
    final token = issueJwtHS256(claimSet, SHARED_SECRET);
    print('JWT: "$token"\n');
    return token;
  }

  static JWTResponseData validate(String token, {@required String audience}) {
    print('JWT: "$token"\n');

    if (token == null) {
      return JWTResponseData(claim: null, success: false);
    }

    try {
      // Verify the signature in the JWT and extract its claim set
      final decClaimSet = verifyJwtHS256Signature(token, SHARED_SECRET);
      print('JwtClaim: $decClaimSet\n');

      // Validate the claim set
      decClaimSet.validate(
        issuer: 'SurtiServer',
        audience: audience,
        allowedClockSkew: Duration(seconds: 60),
      );

      // Use values from claim set
      if (decClaimSet.subject != null) {
        print('JWT ID: "${decClaimSet.jwtId}"');
      }
      if (decClaimSet.jwtId != null) {
        print('Subject: "${decClaimSet.subject}"');
      }
      if (decClaimSet.issuedAt != null) {
        print('Issued At: ${decClaimSet.issuedAt}');
      }

      if(decClaimSet.expiry != null){        
        print('Expiry At: ${decClaimSet.expiry}');
      }

      if (decClaimSet.containsKey('typ')) {
        final dynamic v = decClaimSet['typ'];
        if (v is String) {
          print('typ: "$v"');
        } else {
          print('Error: unexpected type for "typ" claim');
        }
      }
      return JWTResponseData(claim: decClaimSet, success: true);
    } on JwtException catch (e) {
      print('Error: bad JWT: $e');
      return JWTResponseData(claim: null, success: false);
    }
  }

  static String _randomString(int length) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    final buf = new StringBuffer();

    for (var x = 0; x < length; x++) {
      buf.write(chars[rnd.nextInt(chars.length)]);
    }
    return buf.toString();
  }
}

class JWTResponseData {
  final JwtClaim claim;
  final bool success;
  JWTResponseData({this.claim, this.success});
}
