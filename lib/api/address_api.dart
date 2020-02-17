
import 'package:flutter/cupertino.dart';
import 'package:surtiSP/models/clients.dart';
import '../util/http/addresses.dart';
import '../util/http/request.dart';

class AddressApi {

  static Future<bool> addAddress(AddressAdd params, BuildContext context) async {
    
    var url = HTTP.getAddress(Service.ADDRESS_ADD);
    var combinedURL = "$url${params.toString()}";

    print(combinedURL);

    GetRequest service = await Request.put(combinedURL,context);

    if (service.complete) {
      return service.response.contains("Ok") ? true : false;
    } else {
      return false;
    }
  }

}

class AddressAdd {
  Client _client;

  AddressAdd(this._client);

  String toString() {
    return "?CustomerId=${_client.id}"
        "&Email=${_client.email}"
        "&first_name=${_client.firstName}"
        "&last_name=${_client.lastName}"
        "&business_name=${_client.businessName}"
        "&country_id=135"
        "&StateProvinveId=92"
        "&zip=00000"
        "&address1=${_client.shippingAddress.address1}"
        "&city=Quito"
        "&phone_number=${_client.shippingAddress.phoneNumber}";
  }
}
