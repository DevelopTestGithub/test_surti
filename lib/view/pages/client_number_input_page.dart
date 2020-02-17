import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/view/common/button_user.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/pages/client_activation_page.dart';

class ClientNumberInputPage extends StatelessWidget {
  final Client model;
  TextEditingController mainController = new TextEditingController();

  ClientNumberInputPage({this.model});
  @override
  Widget build(BuildContext context) {
    final double spacingInButtons = 10;

    double width = MyApp.screenWidth * .8;
    double heightForBtn = MyApp.screenHeight * .2;

    double widthhalf = (width - spacingInButtons) * .5;
    double buttonHF1 = (heightForBtn - spacingInButtons) * .61802;
    double buttonHF2 = (heightForBtn - spacingInButtons) * (1 - .61802);

    return Scaffold(
      backgroundColor: CS.DEEP_SEA_BLUE,
      body: Stack(children: [
        Container(
          height: MyApp.screenHeightRaw,
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: MyApp.screenWidth,
              color: CS.DEEP_SEA_BLUE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: MyApp.screenHeight * .4,
                  ),
                  Container(
                    width: MyApp.screenWidth * .6,
                    child: Text(
                      "Ingrése el número de Teléfono",
                      style: Style.MEDIUM_B_W,
                      maxLines: 30,
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .05,
                  ),
                  Container(
                    height: 80,
                    width: MyApp.screenWidth * .55,
                    child: TextField(
                      controller: mainController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: Style.SMALL_B_B,
                      decoration: InputDecoration(
                        hintText: 'Ingrese el número',
                        alignLabelWithHint: true,
                        hintStyle: Style.SMALL_B_G,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(10),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .015,
                  ),
                  UserBtn(
                    text: "Ingrese Número",
                    width: width,
                    height: buttonHF2,
                    callback: () {
                      // FALTA API

                      Navigator.of(context).push(PageTransition(
                          type: PageTransitionType.fadeIn,
                          child: ClientActivationPage(model:model),
                          duration: const Duration(milliseconds: 200)));
                    },
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ),
        MainHeader(
          () {
            Navigator.of(context).pop();
          },
          color: CS.WHITE,
        )
      ]),
    );
  }
}
