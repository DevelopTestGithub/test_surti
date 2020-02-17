import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/models/product_group.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/http/request.dart';
import 'package:surtiSP/util/user_Controller.dart';

class ProductApi {
  static Future<ProductGroup> getProductGroup(
      String categoryId, BuildContext context) async {
    String categoryId = UserController.me.vegetablesId;
    if (Global.env.debugConf.offlineProducts) {
      return getProductGroupOffline(categoryId, context);
    }
    var url = HTTP.getAddress(Service.PRODUCT_LIST);
    var procUrl = "$url/$categoryId";
    print('${procUrl}');
    GetRequest service = await Request.get(procUrl, context);
    if (service.complete) {
      return ProductGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  } 

  static Future<ProductGroup> getProductGroupOffline(
      String categoryId, BuildContext context) async {
    //Arreglar a real persistencia
    String categoryId = UserController.me.vegetablesId;
    var url = HTTP.getLocalAddress(Service.PRODUCT_LIST, extraSufix: "/main");
    print('${url}');
    var procUrl = "$url";
    String data = await rootBundle.loadString(procUrl);
    print('$data');
    return ProductGroup.fromJson(
      json.decode(data),
    );
  }

  static Future<Product> getProduct() async {
    var url = HTTP.getAddress(Service.PRODUCT_LIST);
    var combinedURL = "$url";
    return http.get(
      combinedURL,
      headers: {HttpHeaders.authorizationHeader: HTTP.getHeader()},
    ).then(
      (http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode > 400 || json == null) {
          print("Error loading: Error while fetching data");
        }
        return Product.fromJson(
          json.decode(response.body),
        );
      },
    );
  }

  static Future<Product> getProductById(int _id, BuildContext context) async {
    if (Global.env.debugConf.offlineDiscounts) {
      var url = HTTP.getLocalAddress(Service.PRODUCT_BY_ID);
      String data = await rootBundle.loadString(url);
      print('discount : ${Product.fromJson(
        json.decode(data),
      )}');
      return Product.fromJson(
        json.decode(data),
      );
    }

    var url = HTTP.getAddress(Service.PRODUCT_BY_ID) + "/" + _id.toString();
    GetRequest service = await Request.get(url, context);

    if (service.complete) {
      ProductGroup product =
          ProductGroup.fromJson(json.decode(service.response));
      return product.products[0];
    } else {
      return null;
    }
  }
}
