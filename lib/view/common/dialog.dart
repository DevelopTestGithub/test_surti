import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';

actionButton(
    String text,
    Function action
    ) {
  return FlatButton(
    onPressed: () {
      print(text);
      action();
    },
    child: Text(text),
  );
}

boxedText(String _text){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CS.DEEP_SEA_BLUE
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          _text,
          style: Style.MEDIUM_B_W,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

lightBoxCreator(
    BuildContext sscreenContext,
    BuildContext _context,
    Widget _content,
    Function _accept,
    List<Widget> actions,
    ) {
  showDialog(
    context: _context,
    builder: (BuildContext _context) {
      return Theme(
        data: ThemeData(
          dialogBackgroundColor: CS.DEEP_SEA_BLUE_T
        ),
        child: AlertDialog(
          content: Stack(
            children: <Widget>[
              Container(
                  height: MyApp.screenHeightRaw,
                  width: MyApp.screenWidth,
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(_context).pop();
                    },
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,

                        )),
                  )),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _content,
                ),
              ),
            ],
          ),
          actions: actions
        )
      );
    },
  );
}