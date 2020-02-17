//
//

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/models/clients_group.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/button_user.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/pages/client_create_page.dart';
import 'package:surtiSP/view/pages/client_page.dart';
import 'package:surtiSP/view/s_screen.dart';

import '../../main.dart';
import '../../styles/colors.dart';
import 'delivery_home_page.dart';
import 'home_page.dart';

enum ClientsListType {
  CLIENTS,
  SEARCH,
  SELL,
}

class ClientsPage extends SScreen {
  ClientsListType displayType;
  String search;
  ClientsPage(this.displayType, {this.search});
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends SurtiState<ClientsPage> {
  _ClientsPageState();

  ClientsGroup _clientsFromServer;
  List<Client> _clients = [];
  List<Widget> _clientsList = [];
  bool isLoading = false;
  String _searchText = "";
  bool isSearching = false;
  bool isQueued = false;

  @override
  void initState() {
    _loadClients();
    super.initState();
  }

  _loadClients() async {
    safeSetState(() {
      isLoading = true;
    });
    _clientsFromServer = await ClientApi.getClientGroup(context);
    _clientsList.clear();
    _clients = _clientsFromServer.clients;
    safeSetState(() {
      isLoading = false;
    });
  }

  Widget _mardisCode(Client _client) {
    if (_client.shippingAddress.ptIndex == null) {
      return Container();
    } else {
      return Text(_client.shippingAddress.ptIndex);
    }
  }

  Widget _button(Function _onPressed, String _text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: _onPressed,
        child: Container(
          alignment: Alignment.center,
          height: 30,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: C.DEEP_SEA_BLUE,
          ),
          child: Text(
            _text,
            style: Style.BUTTON_BIG,
          ),
        ),
      ),
    );
  }

  Widget _clientCard(Client _client) {
    return GestureDetector(
      onTap: () {
        switch (widget.displayType) {
          case ClientsListType.CLIENTS:
            UserController.client = _client.fromClient();
            Navigator.of(context).push(
              PageTransition(
                  curve: Curves.easeOutCirc,
                  type: PageTransitionType.slideLeft,
                  child: ClientPage(model: _client),
                  duration: const Duration(milliseconds: 200)),
            );
            break;
          case ClientsListType.SELL:
          case ClientsListType.SEARCH:
            UserController.client = _client.fromClient();
            Navigator.of(context).push(
              PageTransition(
                curve: Curves.easeOutCirc,
                type: PageTransitionType.slideLeft,
                child: HomePage(),
                duration: const Duration(milliseconds: 200),
              ),
            );
            break;
        }
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          null != _client.businessName
                              ? Text(
                            _client.businessName,
                            style: Style.BIG_BLUE,
                          )
                              : Container(),
                          Text(
                            (null != _client.firstName ? _client.firstName : "") +
                                " " +
                                (null != _client.lastName ? _client.lastName : ""),
                            style: Style.MEDIUM_BLUE,
                          ),
                          null != _client.shippingAddress
                              ? "" != _client.shippingAddress.address1
                              ? Text(
                            _client.shippingAddress.address1,
                            style: Style.SMALL_BLUE,
                          )
                              : Container()
                              : Container()
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: C.WHITE,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      color: ClientsListType.SELL == widget.displayType ? Colors.transparent:Colors.white,
                      child: Container(
                        child: ClientsListType.SELL == widget.displayType
                            ? _button(() {
                          print('Vender');
                          UserController.client = _client.fromClient();
                          Navigator.of(context).push(
                            PageTransition(
                                curve: Curves.easeOutCirc,
                                type: PageTransitionType.slideLeft,
                                child: ClientPage(model: _client),
                                duration:
                                const Duration(milliseconds: 200)),
                          );
                        }, T.CLIENT_SEE)
                            :
                        //_mardisCode(_client),
                        Center(
                          child: AutoSizeText(
                            null != _client?.shippingAddress?.ptIndex ? _client.shippingAddress.ptIndex : "",
                            style: Style.SMALL_BLUE,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  String _getStarter(Client _actualClient) {
    String _starter = "";
    if (null != _actualClient?.firstName) {
      _starter += _actualClient.firstName;
    }

    if (null != _actualClient?.lastName) {
      _starter += " " + _actualClient.lastName;
    }

    if (null != _actualClient?.businessName) {
      _starter += _actualClient.businessName;
    }

    if (null != _actualClient?.shippingAddress?.ptIndex) {
      _starter += _actualClient.shippingAddress.ptIndex;
    }else{
      return _starter ="";
    }
    return _starter;
  }

  @override
  Widget build(BuildContext context) {

    _clientsList.clear();
    if (_searchText != "") {
      int cachedSize = _clients.length;
      for (int i = 0; i < cachedSize; i++) {
        Client _client = _clients[i];
        String starter = _getStarter(_client).toLowerCase();
        String find = _searchText.toLowerCase();
        bool hasSearchWord = starter.contains(find);
        if (hasSearchWord) {
          _clientsList.add(_clientCard(_clients[i]));
          print(starter);
        }
      }
    } else {
      if (0 < _clients.length) {
        for (int i = 0; i < _clients.length; i++) {
          _clientsList.add(_clientCard(_clients[i]));
        }
      }
    }

    _clientsList.add(
      Container(
        height: 75,
      )
    );

    return buildExternal(
        backgroundColor: C.DEEP_SEA_BLUE,
        updateCartDetection: false,
        callbackBackButton: backButton,
        nativeAndroidButtonCallback: backButton,
        forceCartButtonInnactive: true,
        topTextHint: T.PICK_CLIENT,
        enableMainHeader: true,
        textEditingCallback: (search) {
          safeSetState(() {
            print("MESSAGE $search");

            _searchText = search;
            _clientsList = [];
          });
        },
        mainHeaderColor: Colors.white,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
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
              ClientsListType.CLIENTS == widget.displayType
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: C.WHITE,
                          ),
                          child: UserBtn(
                            callback: () {
                              print(T.CLIENT_CREATE);
                              Navigator.of(context).push(PageTransition(
                                  type: PageTransitionType.fadeIn,
                                  child: CreateClientPage(
                                    updateListClient: _loadClients,
                                  ),
                                  duration: const Duration(milliseconds: 200)));
                            },
                            text: T.CLIENT_CREATE,
                            height: MyApp.screenHeight / 10,
                            width: MyApp.screenWidth * 0.9,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                color: C.DEEP_SEA_BLUE,
                height: MainHeader.HEADER_HEIGHT * .5,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MainHeader.HEADER_HEIGHT * .5,
                ),
                child: Container(
                  height: MainHeader.HEADER_HEIGHT * .25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [C.DEEP_SEA_BLUE_T, C.DEEP_SEA_BLUE],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Container(),
                ),
              ),
            ],
          ),
        ));
  }

  void backButton() {
    Navigator.of(context).pop(
      PageTransition(
          curve: Curves.easeOutCirc,
          type: PageTransitionType.fadeIn,
          child: Home(),
          duration: const Duration(milliseconds: 300)),
    );
  }
}
