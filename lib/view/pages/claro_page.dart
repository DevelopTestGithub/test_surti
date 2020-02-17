import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/price_tag.dart';

class ClaroPage extends StatefulWidget {
  String hintText = "  ";
  @override
  _ClaroPageState createState() => _ClaroPageState();
}

class _ClaroPageState extends State<ClaroPage> {
  static const String 
      NEEDS_10_CHARS = "Numero telefónico necesita 10 números",
      NEEDS_ANYTHING = "Por Favor ingrese un número";

  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MyApp.screenHeightRaw,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Add one stop for each color. Stops should increase from 0 to 1
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                // ignore: undefined_operator
                Color.fromARGB(255, 215, 22, 22),
                Color.fromARGB(255, 114, 22, 22),
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MainHeader.HEADER_HEIGHT,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 33),
                    child: Text(
                      "Recarga Celular",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .05,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (a) {
                        setState(() {});
                      },
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: Colors.black, fontSize: 34),
                      decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(8.0),
                            ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(
                              color: Colors.grey[800], fontSize: 20),
                          hintText: "Ingrese el celular",
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          fillColor: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .004,
                  ),
                  Text(
                    widget.hintText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .02,
                  ),
                  Text(
                    "Elíja cuanto recargar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .02,
                  ),
                  Container(
                    height: MyApp.screenHeight * .14,
                    width: MyApp.screenWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          plusThisButton(controller.value.text, 3),
                          plusThisButton(controller.value.text, 5),
                          plusThisButton(controller.value.text, 10)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Saldo",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "   total",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                      SizedBox(
                        width: 10,
                      ),
                      PriceTagW(20.0)
                    ],
                  )
                ],
              ),
              MainHeader(
                () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
              ),
            ],
          ),
        ));
  }

  final _formKey = GlobalKey<FormState>();
  openScreen(String number, String chargeAmmount) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    "Recarga de:",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$$chargeAmmount",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Para el número:",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    number,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      width: MyApp.screenWidth * .54,
                      height: MyApp.screenWidth * .14,
                      alignment: Alignment.center,
                      child: Text(
                        "Continuar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget plusThisButton(String number, double ammount) {
    int ammountInt = ammount.toInt();
    return InkWell(
      child: PlusButtonWidget(
        text: "+${ammountInt.toString()}",
        call: () {
          if(controller.value.text == ""){
            setState(() {
              widget.hintText = NEEDS_ANYTHING;
            });
            return;
          }
          
          if(controller.value.text.length < 9){
            setState(() {
              widget.hintText = NEEDS_10_CHARS;
            });
            return;
          }
          openScreen(number, "$ammountInt.00");
        },
      ),
    );
  }
}

class PlusButtonWidget extends StatefulWidget {
  final String text;
  VoidCallback call;
  bool pressed = false;
  PlusButtonWidget({this.text, this.call});
  @override
  _PlusButtonWidgetState createState() => _PlusButtonWidgetState();
}

class _PlusButtonWidgetState extends State<PlusButtonWidget> {
  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color textC = Colors.red;
    if (widget.pressed) {
      bg = Colors.grey;
      textC = Colors.black;
    }
    return InkWell(
        onTap: () {
          setState(() {
            widget.call();
            widget.pressed = false;
          });
        },
        onTapDown: (s) {
          setState(() {
            widget.pressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            widget.pressed = false;
          });
        },
        child: Container(
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20), color: bg),
          width: MyApp.screenWidth * .24,
          height: MyApp.screenWidth * .2,
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
                color: textC, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
