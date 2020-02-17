import 'package:flutter/material.dart';
import 'package:surtiSP/styles/style_sheet.dart';

class Badge extends StatelessWidget {
  static const double SIZE = 17;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(SIZE / 2)),
          width: SIZE,
          height: SIZE,
          alignment: Alignment.center,
        ),
        Text(
          "!",
          style: Style.BADGE,
        )
      ],
    );
  }
  
}
