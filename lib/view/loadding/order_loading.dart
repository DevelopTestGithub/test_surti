import 'package:flutter/material.dart';
import 'package:surtiSP/view/common/spinner.dart';

enum OrderLoadingType {
  GENERAL,
  ORDER,
  CART,
  STATUS,
}

class OrderLoading extends StatelessWidget{

  final OrderLoadingType type;

  OrderLoading({
    @required this.type,
  });

  Widget _orderLGeneral(){
    return Scaffold(
      body: Center(
        child: Spinner(),
      ),
    );
  }

  Widget _orderLoading(){
    return Center(
      child: Spinner(),
    );
  }

  Widget _cartLoading(){
    return Container(
      child: Center(
        child: Spinner(),
      ),
    );
  }

  Widget _orderStatusLoading(){
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
      case OrderLoadingType.GENERAL:
        _widget2Return = _orderLGeneral();
        break;
      case OrderLoadingType.ORDER:
        _widget2Return = _orderLoading();
        break;
      case OrderLoadingType.CART:
        _widget2Return = _cartLoading();
        break;
      case OrderLoadingType.STATUS:
        _widget2Return = _orderStatusLoading();
        break;
    }
    return _widget2Return;
  }

  @override
  Widget build(BuildContext context) {
    return _loadingElement();
  }
}

