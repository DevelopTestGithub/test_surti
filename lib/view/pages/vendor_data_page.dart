

import 'package:flutter/material.dart';
import 'package:surtiSP/api/purchase_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/purchase_send.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/button_main.dart';
import 'package:surtiSP/view/common/main_header.dart';

class VendorDataPage extends StatelessWidget {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _id = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _code = TextEditingController();
  
  final VoidCallback restartCart;
  VendorDataPage({this.restartCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              width: MyApp.screenWidth,
              height: MyApp.screenHeightRaw,
              color: Colors.blueGrey,
              alignment: Alignment.topLeft,
              child: Stack(alignment: Alignment.topLeft, children: [
          Container(
              width: MyApp.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      child: SizedBox(
                    height: MyApp.screenHeight * .01,
                  )),
                  Text(
                    T.TITLE,
                    style: Style.TITLE,
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .09,
                  ),
                  
                  Container(
                    color: Colors.grey,
                    height: 40,
                    width: 200,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: "nombre del tendero"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .006,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 40,
                    width: 200,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _phone,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: "su numero celular"),
                      ),
                    ),
                  ),
                   SizedBox(
                    height: MyApp.screenHeight * .006,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 40,
                    width: 200,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _address,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: "direccion"),
                      ),
                    ),
                  ),
                   SizedBox(
                    height: MyApp.screenHeight * .006,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 40,
                    width: 200,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _id,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: "cedula"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .006,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 40,
                    width: 200,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: _code,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                            hintText: "codigo"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .1,
                  ),
                  ButtonMainAnim(null,"Terminar", () {
                    purchase(context);
                  }, true, buttonType: ButtonType.SIMPLE,),
                ],
              )),
          MainHeader(
            () {
              Navigator.pop(context);
            },
          ),
              ]),
            )
        ));
  }

  purchase(BuildContext context) async {
    print("PATRON es: ${_name.value.text} #: ${_phone.value.text}");
    PurchaseSend purchaseData = PurchaseSend(
        user: UserController.me,
        newUser: _name.value.text,
        address: _address.value.text,
        code: _code.value.text,
        id: _id.value.text,
        phoneNumber: int.parse(_phone.value.text),
        vendor: true);
    MyApp.disableUI();
    var purchase = await PurchaseApi.createPurchase(purchaseData, context);
    MyApp.enableUI();

    if (purchase.purchaseSuccessful) {
      print("purchase: complete");
      UserController.cart.setCartAsInactive();
      restartCart();
      Navigator.pop(context);
    } else {
      print("purchase: had an issue");
    }
  }
}
