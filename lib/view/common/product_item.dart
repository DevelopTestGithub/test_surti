import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/pages/product_page.dart';

class ProductItem extends StatelessWidget {
  ApiState productState = ApiState.INNACTIVE;
  Product model;
  MessageCallback errorSnackBarCallback;
  VoidCallback callbackTap;
  ProductItem(this.model, this.errorSnackBarCallback, this.callbackTap);

  static const double //
      HEIGHT = 100,
      BUTTON_HORIZONTAL_PADDING = 20,
      DIVISION = .7,
      DIVISION_IMAGE = .3,
      RADIUS = 5,
      RIGHT_TEXT_PADDING = 30,
      LEFT_TEXT_PADDING = 15;

  @override
  Widget build(BuildContext context) {
    var buttonWidth = (MyApp.screenWidth - BUTTON_HORIZONTAL_PADDING * 2);
    var section1Width = buttonWidth * DIVISION;
    var section2Width = buttonWidth * DIVISION_IMAGE;

    var url = model.images[0].src;

    return Material(
      child: InkWell(
        onTap: () {
          addProductToCart(context, errorSnackBarCallback);
        },
        child: Container(
          height: HEIGHT,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              right: BUTTON_HORIZONTAL_PADDING,
              left: BUTTON_HORIZONTAL_PADDING,
              top: 3,
              bottom: 10,
            ),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(RADIUS),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RADIUS),
                child: Container(
                  width: 40,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: section2Width),
                        child: Container(
                          width: MyApp.screenWidth * .1,
                          height: 20,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: LEFT_TEXT_PADDING),
                            child: Container(
                              child: ConstrainedBox(
                                constraints: new BoxConstraints(
                                    maxHeight: 200.0,
                                    maxWidth:
                                        section1Width - RIGHT_TEXT_PADDING),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      model.name,
                                      style: Style.PRODUCT_TITLE,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      model.description,
                                      style: Style.PRODUCT_SUBTITLE,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: section1Width),
                        child: Container(
                          color: Colors.white,
                          width: MyApp.screenWidth * .1,
                          height: 20,
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            imageUrl: url,
                            placeholder: (context, url) =>
                                new Spinner(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            httpHeaders: {
                              HttpHeaders.authorizationHeader: HTTP.getHeader()
                            },
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addProductToCart(context, MessageCallback errorSnackBarCallback) async {
    Navigator.of(context).push(
      PageTransition(
          curve: Curves.easeOutCirc,
          type: PageTransitionType.slideLeft,
          child: ProductPage(model, errorSnackBarCallback, ProductAction.ADD, openCart: callbackTap,),
          duration: const Duration(milliseconds: 200)),
    );
  }
  
}
