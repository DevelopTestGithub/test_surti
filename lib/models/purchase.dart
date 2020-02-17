//
//

class PurchaseResponse {
  final bool purchaseSuccessful;

  PurchaseResponse({this.purchaseSuccessful});

  factory PurchaseResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseResponse(
      purchaseSuccessful: purchaseResponse(json["Response"]),
    );
  }

  static bool purchaseResponse(String response) {
    if (response == "Ok") {
      return true;
    } else {
      return false;
    }
  }
}
