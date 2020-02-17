import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/geo/map_image.dart';
import 'package:surtiSP/view/common/button_user.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/common/text_container.dart';

class ClientActivationPage extends StatefulWidget {
  final Client model;
  bool loading = false;
  ClientActivationPage({this.model});

  @override
  _ClientActivationPageState createState() => _ClientActivationPageState();
}

class _ClientActivationPageState extends State<ClientActivationPage> {
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
      body: (widget.loading)
          ? Container(
              width: MyApp.screenWidth,
              height: MyApp.screenHeight,
              alignment: Alignment.center,
              child: Container(width: 300, child: Spinner()),
            )
          : Stack(
              children: [
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
                            height: MyApp.screenHeight * .2,
                          ),
                          Container(
                            width: MyApp.screenWidth * .8,
                            child: Text(
                              "Bienvenido a Surti ${widget.model.firstName} ${widget.model.lastName}",
                              style: Style.BIT_LARGER_B_W,
                              maxLines: 30,
                            ),
                          ),
                          SizedBox(
                            height: MyApp.screenHeight * .06,
                          ),
                          Container(
                            width: MyApp.screenWidth * .6,
                            child: Text(
                              "Al oprimir el boton, el usuario recibira un SMS con el código de registro. \n  \n Asegurese que el cliente tenga descargada la app SURTI.",
                              style: Style.MEDIUM_B_W,
                              maxLines: 30,
                            ),
                          ),
                          TextContainer(
                            title: "Número de teléfono",
                            content:
                                "${widget.model.shippingAddress.phoneNumber}",
                          ),
                          SizedBox(
                            height: MyApp.screenHeight * .07,
                          ),
                          (widget.model.shippingAddress.latitud != 0.0 &&
                                  widget.model.shippingAddress.longitud != 0.0)
                              ? MapImage(
                                  lat: widget.model.shippingAddress.latitud,
                                  long: widget.model.shippingAddress.longitud,
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                          SizedBox(
                            height: MyApp.screenHeight * .07,
                          ),
                          SizedBox(
                            height: MyApp.screenHeight * .015,
                          ),
                          UserBtn(
                            text: "Activar",
                            width: width,
                            height: buttonHF2,
                            altColor: CS.ORANGE,
                            callback: () {
                              /* */
                              activateClient();
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
              ],
            ),
    );
  }

  void activateClient() async {
    setState(
      () {
        widget.loading = true;
      },
    );
    ClientEnrollment data = ClientEnrollment(
        widget.model, widget.model.shippingAddress.phoneNumber);
    var response = await ClientApi.upgradeBasicClient(data, context);
    response.toString();

    var message = "";

    if (response == null) {
      message = "error";
    } else {
      message = "Mensaje listo";
    }

    switch (response) {
      case ActivationResponseType.ERROR:
        message = "Hubo problemas, intente mas tarde";
        break;
      case ActivationResponseType.INVALID:
        message = "Teléfono es invalido";
        break;
      case ActivationResponseType.CUSTOMER_DOESNT_EXIST:
        message = "Cliente no existe";
        break;
      case ActivationResponseType.LACKS_PHONE:
        message = "Necesitamos Teléfono";
        break;
      case ActivationResponseType.OK:
        message = "Listo!";
        break;
      case ActivationResponseType.PHONE_USED:
        message = "Teléfono ya existe";
        break;
    }

    setState(() {
      widget.loading = false;
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: CS.DEEP_SEA_BLUE,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
