

//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/debug_config.dart';
import 'package:surtiSP/models/jwt_token.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/styles/colors.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/persistency/persistentData.dart';
import 'package:surtiSP/util/transitions/exit_enter_route.dart';
import 'package:surtiSP/util/transitions/getIntent.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/pages/delivery_home_page.dart';
import 'package:surtiSP/view/pages/login_part2_page.dart';
import 'package:surtiSP/wrappers/jwt.dart';


class LoginPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  bool loaded = false;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const platform = const MethodChannel('app.channel.shared.data');
  TextEditingController mainController = new TextEditingController();
  var sharedData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkOnSavedLoginTokens();
    _cleanPTCodeLock();
  }

  void _cleanPTCodeLock(){
     GetIntent.cleanLock();
  }

  void _checkOnSavedLoginTokens() async {
    var data = await PersistentData.load();

    if (data != null) {
      if (data.loaded != null) {
        if (data.loaded == true && data.token != "" && data.token != null) {
          UserController.me.token = data.token;
          UserController.me.refreshToken = data.refreshToken;

          var jwtData = JWTToken.process(data.token,
              aud: null /*LoginApi.BURNED_AUDIENCE*/);

          if (jwtData != null && jwtData.isValid != null) {
            UserController.me.token = data.token;
            JWT.injectToCode(jwtData);
          }

          UserController.discounts.initDiscounts(() {
            Navigator.of(context).pushReplacement(
              PageTransition(
                  curve: Curves.easeOutCirc,
                  type: PageTransitionType.slideLeft,
                  child: Home(),
                  duration: const Duration(milliseconds: 200)),
            );
          }, context);

          return;
        }
      }
    }
    setState(() {
      widget.loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: new autologin button imminent

    if (Global.env.debugConf.useUserAuth) {
      AutoLogin loginData = Global.env.debugConf.userAuth;
      mainController.text = loginData.user;
    }

    return !widget.loaded
        ? Scaffold(
            backgroundColor: C.DEEP_SEA_BLUE,
            body: SingleChildScrollView(
              child: Container(
                height: MyApp.screenHeightRaw,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Spinner(),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                "Cargando", // TODO TO CONS
                                style: Style.MINI_B_W,
                              ),
                            ),
                            SizedBox(
                              height: MyApp.screenHeight * .04,
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.all(31),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: CS.DEEP_SEA_BLUE,
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
                            SizedBox(
                              height: MyApp.screenHeight * .02,
                            ),
                            Image(
                                image: AssetImage(
                                    "assets/sp/images/surti_img.png")),
                            SizedBox(
                              height: MyApp.screenHeight * .02,
                            ),
                            Text("Vendedor", style: Style.MEDIUM_B_W),
                            SizedBox(
                              height: MyApp.screenHeight * .18,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Ingrese su usuario",
                                style: Style.SMALL_B_W,
                              ),
                            ),
                            Container(
                              height: 80,
                              width: MyApp.screenWidth * .6,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: mainController,
                                keyboardType: TextInputType.emailAddress,
                                style: Style.SMALL_B_B,
                                decoration: InputDecoration(
                                  hintText: 'Ingrese su correo o usuario',
                                  alignLabelWithHint: true,
                                  hintStyle: Style.SMALL_B_G,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                  filled: true,
                                  contentPadding: EdgeInsets.only(
                                      top: 11, bottom: 15, left: 10, right: 10),
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MyApp.screenHeight * .12,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(EnterExitRoute(
                                    exitPage: this.widget,
                                    enterPage: LoginPart2Page(
                                        mainController.value.text.replaceAll(
                                            new RegExp(r"\s+\b|\b\s"), ""))));
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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
                          ],
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(31),
                        child: Text(
                          Global.env.toString(),
                          style: Style.MEDIUM_B_DSB,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
