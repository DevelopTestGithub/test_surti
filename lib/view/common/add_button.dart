//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/colors.dart';

enum TypeOfAddButton { ADDITION, SUBSTRACTION }

class AddButton extends StatelessWidget {
  final TypeOfAddButton type;
  final VoidCallback callback;
  final double size;

  AddButton(this.type, this.callback, {@required this.size});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    double underPadding = 0;

    switch (type) {
      case TypeOfAddButton.SUBSTRACTION:
        icon = Icons.remove;
        underPadding = 5;
        break;
      case TypeOfAddButton.ADDITION:
      default:
        icon = Icons.add;
        underPadding = 0;
        break;
    }

    //double size = MyApp.screenHeight * .1;
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lime,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: () {
            callback();
            print('press');
          },
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: C.DARK_COLOR_BG_TXT,
                )),
          ),
        ));
  }
}
