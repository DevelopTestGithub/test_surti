import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/models/clients_group.dart';
import 'package:surtiSP/models/shipping.dart';

import '../util/http/addresses.dart';
import '../util/http/request.dart';

class ClientApi {
  static Future<ClientsGroup> getClientGroup(BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_GET);
    var combinedURL = "$url?Limit=250&Page=1";

    GetRequest service = await Request.get(combinedURL, context);

    if (service.complete) {
      return ClientsGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }
    
  }

  static Future<ClientsGroup> getLocalClientGroup() async {
    var url = HTTP.getLocalAddress(Service.CLIENT_GET);
    
    String data = await rootBundle.loadString(url);

    return ClientsGroup.fromJson(
      json.decode(data),
    );
  }


  static Future<ClientsGroup> getSearchClientGroup(String searchText,BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_SEARCH_GET);
    var combinedURL =
        "$url?query=firstname:$searchText:lastname:$searchText:email:$searchText:ruc:$searchText:&page=1&limit=250";

    print("MESSAGE $combinedURL");

    GetRequest service = await Request.get(combinedURL, context);

    if (service.complete) {
      return ClientsGroup.fromJson(json.decode(service.response));
    } else {
      return null;
    }
  }

  static Future<int> createClient(ClientCreate params,BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_GET);
    var combinedURL = "$url${params.toString()}";

    print(combinedURL);

    GetRequest service = await Request.post(combinedURL, context);

    if (service.complete) {
      ClientResponse _response =
          ClientResponse.fromJson(json.decode(service.response));
      if ("Ok" == _response.response) {
        return _response.id;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> createBasicClient(ClientBasicCreate params,BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_CREATE_BASIC);

    var combinedURL = "$url${params.toString()}";

    print(combinedURL);

    GetRequest service = await Request.post(combinedURL, context);

    if (service.complete) {
      ClientResponse _response =
          ClientResponse.fromJson(json.decode(service.response));
      if ("Ok" == _response.response) {
        return _response.id;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<bool> modifyBasicClient(
      String userId, ClientBasicCreate params,BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_MODIFY_BASIC);

    var combinedURL = "$url/$userId${params.toString()}";
    //combinedURL = Uri.encodeComponent(combinedURL);
    print(combinedURL);

    GetRequest service = await Request.put(combinedURL, context);

    if (service.complete) {
      ClientResponse _response =
          ClientResponse.fromJson(json.decode(service.response));
      if ("Ok" == _response.response) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<ActivationResponseType> upgradeBasicClient(
      ClientEnrollment params,BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_UPGRADE);
    var combinedURL = "$url/${params.toString()}";
    GetRequest service = await Request.post(combinedURL, context);

    if (service.complete) {
      ClientResponse _response =
          ClientResponse.fromJson(json.decode(service.response));
      var response = _response.response;
      if (response != null) {
        switch (response) {
          case "Error - invalid id":
            return ActivationResponseType.INVALID;
          case "Error - no phone number":
            return ActivationResponseType.LACKS_PHONE;
          case "Error - phone number in use":
            return ActivationResponseType.PHONE_USED;
          case "Customer Not Found":
            return ActivationResponseType.CUSTOMER_DOESNT_EXIST;
          case "ok":
            return ActivationResponseType.OK;
        }
      } else {
        return ActivationResponseType.ERROR;
      }
    } else {
      return ActivationResponseType.ERROR;
    }
  }

  static Future<Client> getClient(int id, BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_GET);
    var combinedURL = "$url/$id";
    print(combinedURL);
    GetRequest service = await Request.get(combinedURL, context);
    if (service.complete) {
      GetClientResponse _response =
          GetClientResponse.fromJson(json.decode(service.response));
      var customer = _response.customers[0];
      if (customer != null) {
        //HERE
        return customer;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> getClientByPtCode(ClientBasicCreate params, BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_GET_BY_PT_CODE);
    var combinedURL = "$url${params.toString()}";
    print(combinedURL);
    GetRequest service = await Request.get(combinedURL, context);

    if (service.complete) {
      ClientResponse _response =
      ClientResponse.fromJson(json.decode(service.response));

      if ("Ok" == _response.response) {
        return _response.id;
      }
    }
    return null;
  }

  static Future<bool> addGeo2Client(ClientAddGeo params, BuildContext context) async {
    var url = HTTP.getAddress(Service.CLIENT_ADD_GEO);
    var combinedURL = "$url${params.toString()}";

    print(combinedURL);

    GetRequest service = await Request.put(combinedURL, context);

    if (service.complete) {
      ClientResponse _response =
          ClientResponse.fromJson(json.decode(service.response));

      if ("Ok" == _response.response) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

class GetClientResponse {
  final List<Client> customers;
  GetClientResponse({this.customers});
  factory GetClientResponse.fromJson(Map<String, dynamic> loadJson) {
    print(loadJson.toString());
    ClientsGroup group = ClientsGroup.fromJson(loadJson);
    return GetClientResponse(customers: group.clients);
  }
}

class ClientResponse {
  final String response;
  final int id;
  ClientResponse({this.response, this.id});
  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return ClientResponse(
      response: json['Response'],
      id: json['Id'],
    );
  }
}

enum ActivationResponseType {
  INVALID,
  LACKS_PHONE,
  PHONE_USED,
  CUSTOMER_DOESNT_EXIST,
  OK,
  ERROR
}

class ClientAddGeo {
  double latitude;
  double longitude;
  int customerId;

  ClientAddGeo(
    this.latitude,
    this.longitude,
    this.customerId,
  );

  String toString() {
    return "?customer_id=${customerId.toString()}"
        "&latitud=${latitude.toString()}"
        "&longitud=${longitude.toString()}";
  }
}

class ClientCreate {
  Client _client;

  ClientCreate(this._client);

  String toString() {
    return "?Email=${_client.email}"
        "&first_name=${_client.firstName}"
        "&last_name=${_client.lastName}"
        "&business_name=${_client.businessName}"
        "&ruc=${_client.ruc}";
  }
}

class ClientEnrollment {
  Client _client;
  String clientPhoneNumber;

  ClientEnrollment(this._client, this.clientPhoneNumber);

  String toString() {
    return "${_client.id}?"
        "&phone_number=$clientPhoneNumber";
  }
}

class ClientBasicCreate {
  Client _client;
  ShippingAddress _address;

  ClientBasicCreate(this._client, this._address);

  String toString() {
    String firstName = null != _client.firstName ? _client.firstName : "";
    String lastName = null != _client.lastName ? _client.lastName : "";
    String businessName =
        null != _client.businessName ? _client.businessName : "";
    String address = null != _address.address1 ? _address.address1 : "";
    String phoneNumber =
        (null != _address.phoneNumber) ? _address.phoneNumber : "";
        
    String email =  null != _address.email ? _address.email : "";

    String ruc = null != _client.ruc ? _client.ruc : "";
    String ref = null != _address.reference ? _address.reference : "";

    String ptcode =  null != _address.ptIndex ? _address.ptIndex : "";

    String lat = null != _address.latitud ? "${Uri.encodeComponent(_address.latitud.toString())}" : "";
    String long = null != _address.longitud ? "${Uri.encodeComponent(_address.longitud.toString())}" : "";

    return "?first_name=${Uri.encodeComponent(firstName)}"
        "&last_name=${Uri.encodeComponent(lastName)}"
        "&business_name=${Uri.encodeComponent(businessName)}"
        "&address1=${Uri.encodeComponent(address)}"
        "&phone_number=${Uri.encodeComponent(phoneNumber)}"
        "&pt_indice=${Uri.encodeComponent(ptcode)}"
        "&country_id=135"
        "&StateProvinveId=92"        
        "&email=${Uri.encodeComponent(email)}"
        "&ref=${Uri.encodeComponent(ref)}"
        "&ruc=${Uri.encodeComponent(ruc)}"
        "&latitud=${Uri.encodeComponent(lat)}"
        "&longitud=${Uri.encodeComponent(long)}"
        "&city=Quito";
  }
}
