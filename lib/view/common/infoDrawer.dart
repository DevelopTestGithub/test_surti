import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/persistency/persistentData.dart';
import 'package:surtiSP/util/persistency/products_persistency.dart';
import 'package:surtiSP/util/transitions/getIntent.dart';
import 'package:surtiSP/util/transitions/open_app.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/pages/clients_list_page.dart';
import 'package:surtiSP/view/pages/deliveries_page.dart';
import 'package:surtiSP/view/pages/help_page.dart';
import 'package:surtiSP/view/pages/delivery_home_page.dart';
import 'package:surtiSP/view/pages/login_page.dart';
import 'package:surtiSP/view/pages/sell_page.dart';
import 'package:surtiSP/view/pages/unifiedOrder_page.dart';

class InfoDrawer extends StatefulWidget {
  InfoDrawer();
  _InfoDrawerState createState() => _InfoDrawerState();
}

class _InfoDrawerState extends State<InfoDrawer> {
  _InfoDrawerState();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: CS.DEEP_SEA_BLUE,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: CS.NAVY,
                image: DecorationImage(
                  image: ExactAssetImage('assets/sp/images/surti.png'),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
            ),
            ListTile(
              title: new Text(
                T.BACK_TO_SELLER,
                style: Style.MEDIUM_M_W,
              ),
              trailing: Icon(
                FontAwesomeIcons.home,
                color: CS.WHITE,
              ),
              onTap: () {
                GetIntent.lockCurrentIntentPTCode();
                UserController.me.currentId = UserController.me.promosId;
                Navigator.of(context).pushReplacement(
                  PageTransition(
                      curve: Curves.easeOutCirc,
                      type: PageTransitionType.slideLeft,
                      child: Home(),
                      duration: const Duration(milliseconds: 200)),
                );
              },
            ),
            ListTile(
              title: new Text(
                T.SELL,
                style: Style.MEDIUM_M_W,
              ),
              trailing: Icon(
                FontAwesomeIcons.cashRegister,
                color: CS.WHITE,
              ),
              onTap: () {
                UserController.me.currentId = UserController.me.promosId;
                Navigator.of(context).push(
                  PageTransition(
                    curve: Curves.easeOutCirc,
                    type: PageTransitionType.slideLeft,
                    child: ClientsPage(ClientsListType.SELL),
                    duration: const Duration(milliseconds: 200),
                  ),
                );
              },
            ),
            ListTile(
                title: new Text(
                  T.DELIVER,
                  style: Style.MEDIUM_M_W,
                ),
                trailing: Icon(
                  FontAwesomeIcons.truckLoading,
                  color: CS.WHITE,
                ),
                onTap: () {
                  UserController.me.currentId = UserController.me.promosId;
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                        curve: Curves.easeOutCirc,
                        type: PageTransitionType.slideLeft,
                        child: DeliveriesPage(DeliveriesType.ALL_ACTIVE, 0),
                        duration: const Duration(milliseconds: 200)),
                  );
                }),
            ListTile(
                title: new Text(
                  T.GENERAL_LIST,
                  style: Style.MEDIUM_M_W,
                ),
                trailing: Icon(
                  FontAwesomeIcons.listOl,
                  color: CS.WHITE,
                ),
                onTap: () {
                  UserController.me.currentId = UserController.me.promosId;
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                        curve: Curves.easeOutCirc,
                        type: PageTransitionType.slideLeft,
                        child: UnifiedOrder(),
                        duration: const Duration(milliseconds: 200)),
                  );
                }),
            ListTile(
                title: new Text(
                  T.CLIENTS,
                  style: Style.MEDIUM_M_W,
                ),
                trailing: Icon(
                  FontAwesomeIcons.users,
                  color: CS.WHITE,
                ),
                onTap: () {
                  UserController.me.currentId = UserController.me.promosId;
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                        curve: Curves.easeOutCirc,
                        type: PageTransitionType.slideLeft,
                        child: ClientsPage(ClientsListType.CLIENTS),
                        duration: const Duration(milliseconds: 200)),
                  );
                }),
            Divider(color: CS.WHITE),
            ListTile(
              title: Text(
                T.HELP,
                style: Style.MEDIUM_M_W,
              ),
              trailing: new Icon(
                Icons.help_outline,
                color: CS.WHITE,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  PageTransition(
                      curve: Curves.easeOutCirc,
                      type: PageTransitionType.slideLeft,
                      //child: OrderPage(),
                      child: HelpPage(),
                      duration: const Duration(milliseconds: 200)),
                );
              },
            ),
            ListTile(
              title: Text(
                T.SIGN_OUT,
                style: Style.MEDIUM_M_W,
              ),
              trailing: new Icon(
                Icons.exit_to_app,
                color: CS.WHITE,
              ),
              onTap: () {
                PersistentData.erase();
                Navigator.of(context).pushAndRemoveUntil(
                    PageTransition(
                    curve: Curves.easeOutCirc,
                    type: PageTransitionType.slideLeft,
                    //child: OrderPage(),
                    child: LoginPage(),
                    duration: const Duration(milliseconds: 200)
                    ),
                    (Route<dynamic> route) => false
                );

              },
            ),
            ListTile(
                title: Text(
                  "ODK",
                  style: Style.MEDIUM_M_W,
                ),
                trailing: new Icon(
                  Icons.exit_to_app,
                  color: CS.WHITE,
                ),
                onTap: () {
                  OpenApp.launch("org.odk.collect.android", "odkagreegate");
                }),
          ],
        ),
      ),
    );
  }
}
