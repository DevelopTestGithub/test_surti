import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/view/common/button_main.dart';

class LoadingProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loadingProductScreen =  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                T.PRODUCT_TITLE,
                style: Style.TITLE,
              ),
              SizedBox(
                height: MyApp.screenHeight * .3,
              ),
              ButtonMainAnim(
                FontAwesomeIcons.carrot,
                  T.SEE_VEGGIES, () async {}, true),
            ],
          ),
        ],
    );

    
    return loadingProductScreen;
  }
}