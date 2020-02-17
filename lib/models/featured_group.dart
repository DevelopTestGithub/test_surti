import 'featured.dart';

class FeaturedGroup {
  final List<Featured> featured;
  final int id;

  FeaturedGroup({this.id, this.featured});

  factory FeaturedGroup.fromJson(Map<String, dynamic> json) {

    var featuredDynamic = json['featured'] as List;
    var featuredParsed = featuredDynamic.map((i) => Featured.fromJson(i)).toList();

    return FeaturedGroup(id: json['id'], featured: featuredParsed);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["featured"] = featured; //supposed this works
    return map;
  }
}