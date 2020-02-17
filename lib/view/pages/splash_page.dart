import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/util/persistency/persistentData.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/pages/home_page.dart';
import 'package:surtiSP/view/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    return;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CS.DEEP_SEA_BLUE,
        body: Container(
          alignment: Alignment.center,
          width: MyApp.screenWidth,
          height: MyApp.screenHeightRaw,
          child: Container(
            alignment: Alignment.center,
            width: MyApp.screenWidth,
            height: MyApp.screenHeightRaw,
            child: FlareActor("assets/sp/anim/spinner.flr",
                isPaused: false,
                alignment: Alignment.center,
                fit: BoxFit.fitHeight,
                animation: "Untitled"),
          ),
        ));
  }
}
