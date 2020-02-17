import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/style_sheet.dart';


class BottomButton extends StatelessWidget {
  Color ENABLED_COLOR = Colors.green;
  Color DISABLED_COLOR = Colors.grey;

  final VoidCallback callback;
  final String text;
  final bool enabled;

  BottomButton({this.callback, this.text, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: (){
          if (enabled){
            callback();
          }
        }
        ,
        child: Container(
          color: enabled ? ENABLED_COLOR:DISABLED_COLOR,
          width: MyApp.screenWidth,
          alignment: AlignmentDirectional.center,
          height: 50,
          child: Text(
            text, //Add to cart
            textAlign: TextAlign.center,
            style: Style.REGULAR_BUTTON,
          ),
        ),
      ),
    );
  }
}