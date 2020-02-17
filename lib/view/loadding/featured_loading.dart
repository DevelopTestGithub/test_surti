import 'package:flutter/material.dart';
import 'package:surtiSP/view/common/spinner.dart';

enum FeaLoadingType {
  GENERAL,
  FEATURED,
  LINEAR,
}

class FeaLoading extends StatelessWidget{

  final FeaLoadingType type;

  FeaLoading({
    @required this.type,
  });

  Widget _prLGeneral(){
    return Scaffold(
      body: Center(
        child: LinearProgressIndicator(),
      ),
    );
  }

  Widget _prLFeatured(){
    return Container(
      child: Center(
        child: Spinner(),
      ),
    );
  }

  Widget _prLFeaturedLinear(){
    return Container(
      child: Center(
        child: LinearProgressIndicator(
          backgroundColor: Colors.green[900],
        ),
      ),
    );
  }

  Widget _loadingElement (){

    Widget _widget2Return;
    switch(this.type){
      case FeaLoadingType.GENERAL:
        _widget2Return = _prLGeneral();
        break;
      case FeaLoadingType.FEATURED:
        _widget2Return = _prLFeatured();
        break;
      case FeaLoadingType.LINEAR:
        _widget2Return = _prLFeaturedLinear();
        break;
    }
    return _widget2Return;
  }

  @override
  Widget build(BuildContext context) {
    return _loadingElement();
  }
}

