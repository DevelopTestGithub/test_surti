//
//

import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:surtiSP/models/purchase.dart';
import 'package:surtiSP/models/purchase_send.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/http/request.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';

class PurchaseApi {
  //
  static Future<PurchaseResponse> createPurchase(PurchaseSend params,BuildContext context, {MessageCallback msg}) async {
    Service purchaseService = Service.PURCHASE;
    if (Global.env.vendorMode) purchaseService = Service.VENDOR;

    var url = HTTP.getAddress(purchaseService);



    
    var combinedURL = "$url${params.toString()}";


  print("URL PURCHASE = ${combinedURL}");
  
    GetRequest service = await Request.post(combinedURL, context);




    if (service.complete) {
      return PurchaseResponse.fromJson(json.decode(service.response));
    } else {
      return PurchaseResponse(purchaseSuccessful: false);
    }
  }
}
