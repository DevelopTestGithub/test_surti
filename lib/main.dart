
//

import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/util/env/environment_manager.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/pages/login_page.dart';
import 'package:surtiSP/wrappers/connection.dart';


void main() {  
  _setupEnvironment();
  _setConnection();
  UserController.init();
  return runApp(MyApp());
}

void _setupEnvironment() {
  Global.env = EnvironmentMn.getEnvironment();
}

void _setConnection(){
  Connection.init();
}

class MyApp extends StatelessWidget {
  static double screenHeight = 0.0;
  static double screenHeightRaw = 0.0;
  static double screenWidth = 0.0;
  static bool _disableUI = false;

  @override
  Widget build(BuildContext context) {
    
    LayoutBuilder screen = LayoutBuilder(
      builder: (context, constraint) {
        screenHeight = constraint.maxHeight - 70;
        screenHeightRaw = constraint.maxHeight;
        screenWidth = constraint.maxWidth; 
        
        return MaterialApp(
          title: T.TITLE,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            accentColor: Colors.white,
          ),
          home: SplashScreen.navigate(
            name: 'assets/sp/anim/logo.flr',
            next: LoginPage(),
            backgroundColor: CS.DEEP_SEA_BLUE,
            until: () => Future.delayed(Duration(seconds: 2)),
            startAnimation: 'Untitled',
          ),
        );
      },
    );
    return screen;
  }

  static bool tellMeIfUIIsDisabled() {
    return _disableUI;
  }

  static void disableUI() {
    _disableUI = true;
  }

  static void enableUI() {
    _disableUI = false;
  }
}
