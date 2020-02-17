import 'package:flutter/material.dart';
import 'package:surtiSP/view/common/spinner.dart';

enum PrLoadingType {
  GENERAL,
  FEATURED,
  PRICE,
  EDIT,
}

class ProductLoading extends StatelessWidget{

  final PrLoadingType type;

  ProductLoading({
    @required this.type,
  });

  Widget _prLGeneral(){
    return Scaffold(
      body: Center(
        child: Spinner(),
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

  Widget _prLPrice(){
    return Container(
      child: Center(
        child: Spinner(),
      ),
    );
  }

  Widget _prLEdit(){
    return Container(
      child: Center(
        child: Spinner(),
      ),
    );
  }

  Widget _loadingElement (){

    Widget _widget2Return;
    switch(this.type){
      case PrLoadingType.GENERAL:
        _widget2Return = _prLGeneral();
        break;
      case PrLoadingType.FEATURED:
        _widget2Return = _prLFeatured();
        break;
      case PrLoadingType.PRICE:
        _widget2Return = _prLPrice();
        break;
      case PrLoadingType.EDIT:
        _widget2Return = _prLEdit();
        break;
    }
    return _widget2Return;
  }

  @override
  Widget build(BuildContext context) {
    return _loadingElement();
  }
}

