import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/styles/gradients.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/money/price.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/view/pages/product_page.dart';

class ProductVeggieList extends StatelessWidget {
  bool offlineMode;
  Product model1;
  Product model2;
  Product model3;
  MessageCallback errorSnackBarCallback;
  VoidCallback callbackCartButton;
  VoidCallback refreshCart;
  ProductAction action;
  int orderId;

  ProductVeggieList({
    this.model1,
    this.model2,
    this.model3,
    @required this.offlineMode,
    this.errorSnackBarCallback,
    this.callbackCartButton,
    this.refreshCart,
    this.action,
    this.orderId,
  }){
    if(this.refreshCart == null)
    this.refreshCart = (){};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyApp.screenWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ProductItemMini(
                model1, errorSnackBarCallback, callbackCartButton, refreshCart, orderId: orderId, action: action, offlineMode: offlineMode),
            ProductItemMini(
                model2, errorSnackBarCallback, callbackCartButton, refreshCart, orderId: orderId, action: action, offlineMode: offlineMode),
            ProductItemMini(
                model3, errorSnackBarCallback, callbackCartButton, refreshCart, orderId: orderId, action: action, offlineMode: offlineMode),
          ],
        ),
      ),
    );
  }
}

class ProductItemMini extends StatelessWidget {
  static const double //
      HEIGHT = 140,
      BUTTON_HORIZONTAL_PADDING = 5,
      DIVISION = .7,
      DIVISION_IMAGE = .3,
      RADIUS = 5,
      RIGHT_TEXT_PADDING = 30,
      LEFT_TEXT_PADDING = 15;

  ApiState productState = ApiState.INNACTIVE;
  MessageCallback errorSnackBarCallback;
  VoidCallback cartButtonCallback;
  VoidCallback refreshCart;
  Product model;
  ProductAction action;
  int orderId;
  bool offlineMode;

  ProductItemMini(
    this.model,
    this.errorSnackBarCallback,
    this.cartButtonCallback,
    this.refreshCart,
    {
      this.action,
      this.orderId,
      @required this.offlineMode
    }
  );

  @override
  Widget build(BuildContext context) {
    var buttonWidth = (MyApp.screenWidth - BUTTON_HORIZONTAL_PADDING * 2);
    var section1Width = buttonWidth * DIVISION;
    var section2Width = buttonWidth * DIVISION_IMAGE;

    if (model == null) {
      return MiniContainerProductMini();
    }

    var url = model.images[0].src;
    var priceTag = Price(model.price);
    String priceTagString = priceTag.getFormatted();

    return Material(
        child: InkWell(
      onTap: () {
        //addProductToCart(context, errorSnackBarCallback);

        Navigator.of(context).push(
          PageTransition(
              curve: Curves.easeOutCirc,
              type: PageTransitionType.slideLeft,
              child: ProductPage(
                model,
                errorSnackBarCallback,
                this.action,
                openCart: cartButtonCallback,
                refresh: refreshCart,
                orderID: orderId,

              ),
              duration: const Duration(milliseconds: 200)),
        );
      },
      child: MiniContainerProductMini(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
            width: MyApp.screenWidth * .1,
            height: 20,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              httpHeaders: {HttpHeaders.authorizationHeader: HTTP.getHeader()},
              fit: BoxFit.fill,
            ),
          ),
          Container(
            decoration: Gradients.transparentUp,
          ),
          Container(
            width: MyApp.screenWidth * .1,
            height: 20,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: LEFT_TEXT_PADDING),
              child: Container(
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                      maxHeight: 200.0,
                      maxWidth: section1Width - RIGHT_TEXT_PADDING),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          height: 30,
                          child: Text(
                            model.name,
                            style: Style.PRODUCT_TITLE,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )),
                      Text(
                        priceTagString,
                        style: Style.PRODUCT_SUBTITLE,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    ));
  }

//  void addProductToCart(context, MessageCallback errorSnackBarCallback) async {
//    Navigator.of(context).push(
//      PageTransition(
//          curve: Curves.easeOutCirc,
//          type: PageTransitionType.slideLeft,
//          child: ProductPage(
//            model,
//            errorSnackBarCallback,
//            ProductAction.ADD,
//            openCart: cartButtonCallback,
//            refresh: refreshCart,
//          ),
//          duration: const Duration(milliseconds: 200)),
//    );
//  }
}

class MiniContainerProductMini extends StatelessWidget {
  final Widget child;
  MiniContainerProductMini({this.child});
  @override
  Widget build(BuildContext context) {
    var width = (MyApp.screenWidth - 20) * .33;

    if (child == null) {
      return Container(
        height: ProductItemMini.HEIGHT,
        // - 3 objectPadding
        width: width,
      );
    }

    return Container(
        height: ProductItemMini.HEIGHT,
        // - 3 objectPadding
        width: width,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            right: ProductItemMini.BUTTON_HORIZONTAL_PADDING,
            left: ProductItemMini.DIVISION_IMAGE,
            top: 3,
            bottom: 10,
          ),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(ProductItemMini.RADIUS),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ProductItemMini.RADIUS),
              child: Container(
                  width: 40,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: child),
            ),
          ),
        ));
  }
}
