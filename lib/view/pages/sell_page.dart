//
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/models/clients_group.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/pages/client_page.dart';
import 'package:surtiSP/view/s_screen.dart';
import '../../main.dart';
import '../../styles/colors.dart';
import 'delivery_home_page.dart';
import 'home_page.dart';

class SellPage extends SScreen {
  SellPage();
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends SurtiState<SellPage> {
  _SellPageState();

  ClientsGroup _clientsFromServer;
  List<Client> _clients = [];
  List<Widget> _clientsList = [];
  bool isLoading = false;

  @override
  void initState() {
    _loadClients();
    super.initState();
  }

  _loadClients() async {
    setState(() {
      isLoading = true;
    });
    _clientsFromServer = await ClientApi.getClientGroup(context);
    _clients = _clientsFromServer.clients;
    setState(() {
      isLoading = false;
    });
  }

  Widget _button(Function _onPressed, String _text) {
    return InkWell(
      onTap: _onPressed,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Container(
          width:  MyApp.screenWidth*.35*.8,
          decoration: BoxDecoration( 
          color: C.DEEP_SEA_BLUE,borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Text(
              _text,
              style: Style.BUTTON_BIG,
              
              textAlign: TextAlign.center,
            )
          ),
        )
      ),
    );
  }

  Widget _clientCard(Client _client) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: C.WHITE),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    null != _client.businessName ?
                      Text(
                        _client.businessName,
                        style: Style.BIG_BLUE,
                      )
                      : Container(),
                    Text(
                      (null != _client.firstName
                          ? _client.firstName
                          : "" ) +
                      " " +
                      (null != _client.lastName ? _client.lastName : ""),
                      style: Style.MEDIUM_BLUE,
                    ),

                    null != _client.shippingAddress ?
                    "" != _client.shippingAddress.address1 ?
                    Text(
                      _client.shippingAddress.address1,
                      style: Style.SMALL_BLUE,
                    )
                        : Container() : Container()
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        _button(() {
                          print('Vender');
                          UserController.client = _client.fromClient();
                          Navigator.of(context).pushReplacement(
                            PageTransition(
                                curve: Curves.easeOutCirc,
                                type: PageTransitionType.slideLeft,
                                child: HomePage(),
                                duration: const Duration(milliseconds: 200)),
                          );
                        }, T.SELL),
                        _button(() {
                          print('Editar Cliente');

                          UserController.client = _client.fromClient();
                          Navigator.of(context).push(
                            PageTransition(
                                curve: Curves.easeOutCirc,
                                type: PageTransitionType.slideLeft,
                                child: ClientPage(model: _client),
                                duration: const Duration(milliseconds: 200)),
                          );
                        }, T.CLIENT_SEE),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _clientsList.length = 0;
    for (int i = 0; i < this._clients.length; i++) {
      _clientsList.add(_clientCard(_clients[i]));
    }
    _clientsList.add(
      SizedBox(
        height: MyApp.screenHeight * .1,
      ),
    );

    return buildExternal(
        backgroundColor: C.DEEP_SEA_BLUE,
        updateCartDetection: false,
        callbackBackButton: backButton,
        nativeAndroidButtonCallback: backButton,
        forceCartButtonInnactive: true,
        enableMainHeader: true,
        topTextHint: T.PICK_CLIENT,
        textEditingCallback: (search) {},
        mainHeaderColor: Colors.white,
        child: SafeArea(
            child: Stack(children: <Widget>[
          isLoading
              ? Center(child: Spinner())
              : Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: MyApp.screenHeight * .1,
                          ),
                          Column(
                            children: _clientsList,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ])));
  }

  void backButton() {
    Navigator.of(context).pushReplacement(
      PageTransition(
          curve: Curves.easeOutCirc,
          type: PageTransitionType.fadeIn,
          child: Home(),
          duration: const Duration(milliseconds: 300)),
    );
  }
}
