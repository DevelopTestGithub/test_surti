import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';


class TextContainer extends StatelessWidget {
  final String title;
  final String content;

  const TextContainer({this.content, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        SizedBox(
          height: MyApp.screenHeight * .04,
        ),
        Container(
          width: MyApp.screenWidth * .8,
          child: Text(
            title,
            style: Style.MINI_B_W,
            maxLines: 30,
          ),
        ),
        Container(
          width: MyApp.screenWidth * .6,
          child: Text(
            content,
            style: Style.MEDIUM_B_W,
            maxLines: 30,
          ),
        )
      ]),
    );
  }
}
