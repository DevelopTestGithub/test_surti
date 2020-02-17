
import 'package:flutter/material.dart';
import 'package:surtiSP/models/cart_product.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/view/common/cart.dart';

import '../s_screen.dart';

class CartDrawer extends StatefulWidget{
  final SScreen prevPage;
  BoolCallBack refreshCartCallback;

  List<CartProduct> productGroup;

  CartDrawer({this.prevPage, this.refreshCartCallback}){
    productGroup = List<CartProduct>();
    if(this.refreshCartCallback == null){
      this.refreshCartCallback = (clean){};
    }
  }

  _CartDrawerState createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {

  _CartDrawerState();

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: SafeArea(
        child: Cart(
          prevPage: widget.prevPage,
          refreshCartCallback: (clean){
            widget.refreshCartCallback(clean);
          },
        ),
      ),
    );
  }

}