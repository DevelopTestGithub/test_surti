

class Featured {

  final int productId;
  final int imageId;
  final String imageUrl;
  final int id;

  Featured({
    this.productId,
    this.imageId,
    this.imageUrl,
    this.id
  });

  factory Featured.fromJson(Map<String, dynamic> json) {
    print(" id: ${json['id'].toString()} - "
        "productId: ${json['product_id'].toString()} - "
        "imageId: ${json['image_id'].toString()} - "
        "imageURL: ${json['image_url'].toString()}"
        "");

    return Featured(
      productId: json['product_id'],
      imageId: json['image_id'],
      imageUrl: json['image_url'],
      id: json['id'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    //! FIX: Image list needs desearializing in array format
    map["product_id"] = productId;
    map["image_id"] = imageId; //supposed this works
    map["image_url"] = imageUrl;
    map["id"] = id;
    return map;
  }

}