import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/geo/map_image.dart';
import 'package:surtiSP/util/geo/navigate.dart';
import 'package:surtiSP/view/common/button_user.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/common/text_container.dart';
import 'package:surtiSP/view/pages/client_activation_page.dart';
import 'package:surtiSP/view/pages/client_create_page.dart';
import 'package:surtiSP/view/pages/client_number_input_page.dart';
import 'package:surtiSP/view/pages/deliveries_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientPage extends StatefulWidget {
  final Client model;
  ClientPage({this.model});
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  bool isLoading = false;

  Client clientUpdated;

  Widget _userInfo() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MyApp.screenHeight * .2,
        ),
        Container(
          width: MyApp.screenWidth * .8,
          child: Text(
            (widget.model.businessName != null)
                ? widget.model.businessName
                : "(Falta nombre de local)",
            style: Style.BIT_LARGER_B_W,
            maxLines: 30,
          ),
        ),
        TextContainer(
            title: "Nombre del cliente",
            // TODO: to const
            content:
            "${(widget.model.firstName == "" || widget.model.firstName == null) ? "<Falta Primer Nombre>" : widget.model.firstName} ${(widget.model.lastName == "" || widget.model.lastName == null) ? "<Falta apellido>" : widget.model.lastName} "),
        TextContainer(
            title: "Número de teléfono",
            content: (widget.model.shippingAddress == null || widget.model.shippingAddress.phoneNumber == null)
                ? "<Falta teléfono>"
                : "0${widget.model.shippingAddress.phoneNumber}"),
        TextContainer(
            title: "Dirección",
            content: (widget.model.shippingAddress ==null || widget.model.shippingAddress.address1 == "" ||
                widget.model.shippingAddress.address1 == null)
                ? "<Falta Dirección>"
                : "${widget.model.shippingAddress.address1}"),
        TextContainer(
            title: "Referencia",
            content: (widget.model.shippingAddress == null
                || widget.model.shippingAddress.reference == ""
                || widget.model.shippingAddress.reference == null )
                ? "<no hay referencia>"
                : "${widget.model.shippingAddress.reference}"),
        TextContainer(
            title: "Cedula",
            content: (widget.model.shippingAddress ==null || widget.model.ruc == "" || widget.model.ruc == null )
                ? "<Falta Cedula>"
                : "${widget.model.ruc}"),
        SizedBox(
          height: MyApp.screenHeight * .07,
        ),
        (widget.model.shippingAddress != null && widget.model.shippingAddress.latitud != 0.0 &&
            widget.model.shippingAddress.longitud != 0.0)
            ? MapImage(
          lat: widget.model.shippingAddress.latitud,
          long: widget.model.shippingAddress.longitud,
        )
            : TextContainer(
            title: "Mapa",
            content: (widget.model.shippingAddress ==null || widget.model.ruc == "" || widget.model.ruc == null)
                ? "<Falta posicion de local>"
                : "${widget.model.ruc}"),
        SizedBox(
          height: MyApp.screenHeight * .07,
        )
      ],
    );
  }

  void _updateClient(int clientId) async {
    setState(() {
      isLoading = true;
    });
    print("LOADING CLIENT======");
    Client clientResponse = await ClientApi.getClient(clientId, context);
    if (clientResponse != null) {
      clientUpdated = clientResponse;
      setState(() {
        widget.model.ruc = clientUpdated.ruc;
        widget.model.email = clientUpdated.email;
        widget.model.firstName = clientUpdated.firstName;
        widget.model.lastName = clientUpdated.lastName;
        widget.model.businessName = clientUpdated.businessName;
        widget.model.shippingAddress.phoneNumber = clientUpdated.shippingAddress.phoneNumber;
        widget.model.shippingAddress.address1 = clientUpdated.shippingAddress.address1;
        widget.model.shippingAddress.reference = clientUpdated.shippingAddress.reference;
        widget.model.shippingAddress.latitud = clientUpdated.shippingAddress.latitud;
        widget.model.shippingAddress.longitud = clientUpdated.shippingAddress.longitud;

        isLoading = false;

      });
    } else {
      print("CLIENT NULL =================");
      return;
    }
    print("LOADING CLIENT FINISHED====================");
  }

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
      body:  isLoading
          ? Center(child: Spinner(),)
          :Stack(children: [
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
                  _userInfo(),
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: heightForBtn,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UserBtn(
                                active: null != widget.model.shippingAddress
                                    ? true
                                    : false,
                                text: "Llamar",
                                width: widthhalf,
                                height: buttonHF2,
                                callback: () {
                                  launch(
                                      'tel://0${widget.model.shippingAddress.phoneNumber}');
                                },
                              ),
                              UserBtn(
                                active: false,
                                text: "Mapa",
                                width: widthhalf,
                                height: buttonHF1,
                                callback: () {},
                              ),
                            ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UserBtn(
                              active: true,
                              text: "Ver pedidos",
                              width: widthhalf,
                              height: buttonHF1,
                              callback: () {
                                Navigator.of(context).push(PageTransition(
                                    type: PageTransitionType.fadeIn,
                                    child: DeliveriesPage(
                                        DeliveriesType.BY_CLIENT, widget.model.id),
                                    duration:
                                    const Duration(milliseconds: 200)));
                              },
                            ),
                            UserBtn(
                              active:
                              null != widget.model.shippingAddress ? true : false,
                              text: "Navegar",
                              width: widthhalf,
                              height: buttonHF2,
                              callback: () {
                                Navigate.to(
                                    widget.model.shippingAddress.latitud,
                                    widget.model.shippingAddress.longitud,
                                    widget.model.businessName);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .015,
                  ),
                  UserBtn(
                    text: (widget.model.shippingAddress == null)
                        ? "<Falta dirección>"
                        : (widget.model.shippingAddress.phoneNumber == null)
                        ? "Activar"
                        : "Activar (${widget.model.shippingAddress.phoneNumber})",
                    width: width,
                    height: buttonHF2,
                    callback: () {
                      /* */
                      if (widget.model.shippingAddress.phoneNumber == null ||
                          widget.model.shippingAddress.phoneNumber == "") {
                        Navigator.of(context).push(
                          PageTransition(
                            curve: Curves.easeOutCirc,
                            type: PageTransitionType.slideLeft,
                            child: ClientNumberInputPage(model: widget.model),
                            duration: const Duration(milliseconds: 200),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          PageTransition(
                            curve: Curves.easeOutCirc,
                            type: PageTransitionType.slideLeft,
                            child: ClientActivationPage(model: widget.model),
                            duration: const Duration(milliseconds: 200),
                          ),
                        );
                      }
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
        ),
        Container(
          width: MyApp.screenWidth,
          height: MainHeader.HEADER_HEIGHT,
          alignment: Alignment.topRight,
          child: Padding(
            padding:
            EdgeInsets.only(top: MainHeader.HEADER_HEIGHT - 43, right: 20),
            child: InkWell(
              onTap: () {
                //
                Navigator.of(context).push(
                  PageTransition(
                    curve: Curves.easeOutCirc,
                    type: PageTransitionType.slideLeft,
                    child: CreateClientPage(
                      placeModelToTurnCreatePageIntoModifyPage: widget.model,
                      updateClient: (){
                        _updateClient(widget.model.id);
                      },
                    ),
                    duration: const Duration(milliseconds: 200),
                  ),
                );
              },
              child: Icon(
                Icons.edit,
                size: 26,
                color: CS.WHITE,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
