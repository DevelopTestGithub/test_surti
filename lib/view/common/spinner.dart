import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';

class Spinner extends StatelessWidget {
  const Spinner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MyApp.screenWidth * .2,
      height: MyApp.screenWidth * .2,
      child: FlareActor("assets/sp/anim/spinner.flr",
          isPaused: false,
          alignment: Alignment.center,
          fit: BoxFit.fitHeight,
          animation: "Untitled"),
    );
  }
}
