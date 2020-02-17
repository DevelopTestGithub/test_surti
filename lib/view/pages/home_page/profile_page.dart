
//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/view/pages/home_page.dart';

class ProfilePage extends StatelessWidget {
  static const PROPORTIONAL_SIZE = 0.8;

  final bool open;
  final VoidCallback closePage;

  ProfilePage(this.open, {this.closePage});

  @override
  Widget build(BuildContext context) {
    double width = (1 - PROPORTIONAL_SIZE) * MyApp.screenWidth;
    double reversewidth = PROPORTIONAL_SIZE * MyApp.screenWidth;
    double left = width, right = 0;

    if (!open) {
      left = MyApp.screenWidth;
      right = -reversewidth;
    }

    return AnimatedPositioned(
      duration: HomePage.duration,
      curve: Curves.easeInOut,
      top: 0,
      bottom: 0,
      left: left,
      right: right,
      child: Container(
        color: Colors.green,
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: reversewidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      SizedBox(
                        height: MyApp.screenHeight * .01,
                      ),
                      InkWell(
                        onTap: () {
                          closePage();
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Icon(Icons.arrow_back_ios,
                                size: 29, color: Colors.black)),
                      ),
                      SizedBox(
                        height: MyApp.screenHeight * .05,
                      )
                    ]),
                    Column(
                      children: <Widget>[
                        Text(
                          "NOMBRE",
                          style: TextStyle(
                              color: Colors.black,
                              //!FIX TO CORRECT STYLING
                              fontSize: 24),
                        ),
                        Text(
                          "APELLIDO",
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MyApp.screenWidth * .05,
                    ),
                    Column(
                      children: [
                        Icon(Icons.build, size: 20, color: Colors.black),
                        SizedBox(
                          height: MyApp.screenHeight * .05,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MyApp.screenWidth * .01,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MyApp.screenHeight * .1,
              ),
              SizedBox(
                height: MyApp.screenHeight * .1,
              ),
              SizedBox(
                height: MyApp.screenHeight * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Log out",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    width: MyApp.screenWidth * .05,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
