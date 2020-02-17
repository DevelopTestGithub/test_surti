import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ImageDataReceived {
  final String src;
  ImageDataReceived({this.src});
  
  factory ImageDataReceived.fromJson(Map<String, dynamic> json) {
    var jsonString = json.toString();

    
    return ImageDataReceived(
        src: json['src']); //probar
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["src"] = src;
    return map;
  }
}