

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';

enum inputType{
  TEXT,
  EMAIL,
  PHONE,
  ID,
}

Widget textField(
    String _hintText,
    UniqueKey _key,
    TextEditingController _controller,
    TextInputType _keyboardType,
    List<TextInputFormatter> _formatter,
    Function _validate,
    ){
  return TextFormField(
    key: _key,
    controller: _controller,
    keyboardType: _keyboardType,
    inputFormatters: _formatter,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(8),
      filled: true,
      fillColor: Colors.white,
      hintText: _hintText,
      hintStyle: Style.MEDIUM_GREY,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    ),

    validator: _validate,
  );
}