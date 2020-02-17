//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/consts/texts_es.dart' as texts;
import 'package:surtiSP/models/user_status.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/http/http_check.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/dialog.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/wrappers/connection.dart';

import 'common/cartDrawer.dart';
import 'common/infoDrawer.dart';

///SURTI SCREEN
///
/// Adds bottom bar, and [MainHeader] automatically wise
///

abstract class SScreen extends StatefulWidget {
  String snackBarOpeningMessage;
  String topTextHint = "texto aqui";
  bool offlineMode = false;
  bool resizeToAvoidBottomInset = true;
  bool enableMainHeader = false;
  bool mainHeaderOverlayed = false;
  bool updateCartDetection = false;
  bool snackActive = false;
  bool snackBarMessagePending = false;
  bool forceCartButtonInnactive = false;
  bool hideHeaderCartButton = true;
  bool focusOnTextfield = false;
  Color backgroundColor;
  VoidCallback callbackBackButton;
  VoidCallback nativeAndroidButtonCallback;
  VoidCallback openCartDrawer;
  VoidCallback openInfoDrawer;
  MessageCallback textEditingCallback;
  Color mainHeaderColor;
  double height, width;

  SScreen({this.snackBarOpeningMessage = ""}) {
    if (snackBarOpeningMessage != "") {
      snackBarMessagePending = true;
    }
  }

  void setOpeningMessage({String snackBarOpeningMessage = ""}) {
    this.snackBarOpeningMessage = snackBarOpeningMessage;
    if (snackBarOpeningMessage != "") {
      snackBarMessagePending = true;
    }
  }

  String snackBarMessagePersistent = "";

  void initStateParams({@required bool updateCartDetection}) {
    this.updateCartDetection = updateCartDetection;
  }
}

abstract class SurtiState<T extends SScreen> extends State<T> {
  static const double BOTTOM_BAR_HEIGHT = 45;
  static const Duration SHOW_SNACK_BAR_ANIMATION = Duration(milliseconds: 300);
  static bool internetActive = false;

  Widget child;
  bool withBottomBar = false;
  bool isOrderActive = false;
  int cartItemCount = 0;
  double cartValue = 0.0;

  @override
  void initState() {
    widget.height = MyApp.screenHeightRaw;
    widget.width = MyApp.screenWidth;
    withBottomBar = UserController.cart.allegedCartActive;
    isOrderActive = UserController.me.hasActiveOrders;
    super.initState();
    loadUserStatus(updateCart: widget.updateCartDetection);
    if (widget.snackBarMessagePending) {
      widget.snackBarMessagePending = false;
      snackBar(widget.snackBarOpeningMessage);
    }
    _setInternetConnectionListener();
  }

  void _setInternetConnectionListener() {
    Connection.setConnectionStream(
      (boolean) {
        safeSetState(
          () {
            internetActive = boolean;
          },
        );
      },
    );
  }

  void safeSetState(VoidCallback safeState) {
    if (mounted)
      setState(
        () {
          safeState();
        },
      );
  }

  void loadUserStatus({bool updateCart = true}) {
    updateUserStatus((active) {
      print("SSCREEN: sending cart update");
      safeSetState(() {
        print("SSCREEN: cart data received ${active.isCartActive}");
        isOrderActive = active.isActiveOrder;
      });
    }, updateCart);
  }

  void setChild(Widget child, T widget) {
    this.child = child;
  }

  /*
  @override
  void didPopNext() {
    // Covering route was popped off the navigator.  
    _setInternetConnectionListener();
  }
  */

