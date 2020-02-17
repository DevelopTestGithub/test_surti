//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/money/price.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final TextStyle dollarStyle, centStyle;

  PriceTag(this.price,{this.dollarStyle = Style.PRODUCT_MONEY_L,this.centStyle = Style.PRODUCT_MONEY_S});

  @override
  Widget build(BuildContext context) {
    Price filteredPrice = Price(price);

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$',
            style: dollarStyle,
          ),
          Text(
            filteredPrice.dollars,
            style: dollarStyle,
          ),
          Padding(
            padding: EdgeInsets.only(top: MyApp.screenHeight * .015),
            child: Text(              
            filteredPrice.cents,
              style: centStyle,
            ),
          ),
        ],
      );
  }
}

class PriceTagW extends StatelessWidget {
  final double price;

  PriceTagW(this.price);

  @override
  Widget build(BuildContext context) {
    Price filteredPrice = Price(price);
    
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$',
            style: Style.PRODUCT_MONEY_LW,
          ),
          Text(
            filteredPrice.dollars,
            style: Style.PRODUCT_MONEY_LW,
          ),
          Padding(
            padding: EdgeInsets.only(top: MyApp.screenHeight * .015),
            child: Text(              
            filteredPrice.cents,
              style: Style.PRODUCT_MONEY_SW,
            ),
          ),
        ],
      );
  }
}