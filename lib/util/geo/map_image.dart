import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/view/common/spinner.dart';

class MapImage extends StatelessWidget {
  
  final double lat;
  final double long;
  final double width;
  final double height;
  MapImage({this.lat = -0.177990 , this.long = -78.481848,this.width = 400, this.height = 300});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: CS.DEEP_SEA_BLUE,
      child: CachedNetworkImage(
        imageUrl: mapUrl(lat,long,width,height),
        placeholder: (context, url) => new Spinner(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
        httpHeaders: {HttpHeaders.authorizationHeader: HTTP.getHeader()},
        fit: BoxFit.fill,
      )
    );
  }
    static String mapUrl(double lat, double long,double width, double height) {
    return "" +
        "https://maps.googleapis.com/maps/api/staticmap?" +
        "center=" +
        "$lat,$long" +
        "&zoom=15" +
        "&size=400x300" +
        "&maptype=roadmap" +
        "&markers=color:blue" +
        "%7C" +
        "label:aqui" +
        "%7C" +
        "$lat,$long" +
        "&key=AIzaSyCY1ufpc5ynwzdayqk_MN8NJuZTsheuiaU";
  }
}