  Widget buildExternal(
      {@required Color backgroundColor,
      @required Widget child,
      VoidCallback nativeAndroidButtonCallback,
      bool updateCartDetection = false,
      bool enableMainHeader = false,
      Color mainHeaderColor = Colors.black,
      bool forceCartButtonInnactive = false,
      bool mainHeaderOverlayed = false,
      bool hideHeaderCartButton = true,
      bool resizeToAvoidBottomInset = true,
      String topTextHint = "texto aquí",
      VoidCallback callbackBackButton,
      MessageCallback textEditingCallback}) {
    double topPad = 0, bottomPad = 0;

    final keyboardBottom = MediaQuery.of(context).viewInsets.bottom;
    print("keyboard bottom:: $keyboardBottom");

    widget.height = MyApp.screenHeightRaw;
    widget.height -= keyboardBottom;
    widget.width = MyApp.screenWidth;

    widget.backgroundColor = backgroundColor;
    widget.nativeAndroidButtonCallback = nativeAndroidButtonCallback;
    widget.enableMainHeader = enableMainHeader;
    widget.mainHeaderColor = mainHeaderColor;
    widget.forceCartButtonInnactive = forceCartButtonInnactive;
    widget.updateCartDetection = updateCartDetection;
    widget.mainHeaderOverlayed = mainHeaderOverlayed;
    widget.callbackBackButton = callbackBackButton;
    widget.hideHeaderCartButton = hideHeaderCartButton;
    widget.resizeToAvoidBottomInset = resizeToAvoidBottomInset;
    widget.textEditingCallback = textEditingCallback;
    widget.topTextHint = topTextHint;

    if (widget.enableMainHeader && widget.mainHeaderOverlayed) {
      widget.height -= MainHeader.HEADER_HEIGHT;
      topPad = MainHeader.HEADER_HEIGHT;
    }
    bool keyboardUp = (keyboardBottom > 2);
    if (withBottomBar && !forceCartButtonInnactive && !keyboardUp) {
      widget.height -= BOTTOM_BAR_HEIGHT;
      bottomPad = BOTTOM_BAR_HEIGHT;
    }

    List<Widget> widgetList = List<Widget>();

    /* main Childs */
    widgetList.add(
      Padding(
        padding: EdgeInsets.only(top: topPad, bottom: bottomPad),
        child: Container(
          height: widget.height,
          width: widget.width,
          child: child,
        ),
      ),
    );

    /* bottom bar (CART) */
    if (withBottomBar && !forceCartButtonInnactive) {
      widgetList.add(
        Padding(
          padding:
              EdgeInsets.only(top: MyApp.screenHeightRaw - BOTTOM_BAR_HEIGHT),
          child: bottomBar(context),
        ),
      );
    }

    /* Header bar */
    if (widget.enableMainHeader) {
      widgetList.add(
        MainHeader(
          () {
            widget.callbackBackButton();
          },
          cartButton: !widget.hideHeaderCartButton
              ? () {
                  widget.openCartDrawer();
                }
              : null,
          color: widget.mainHeaderColor,
        ),
      );
    }

    if (widget.textEditingCallback != null) {
      widgetList.add(
        Container(
          height: 76,
          width: MyApp.screenWidth,
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 35,
            width: MyApp.screenWidth * .62,
            alignment: Alignment.center,
            child: new TextField(
              onChanged: widget.textEditingCallback,
              autofocus: true,
              textAlignVertical: TextAlignVertical.center,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.grey[800]),
                hintText: widget.topTextHint,
                fillColor: Colors.white70,
              ),
            ),
          ),
        ),
      );
    }

    /* Add Snack bar */
    double SNACK_BAR_W_PADDING = 10;
    double SNACK_BAR_H_PADDING = 25;
    double SNACK_BAR_H = 50;
    double SNACK_BAR_W_PADDING_HALF = SNACK_BAR_W_PADDING * .5;
    double snackBottomVisual = SNACK_BAR_H + SNACK_BAR_H_PADDING;
    double snackTop = 0;
    double snackBottom = 0;

    if (widget.snackActive) {
      snackTop = 0;
      snackBottom = (MyApp.screenHeightRaw - snackBottomVisual);
    } else {
      snackTop = -snackBottomVisual;
      snackBottom = MyApp.screenHeightRaw;
    }

    widgetList.add(
      AnimatedPositioned(
        duration: SHOW_SNACK_BAR_ANIMATION,
        curve: Curves.easeInOut,
        top: snackTop,
        bottom: snackBottom,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.only(
              left: SNACK_BAR_W_PADDING_HALF,
              top: SNACK_BAR_H_PADDING,
              right: SNACK_BAR_W_PADDING_HALF),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              alignment: Alignment.center,
              width: widget.width - SNACK_BAR_W_PADDING,
              height: SNACK_BAR_H,
              color: Colors.blueGrey,
              child: Text(
                widget.snackBarMessagePersistent,
                style: Style.SNACK_BAR,
              ),
            ),
          ),
        ),
      ),
    );

    /* Internet indicator */
    String internetString;
    Color internetColor;
    if (internetActive) {
      internetString = texts.T.INTERNET_ON;
      internetColor = Colors.green;
    } else {
      internetString = texts.T.INTERNET_NEED;
      internetColor = Colors.red;
    }
    widgetList.add(
      SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            width: MyApp.screenWidth/4,
            height: 12,
            decoration: BoxDecoration(
                color: internetColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  internetString,
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),

              ],
            ),
          ),
        ),
      ),
    );

    return WillPopScope(
        onWillPop: () async {
          //Back button
          widget.nativeAndroidButtonCallback();
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          drawer: InfoDrawer(),
          endDrawer: CartDrawer(
            prevPage: this.widget,
            refreshCartCallback: (clean) {
              if (!widget.offlineMode) return;
              if (clean)
                safeSetState(() {
                  withBottomBar = false;
                });
              loadUserStatus();
            },
          ),
          body: LayoutBuilder(
            builder: (context, constraint) {
              widget.openInfoDrawer = () {
                Scaffold.of(context).openDrawer();
              };
              print("CART IN");
              widget.openCartDrawer = () {
                Scaffold.of(context).openEndDrawer();
              };
              return Container(
                color: widget.backgroundColor,
                width: MyApp.screenWidth,
                height: MyApp.screenHeightRaw,
                child: Stack(
                  children: widgetList,
                ),
              );
            },
          ),
        ));
  }

  lightBox(
    BuildContext _context,
    Widget _content,
    Function _accept,
    List<Widget> _actions,
  ) async {
    lightBoxCreator(
      context,
      _context,
      _content,
      _accept,
      _actions,
    );
  }

  ///Dialog:
  /// Receives:
  /// - String title
  /// - String _content: Content of the dialog.
  /// - Function _accept: Function executed when "Aceptar" is pushed.
  dialog(
    BuildContext _context,
    String _title,
    String _content,
    Function _accept,
  ) {
    showDialog(
      context: _context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text(_title),
          content: Text(_content),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                print('Cancel');
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            FlatButton(
              onPressed: () {
                print('Aceptar');
                Navigator.pop(context);
                _accept();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  openInfoDrawer() {
    Scaffold.of(context).openEndDrawer();
  }

  void snackBar(String message, {int customTimer = 2000}) {
    safeSetState(
      () {
        widget.snackActive = true;
        widget.snackBarMessagePersistent = message;
      },
    );
    Timer(
      Duration(milliseconds: customTimer),
      () {
        safeSetState(
          () {
            widget.snackActive = false;
          },
        );
      },
    );
  }

  void updateUserStatus(UserStatusCallback callback, bool cartUpdate) {
    //if(!Connection.isConnectedOnline()){
    //   if(UserController.cart.getTotalInCart() > 0){

    //   }
    //  return;
    // }

    
    if (cartUpdate) {
      HttpCheck.isUserActiveRoutine((active) {
        callback(active);
      }, context);
    } else {
      callback(UserStatus());
    }

  }

  /*to new class */
  Widget bottomBar(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.openCartDrawer();
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        height: BOTTOM_BAR_HEIGHT,
        width: widget.width,
        color: Colors.green,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(UserController.cart.allegedCartCount.toString(),
                      style: Style.FINISH_PURCHASE)),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(texts.T.FINISH_PURCHASE,
                    style: Style.FINISH_PURCHASE)),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                      "\$ " +
                          UserController.cart.allegedCartValue
                              .toStringAsFixed(2),
                      style: Style.FINISH_PURCHASE)),
            )
          ],
        ),
      ),
    );
  }
}
