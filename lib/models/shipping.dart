
class ShippingAddress {

  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String company;
  String country;
  String province;
  String city;
  String zipCode;
  String address1;
  String reference;
  double latitud;
  double longitud;
  String ptIndex;


  ShippingAddress({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.company,
    this.country,
    this.province,
    this.city,
    this.address1,
    this.zipCode,
    this.reference,
    this.longitud,
    this.latitud,
    this.ptIndex,
});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    double lat = 0.0, long = 0.0;
    if ( null != json ) {
      if (json['latitud'] == null) {
        json['latitud']  = 0.0;
      }else{
        lat = double.parse(json['latitud']);
      }
      if (json['longitud']== null) {
         json['longitud']  = 0.0;
      }else{
        long = double.parse(json['longitud']);
      }
      return ShippingAddress(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        company: json['company'],
        country: json['country'],
        province: json['province'],
        city: json['city'],
        address1: json['address1'],
        zipCode: json['zip_postal_code'],
        reference: json['ref'],
        ptIndex: json['pt_indice'],
        latitud: lat,
        longitud: long
      );
    } else {
      return null;
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["email"] = email;
    map["phone_number"] = phoneNumber;
    map["company"] = company;
    map["country"] = country;
    map["province"] = province;
    map["city"] = city;
    map["address1"] = address1;
    map["zip_postal_code"] = zipCode;
    map["ref"] = reference;
    map["latitud"] = latitud;
    map["longitud"] = longitud;
    map["pt_indice"] = ptIndex;
    return map;
  }
}