import 'package:flutter/cupertino.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/util/persistency/persistentData.dart';
import 'package:surtiSP/view/pages/login_page.dart';

class Events {

    static restartApp(BuildContext context) {
    PersistentData.erase();
    Navigator.of(context).pushReplacement(
      PageTransition(
          curve: Curves.easeOutCirc,
          type: PageTransitionType.slideLeft,
          child: LoginPage(),
          duration: const Duration(milliseconds: 200)),
    );
  }

}