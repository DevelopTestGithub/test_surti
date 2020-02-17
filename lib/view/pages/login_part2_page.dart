//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/debug_config.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/styles/colors.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/transitions/exit_enter_route.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/pages/login_loader_page.dart';

class LoginPart2Page extends StatefulWidget {
  final String loginName;

  LoginPart2Page(this.loginName);

  @override
  _LoginPart2PageState createState() => _LoginPart2PageState();
}

class _LoginPart2PageState extends State<LoginPart2Page> {
  // ! Temp
  TextEditingController mainController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //TODO: new autologin button imminent

    if (Global.env.debugConf.useUserAuth) {
      AutoLogin loginData = Global.env.debugConf.userAuth;
      mainController.text = loginData.pasword;
    }

    return Stack(children: [
      Scaffold(
        backgroundColor: C.BACKGROUND,
        body: SingleChildScrollView(
          child: Container(
            color: CS.DEEP_SEA_BLUE,
            height: MyApp.screenHeightRaw,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                            child: SizedBox(
                          height: MyApp.screenHeight * .01,
                        )),
                      
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Contraseña",
                            style: Style.XL_B_W,
                          ),
                        ),
                          Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Escriba su contraseña",
                            maxLines: 2,
                            style: Style.MEDIUM_B_W,
                          ),
                        ),
                          Container(
                            child: SizedBox(
                          height: MyApp.screenHeight * .1,
                        )),
                      
                        Container(
                          height: 80,
                          width: MyApp.screenWidth * .55,
                          child: TextField(
                            controller: mainController,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            style: Style.SMALL_B_B,
                            decoration: InputDecoration(
                              hintText: 'Ingrese su contraseña',
                              alignLabelWithHint: true,
                              //TODO: to new style
                              hintStyle: Style.SMALL_B_G,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MyApp.screenHeight * .13,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              //NEXT
                              Navigator.of(context).push(EnterExitRoute(
                                  exitPage: this.widget,
                                  enterPage: LoginLoaderPage(widget.loginName,
                                      this.mainController.value.text)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: CS.IN_GRAY,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MyApp.screenWidth * .68,
                              alignment: Alignment.center,
                              child: Text(
                                "Continuar",
                                style: Style.MEDIUM_B_DSB,
                              ),
                              height: 48,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      MainHeader(() {
        Navigator.pop(context);
        
      },color: CS.WHITE,)
    ]);
  }
}
