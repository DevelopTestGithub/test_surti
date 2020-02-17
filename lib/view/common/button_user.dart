


import 'package:flutter/material.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';

const double BUTTON_HEIGHT = 28;

class UserBtn extends StatefulWidget {
  final VoidCallback callback;
  final double height;
  final double width;
  final String text;
  final bool active;
  final Color altColor;
  bool pressed = false;

  UserBtn(
      {this.callback, this.width, this.height, this.text, this.active = true, this.altColor = CS.DEEP_SEA_BLUE});
  @override
  _UserBtnState createState() => _UserBtnState();
}

class _UserBtnState extends State<UserBtn> {
  @override
  Widget build(BuildContext context) {
    Color mainColor = widget.altColor;
    TextStyle textStyle = Style.MEDIUM_M_W;
    if (!widget.active) {
      textStyle = Style.MEDIUM_M_G;
    }
    if (widget.pressed && widget.active) {
      mainColor = CS.WHITE;
      textStyle = Style.MEDIUM_M_DSB;
    }

    return InkWell(
        onTap: () {
          if (widget.active) widget.callback();
          setState(() {
            widget.pressed = false;
          });
        },
        onTapDown: (TapDownDetails) {
          setState(() {
            widget.pressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            widget.pressed = false;
          });
        },
        child: Container(
          alignment: Alignment.center,
          width: widget.width,
          height: widget.height,
          child: Text(
            widget.text,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: CS.IN_GRAY),
          ),
        ));
  }
}