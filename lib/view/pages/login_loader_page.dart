//
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/api/login_api.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/pages/delivery_home_page.dart';
import 'package:surtiSP/view/pages/home_page.dart';

class LoginLoaderPage extends StatefulWidget {
  final String loginName;
  final String loginPassword;

  LoginLoaderPage(this.loginName, this.loginPassword);

  @override
  _LoginLoaderPageState createState() => _LoginLoaderPageState();
}

class _LoginLoaderPageState extends State<LoginLoaderPage> {
  // ! Temp

  LoginState loginState = LoginState.INNACTIVE;

  @override
  void initState() {
    super.initState();
    loginState = LoginState.INNACTIVE;
    login();
  }

  @override
  Widget build(BuildContext context) {
    var stateString = "";
    switch (loginState) {
      case LoginState.LOADING:
        stateString = "${T.PLEASE_WAIT} $loadedMessage";
        break;
      case LoginState.FAILED:
        stateString = "${T.LOGIN_FAILED} $loadedMessage";
        break;
      case LoginState.TIME_OUT:
        stateString = "${T.TIMED_OUT_LOG} $loadedMessage";
        break;
      case LoginState.LOADED:
        if (loaded) {
          stateString = "${T.LOADED} $loadedMessage";
        } else {
          stateString = "${T.PLEASE_WAIT} $loadedMessage";
        }
        break;
      case LoginState.INNACTIVE:
      default:
        stateString = " $loadedMessage";
    }

    return Scaffold(
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
                          stateString,
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
    );
  }

  void login() {
    LoginSend loginParams = new LoginSend(
      user: widget.loginName,
      psw: widget.loginPassword,
    );
    LoginApi.loginSessionCoroutine(
      loginParams,
      (loginParams, loginState) {
        sayLoginState(loginState);
      },context
    );
    return;
  }

  void openHomeScreen() {
    Navigator.of(context).pushReplacement(
      PageTransition(
          type: PageTransitionType.slideUp,
          child: Home(),
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 500)),
    );
  }

  Future<Client> useIntentToGetUser(String ptCode) async {
    var clientGroup = await ClientApi.getLocalClientGroup();
    var clients = clientGroup.clients;
    int size = clientGroup.clients.length;
    Client client;
    for (int i = 0; i < size; i++) {
      client = clients[i];
      if (client.shippingAddress == null) continue;
      if (client.shippingAddress.ptIndex == null) continue;
      if (client.shippingAddress.ptIndex == ptCode) return client;
    }
    return null;
  }

  void loadUserPageWithIntent(String ptCode) async {
    var client = await useIntentToGetUser(ptCode);
    setState(() {
      loadedMessage = "Creando de PT Code ${UserController.client.ptCode}";
    });
    UserController.cart.initCart();
    UserController.client = client.fromClient();
    UserController.client.ptCode = ptCode;
    Navigator.of(context).pushReplacement(
      PageTransition(
        curve: Curves.easeOutCirc,
        type: PageTransitionType.slideLeft,
        child: HomePage(),
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  bool loaded = false;
  String loadedMessage = "";
  void sayLoginState(LoginState state) {
    switch (state) {
      case LoginState.LOADED:
        // Wait 550 ms

        UserController.discounts.initDiscounts(
          () {
            setState(
              () {
                loaded = true;
              },
            );
            
            Timer(
              Duration(milliseconds: 550),
              () {
                if (UserController.client.ptCode == "") {
                  openHomeScreen();
                } else {
                  print("START ------");
                  //QUEMADO
                  setState(() {
                    loadedMessage =
                        "Cargando de PT Code ${UserController.client.ptCode}";
                  });
                  loadUserPageWithIntent(UserController.client.ptCode);
                }
                MyApp.enableUI();
              },
            );
          },context
        );

        break;
      case LoginState.FAILED:
        MyApp.enableUI();
        Timer(Duration(milliseconds: 550), () {
          Navigator.pop(context);
        });
        break;
      case LoginState.INNACTIVE:
      case LoginState.LOADING:
      case LoginState.TIME_OUT:
      default:
        MyApp.disableUI();
        break;
    }
    setState(
      () {
        loginState = state;
      },
    );
  }
}
