

import 'package:flutter/material.dart';
import 'package:surtiSP/styles/sp/colors.dart';

Widget bottomButtonSP(
    String _text,
    Function _action,
    ){
  return Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CS.WHITE,
        ),
        child: FlatButton(
          onPressed: _action,
          child: Text(
            _text,
            style: TextStyle(color: CS.DEEP_SEA_BLUE),
          ),
        ),
      ),
    ),
  );
}