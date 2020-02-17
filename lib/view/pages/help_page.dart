
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/view/size.dart';
import 'package:surtiSP/view/common/button_main.dart';
import 'package:surtiSP/view/pages/delivery_home_page.dart';
import 'package:surtiSP/view/s_screen.dart';

import '../../main.dart';

class HelpPage extends SScreen{

  HelpPage();
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends SurtiState<HelpPage> {

  _HelpPageState();

  @override
  Widget build(BuildContext context) {

    return buildExternal(
      backgroundColor: Colors.white,
      updateCartDetection: false,
      forceCartButtonInnactive: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Text(
                T.HELP_INSTRUCTIONS,
                style: Style.SUBTITLE,
                textAlign: TextAlign.center,
            ),
          ),

          ButtonMainAnim(
            Icons.help,
            T.CONTINUE_SHOPPING,
            () {
              Navigator.of(context).pushReplacement(
                PageTransition(
                    curve: Curves.easeOutCirc,
                    type: PageTransitionType.slideLeft,
                    child: Home(),
                    duration: const Duration(milliseconds: 200)),
              );
            },
            true,
            sizeSquare: SizeSquare(
                MyApp.screenWidth * .45, MyApp.screenHeight * .098),
          ),
        ],
      )
    );
  }

}