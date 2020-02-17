

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:surtiSP/styles/sp/colors.dart';

class Toasts{

  static void shortMessage(String _message){
    Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: CS.DEEP_SEA_BLUE,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}