import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/models/discount.dart';
import 'package:surtiSP/models/discount_group.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/http/request.dart';

class DiscountsApi {

  static Future<DiscountGroup> getDiscountGroup(BuildContext context) async {
    
    if (Global.env.debugConf.offlineDiscounts) {
      var url = HTTP.getLocalAddress(Service.DISCOUNT_GET);
      String data = await rootBundle.loadString(url);
      print('$data');
      return DiscountGroup.fromJson(
        json.decode(data),
      );
    }

    var url = HTTP.getAddress(Service.DISCOUNT_GET);

    GetRequest service = await Request.get(url, context);

    if (service.complete) {
      return DiscountGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }

  }

  static Future<Discount> getDiscountById(int _id, BuildContext context) async {
    if (Global.env.debugConf.offlineDiscounts) {
      var url = HTTP.getLocalAddress(Service.DISCOUNT_GET);
      String data = await rootBundle.loadString(url);

      print('discount : ${Discount.fromJson(
        json.decode(data),
      )}');
      return Discount.fromJson(
        json.decode(data),
      );
    }

    var url = HTTP.getAddress(Service.DISCOUNT_GET) + "/" + _id.toString();
    GetRequest service = await Request.get(url, context);

    if (service.complete) {
      DiscountGroup discount = DiscountGroup.fromJson(json.decode(service.response));
      return discount.discounts[0];
    } else {
      return null;
    }
  }
}
