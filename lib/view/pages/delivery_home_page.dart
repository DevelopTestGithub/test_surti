//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/user.dart';
import 'package:surtiSP/styles/sp/sp_style.dart' as prefix0;
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/transitions/getIntent.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/pages/clients_list_page.dart';
import 'package:surtiSP/view/pages/deliveries_page.dart';
import 'package:surtiSP/view/pages/home_page.dart';
import 'package:surtiSP/view/pages/sync_gate_page.dart';
import 'package:surtiSP/view/pages/unifiedOrder_page.dart';
import 'package:surtiSP/view/s_screen.dart';
import 'package:surtiSP/wrappers/connection.dart';

import '../../main.dart';
import '../../styles/colors.dart';

enum HomePageState { PERFECT, GOT_INTENT }

class Home extends SScreen {
  HomePageState state = HomePageState.PERFECT;

  Home();
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends SurtiState<Home> with WidgetsBindingObserver {
  static const double W_PADDING = 20;
  static const double CELL_PADDING = 10;
  static const double FI = 0.61802;
  static const double COLUMN_PROPORTION = 0.7639287204;

  static const platform = const MethodChannel('app.channel.shared.data');

  bool syncing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadIntent();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      GetIntent.intentInitialization(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _button(Function _onPress, String _label, IconData _icon) {
      return SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: GestureDetector(
            onTap: _onPress,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      _label,
                      style: Style.BUTTON_BIG,
                    ),
                    Icon(
                      _icon,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );
    }

    double mainWidth = MyApp.screenWidth - W_PADDING * 2;
    double proportionalHeight = mainWidth * (1 - FI);

    double halfWidth = (mainWidth - CELL_PADDING) * .5;
    double fiWidth = (mainWidth - CELL_PADDING) * FI;
    double fiNegWidth = (mainWidth - CELL_PADDING) * (1 - FI);

    User test = UserController.client;

    _homeDeliveryPage(){
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: W_PADDING,
              right: W_PADDING,
            ),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: mainWidth,
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        print('-----------test');

                        setState(() {
                          syncing = true;
                        });

                        super.lightBox(
                            context,
                            SyncGate(),
                            (){},
                            [],
                        );
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: MainHeader.HEADER_HEIGHT),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: C.DARK_SKY_BLUE)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('SYNC', style: prefix0.Style.LARGE_B_W),
                                  Text(
                                    '01/01/2020 - 08:35',
                                    style: prefix0.Style.SMALLER_B_W,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  //TODO: Insert Action
                                  print('-----------------sync');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      FontAwesomeIcons.sync,
                                      color: C.WHITE,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: CELL_PADDING),
                      child: Container(
                        width: mainWidth,
                        height: proportionalHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: proportionalHeight,
                              width: halfWidth,
                              child: _button(
                                    () {
                                  print('${T.SELL}');
                                  Navigator.of(context).push(
                                    PageTransition(
                                      curve: Curves.easeOutCirc,
                                      type: PageTransitionType.slideLeft,
                                      child: ClientsPage(ClientsListType.SELL),
                                      duration: const Duration(milliseconds: 200),
                                    ),
                                  );
                                },
                                T.SELL,
                                FontAwesomeIcons.cashRegister,
                              ),
                            ),
                            Container(
                              height: proportionalHeight,
                              width: halfWidth,
                              child: _button(() {
                                print('${T.DELIVER}');
                                Navigator.of(context).push(
                                  PageTransition(
                                    curve: Curves.easeOutCirc,
                                    type: PageTransitionType.slideLeft,
                                    child: DeliveriesPage(
                                      DeliveriesType.ALL_ACTIVE,
                                      null,
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                  ),
                                );
                              }, T.DELIVER, FontAwesomeIcons.shippingFast),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: CELL_PADDING),
                      child: Container(
                        width: mainWidth,
                        height: proportionalHeight * COLUMN_PROPORTION,
                        child: _button(
                              () {
                            print('${T.GENERAL_LIST}');
                            Navigator.of(context).push(
                              PageTransition(
                                  curve: Curves.easeOutCirc,
                                  type: PageTransitionType.slideLeft,
                                  child: HomePage(offlineMode: !Connection.isConnectedOnline()),
                                  duration: const Duration(milliseconds: 200)),
                            );
                          },
                          "store", //TEMPORAL
                          FontAwesomeIcons.accusoft,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: CELL_PADDING),
                      child: Container(
                        width: mainWidth,
                        height: proportionalHeight * COLUMN_PROPORTION,
                        child: _button(
                              () {
                            print('${T.GENERAL_LIST}');
                            Navigator.of(context).push(
                              PageTransition(
                                  curve: Curves.easeOutCirc,
                                  type: PageTransitionType.slideLeft,
                                  child: UnifiedOrder(),
                                  duration: const Duration(milliseconds: 200)),
                            );
                          },
                          T.GENERAL_LIST,
                          FontAwesomeIcons.listOl,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: CELL_PADDING),
                      child: Container(
                        width: mainWidth,
                        height: proportionalHeight,
                        child: _button(
                              () {
                            print('${T.CLIENTS}');
                            Navigator.of(context).push(
                              PageTransition(
                                  curve: Curves.easeOutCirc,
                                  type: PageTransitionType.slideLeft,
                                  child: ClientsPage(ClientsListType.CLIENTS),
                                  duration: const Duration(milliseconds: 200)),
                            );
                          },
                          T.CLIENTS,
                          FontAwesomeIcons.users,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            color: C.DEEP_SEA_BLUE,
            height: MainHeader.HEADER_HEIGHT * .75,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MainHeader.HEADER_HEIGHT * .75,
            ),
            child: Container(
              height: MainHeader.HEADER_HEIGHT * .5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [C.DEEP_SEA_BLUE_T, C.DEEP_SEA_BLUE],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Container(),
            ),
          ),
          MainHeader(
                () {
              super.widget.openInfoDrawer();
            },
            color: Colors.white,
            backButtonIsMenuButton: true,
          ),
          (widget.state == HomePageState.GOT_INTENT)
              ? Container(
            width: MyApp.screenWidth,
            height: MyApp.screenHeightRaw,
            color: Colors.black87,
            alignment: Alignment.center,
            child: Text(
              "Cargando Cliente",
              style: Style.BUTTON_BIG,
            ),
          )
              : Container()
        ],
      );
    }


    return buildExternal(
      backgroundColor: C.DEEP_SEA_BLUE,
      updateCartDetection: false,
      forceCartButtonInnactive: true,
      child: _homeDeliveryPage(),
    );
  }

  void loadIntent() async {
    safeSetState(() {
      widget.state = HomePageState.GOT_INTENT;
    });
    bool loadedIntent = await GetIntent.intentInitialization(context);
    /* IF ptCode loaded */
    if (loadedIntent) {
      safeSetState(() {
        widget.state = HomePageState.GOT_INTENT;
      });

      UserController.discounts.initDiscounts(() {
        Navigator.of(context).push(
          PageTransition(
            curve: Curves.easeOutCirc,
            type: PageTransitionType.slideLeft,
            child: HomePage(),
            duration: const Duration(milliseconds: 200),
          ),
        );
      }, context);
    }
    safeSetState(() {
      widget.state = HomePageState.PERFECT;
    });
  }
}
