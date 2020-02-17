import 'package:flutter/material.dart';
import 'package:surtiSP/util/view/size.dart';
import 'package:surtiSP/view/common/button_main.dart';

class MiniButton extends StatelessWidget {

  final VoidCallback press;
  final SizeSquare sizeSquare;

  ButtonType buttonType;

  MiniButton( this.press, {
      this.buttonType = ButtonType.REGULAR, 
      this.sizeSquare = const SizeSquare(40, 40,hasData: true),
      });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1,vertical: 1),
//      child: ButtonMainAnim(
//        "-",() {
//          },true,sizeSquare: sizeSquare,
//      )
    );
  }
}