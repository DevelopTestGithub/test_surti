import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/view/common/add_button.dart';

//!
//TODO: Plus and Minus need images.

class PlusMinus extends StatefulWidget {
  final CountCallBack countCallBack;
  final String subtitle;
  final int startingAmmount;
  final int limit;
  final double width;

  PlusMinus(this.subtitle, this.startingAmmount, this.countCallBack,
      {this.limit, @required this.width});

  @override
  _PlusMinusState createState() => _PlusMinusState();
}

class _PlusMinusState extends State<PlusMinus> {
  static const SIZE_IN_WHICH_WE_DISPLAY_SMALL_TEXT = 120;
  
  int _ammount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ammount = widget.startingAmmount;
  }

  @override
  Widget build(BuildContext context) {

    bool smallMode = (widget.width < SIZE_IN_WHICH_WE_DISPLAY_SMALL_TEXT);

    return Container(
      width: widget.width,
      height: MyApp.screenHeight * .24,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Text(
            widget.subtitle,
            style: Style.ITEMS_DESCRIPTION,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AddButton(
                TypeOfAddButton.SUBSTRACTION,
                () {
                  //++
                  setState(
                    () {
                      _ammount--;
                      if (_ammount < 0) _ammount = 0;
                      UpdateCallback();
                    },
                  );
                },size:  widget.width * .2,
              ),
              Container(
                width: widget.width * .5,
                height: MyApp.screenHeight * .2,
                alignment: Alignment.center,
                child: Text(
                  '$_ammount',
                  style: smallMode? Style.PLUS_MINUS_TEXT_S:Style.PLUS_MINUS_TEXT_BIG,
                ),
              ),
              AddButton(
                TypeOfAddButton.ADDITION,
                () {
                  setState(
                    () {
                      _ammount++;
                      UpdateCallback();
                    },
                  );
                },size:  widget.width * .2,
              ),
            ],
          )
        ],
      ),
    );
  }

  void UpdateCallback() {
    widget.countCallBack(_ammount);
  }
}
