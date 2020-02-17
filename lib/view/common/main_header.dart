import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/view/pages/home_page/top_items.dart';

class MainHeader extends StatelessWidget {
  static const double HEADER_HEIGHT = 90;

  final VoidCallback backButton;
  final bool backButtonIsMenuButton;
  VoidCallback cartButton;
  bool _cartButtonExists;
  Color color;

  MainHeader(this.backButton, {this.cartButton, this.backButtonIsMenuButton = false, this.color = Colors.black}){
    if(cartButton == null){
      cartButton = (){};
      _cartButtonExists = false;
    }else{
      _cartButtonExists = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Padding(
          padding: EdgeInsets.only(top: 15, left: 10),
          child: InkWell(
            onTap: () {
              if (MyApp.tellMeIfUIIsDisabled()) return;
              backButton();
            },
            splashColor: Colors.transparent,
            child: Container(
              width: 60,
              height: HEADER_HEIGHT,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 3),
                child: Icon(
                  backButtonIsMenuButton?
                  Icons.menu:
                  Icons.arrow_back_ios,
                  color: color,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
        _cartButtonExists?
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 14, right: 10),
            child: TopButton(
              pressButton: () {
                cartButton();
              },
              topBType: TopBType.PROFILE,
            ),
          )
        ):
        Container(width: 0,height: 0,),
      ]),
    );
  }
}
