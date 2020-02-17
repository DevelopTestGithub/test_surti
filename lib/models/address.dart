
class Address {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String province;
  final String city;
  final String address1;
  final String phoneNumber;
  final double latitud;
  final double longitud;

  Address({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.province,
    this.city,
    this.address1,
    this.phoneNumber,
    this.latitud,
    this.longitud
  });

  factory Address.fromJson(Map<String, dynamic> json) {

    return Address(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      province: json['province'],
      city: json['city'],
      address1: json['address1'],
      phoneNumber: json['phone_number'],
      latitud: json['latitude'],
      longitud: json['longitud'],
    );
  }


  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["first_name"] = firstName; //supposed this works
    map["last_name"] = lastName;
    map["email"] = email;
    map["province"] = province;
    map["city"] = city;
    map["address1"] = address1;
    map["phone_number"] = phoneNumber;
    map["latitud"] = latitud;
    map["longitud"] = longitud;
    return map;
  }
}
