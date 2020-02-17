import 'package:flutter/material.dart';
import 'package:surtiSP/view/common/spinner.dart';

enum CartLoadingType {
  GENERAL,
  PRODUCTS,
  CLEAR,
  STATUS,
}

class CartLoading extends StatelessWidget{

  final CartLoadingType type;

  CartLoading({
    @required this.type,
  });

  Widget _cartGeneral(){
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget _cartProduct(){
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _cartClear(){
    return Opacity(
      opacity: 0.8,
      child: LinearProgressIndicator(
        //backgroundColor: Colors.white,
      ),
    );
  }

  Widget _cartStatusLoading(){
    return Opacity(
      opacity: 0.3,
      child: Center(
        child: LinearProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _loadingElement (){

    Widget _widget2Return;
    switch(this.type){
      case CartLoadingType.GENERAL:
        _widget2Return = _cartGeneral();
        break;
      case CartLoadingType.PRODUCTS:
        _widget2Return = _cartProduct();
        break;
      case CartLoadingType.CLEAR:
        _widget2Return = _cartClear();
        break;
      case CartLoadingType.STATUS:
        _widget2Return = _cartStatusLoading();
        break;
    }
    return _widget2Return;
  }

  @override
  Widget build(BuildContext context) {
    return _loadingElement();
  }
}