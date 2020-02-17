import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/models/shipping.dart';
import 'package:surtiSP/util/user_Controller.dart';

class GetIntent {
  static const platform = const MethodChannel('app.channel.shared.data');
  static String _lockedPtCode = "";
  String dataShared = "No data";

  static lockCurrentIntentPTCode() {
    _lockedPtCode = UserController.client.ptCode;
  }

  static cleanLock() {
    _lockedPtCode = "";
  }

  getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    //print('getSharedData');
    if (sharedData['ptindice'] != null) {}
  }

  /* Setea el PTCode en el UserController si no encuentra regresa false */
  static Future<bool> intentInitialization(BuildContext context) async {
    var sharedData = await platform.invokeMethod("getSharedText");
    var ptCode = sharedData['ptindice'];
    if (ptCode != null && ptCode != _lockedPtCode) {
      UserController.me.intent = true;
      ShippingAddress _shippingAddress = new ShippingAddress(
        firstName: sharedData['FirstName'],
        lastName: sharedData['LastName'],
        email: sharedData['Email '],
        phoneNumber: sharedData['PhoneNumber'],
        address1: sharedData['Address1 '],
        reference: sharedData['Referencia'],
        latitud: double.parse(sharedData['Latitud ']),
        longitud: double.parse(sharedData['Longitud ']),
        ptIndex: sharedData['ptindice'],
      );
 
      Client _client2Create = new Client(
          firstName: sharedData['FirstName'],
          lastName: sharedData['LastName'],
          ruc: sharedData['RUC'],
          email: sharedData['Email '],
          businessName: sharedData['BusinessName'],
          shippingAddress: _shippingAddress);
      
      ClientBasicCreate params =
          new ClientBasicCreate(_client2Create, _shippingAddress);

      int _clientId = await ClientApi.getClientByPtCode(params, context);

      if (0 != _clientId && null != _clientId) {
        UserController.client.userId = _clientId.toString();
        UserController.client.ptCode = ptCode;
        UserController.client.name = "${_client2Create.lastName} ${_client2Create.firstName}"; 
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
