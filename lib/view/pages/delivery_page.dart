import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:surtiSP/api/client_api.dart';
import 'package:surtiSP/api/order_api.dart';
import 'package:surtiSP/models/clients.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/order.dart';
import 'package:surtiSP/models/order_extended.dart';
import 'package:surtiSP/models/order_group.dart';
import 'package:surtiSP/styles/fonts.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sizes.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/date/brute_date.dart';
import 'package:surtiSP/util/money/price.dart';
import 'package:surtiSP/view/common/button_user.dart';
import 'package:surtiSP/view/common/dialog.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/price_tag.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/common/toasts.dart';
import 'package:surtiSP/view/pages/client_page.dart';
import 'package:surtiSP/view/pages/deliveries_page.dart';
import 'package:surtiSP/view/pages/product_list.dart';
import 'package:surtiSP/view/pages/product_page.dart';
import 'package:surtiSP/view/s_screen.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../main.dart';
import '../../styles/colors.dart';

class DeliveryPage extends SScreen {
  final int orderId;

  DeliveryPage(this.orderId);
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends SurtiState<DeliveryPage> {
  _DeliveryPageState();
  OrderStatusType currentStatus = OrderStatusType.LOADING;
  bool isLoading = false;
  bool isDeleting = false;
  Color statusColor = CS.APPLE_GREEN;
  String shippingStatusString = "";
  OrderExtended order;

  bool clientLoaded = false;
  int clientId;
  Client clientSlotWhenLoaded;

  String orderDate;
  String orderTime;

  @override
  void initState() {
    _loadOrder();
    super.initState();
  }

  void _loadClient(int clientId) async {
    print("LOADING CLIENT");
    Client clientResponse = await ClientApi.getClient(clientId, context);
    if (clientResponse != null) {
      clientSlotWhenLoaded = clientResponse;
      clientLoaded = true;
      setState(
        () {},
      );
      print("LOADING CLIENT 2");
    } else {
      print("LOADING CLIENT 4");
      return;
    }
    print("LOADING CLIENT333");
  }

  void _loadOrder() async {

    ExtOrderGroup orders;

    setState(
      () {
        isLoading = true;
      },
    );

    orders = await OrderApi.getOrderById(widget.orderId, context);
    if (orders == null) {
      Navigator.of(context).pop();
      return;
    }
    if (orders.orders.length <= 0) {
      Navigator.of(context).pop();
      return;
    }
    order = orders.orders[0];
    orderDate = DateFormat('d').format(order.orderDate) +
        " de " +
        BruteDate.monthToMes(
            DateFormat('MMMM').format(order.orderDate)) +
        ", " +
        DateFormat('y').format(order.orderDate);
    orderTime = DateFormat('h:mm a').format(order.orderDate);

    switch (order.status) {
      case OrderStatusType.CANCELLED:
        shippingStatusString = T.ORDER_CANCELLED_BTN; //To texts
        statusColor = Colors.red;
        break;
      case OrderStatusType.ON_THE_WAY:
        shippingStatusString = T.ORDER_ON_THE_WAY_BTN;
        statusColor = CS.DEEP_SEA_BLUE;
        break;
      case OrderStatusType.ORDERED:
        shippingStatusString = T.ORDER_ORDERED_BTN;
        statusColor = CS.APPLE_GREEN;
        break;
      case OrderStatusType.DELIVERED:
        shippingStatusString = T.ORDER_DELIVERED_BTN;
        statusColor = CS.IN_GRAY;
        break;
      default:
        shippingStatusString = T.ORDER_LOADING_BTN;
    }

    _loadClient(order.customerId);
    setState(
      () {
        isLoading = false;
      },
    );
  }

  Widget _productCell(int, orderId, model, update, action) {
    return InkWell(
        onTap: () {
          action();
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MyApp.screenWidth * .9,
              height: 84,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: CS.IN_GRAY),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MyApp.screenWidth * .27 * .9,
                    height: 84,
                    color: CS.WHITE_3,
                    //Image
                    child: Container(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: model.item.images[0].src,
                        fit: BoxFit.cover,
                        //width: 1000.0,
                      ),
                      color: CS.WHITE_3,
                    ),
                  ),
                  Container(
                    width: MyApp.screenWidth * (1 - .27) * .9,
                    height: 84,
                    color: CS.WHITE_3,
                    //Image
                    child: Container(
                      color: CS.IN_GRAY,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: MyApp.screenWidth *
                                            (1 - .27) *
                                            .9 *
                                            .6,
                                        minWidth: MyApp.screenWidth *
                                                (1 - .27) *
                                                .9 *
                                                .6 -
                                            1),
                                    child: AutoSizeText(
                                      model.item.name,
                                      style: Style.MEDIUM_M_DSB,
                                      maxLines: 1,
                                    )),
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: MyApp.screenWidth *
                                            (1 - .27) *
                                            .9 *
                                            .6,
                                        minWidth: MyApp.screenWidth *
                                                (1 - .27) *
                                                .9 *
                                                .6 -
                                            1),
                                    child: AutoSizeText(
                                      "${model.item.price} X ${model.quantity}",
                                      style: Style.MEDIUM_M_DSB,
                                      maxLines: 1,
                                    ))
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {

                                    setState(() {
                                      isDeleting = true;
                                    });

                                    print(
                                        'Deleting ${model.item.name} - ${orderId.toString()} - ${model.item.id}');

                                    bool deleted = await OrderApi.editProduct(
                                        EditProductAction.DELETE,
                                        orderId,
                                        model.item.id,
                                        0,
                                        context);

                                    if (deleted) {

                                      setState(() async {
                                        _loadOrder();
                                        order.items.removeAt(int);
                                        isDeleting = false;
                                      });
                                    }
                                  },
                                  child: isDeleting
                                      ? Container(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(),
                                        )
                                      : Icon(
                                          Icons.delete_forever,
                                          color: CS.DEEP_SEA_BLUE,
                                        ),
                                ),
                                Text(
                                  "${Price(model.item.price * model.item.ammount).getFormatted()}",
                                  style: Style.MEDIUM_B_DSB,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
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

  @override
  Widget build(BuildContext context) {
    var price = null;

    if (order == null) {
    } else {
      price = order.orderTotal;
    }

    return buildExternal(
      backgroundColor: C.DEEP_SEA_BLUE,
      updateCartDetection: false,
      callbackBackButton: backButton,
      nativeAndroidButtonCallback: backButton,
      forceCartButtonInnactive: true,
      topTextHint: T.PICK_ORDER,
      enableMainHeader: true,
      mainHeaderColor: CS.DEEP_SEA_BLUE,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: MyApp.screenWidth,
              height: MainHeader.HEADER_HEIGHT,
              color: CS.WHITE_3,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, right: 20, bottom: 10, left: 60),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "#${widget.orderId}",
                          style: Style.BIT_LARGER2_B_DSB,
                        ),
                        Text(
                          shippingStatusString,
                          style: Style.MEDIUM_B_DSB,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: (price != null)
                          ? PriceTag(
                              price,
                              dollarStyle: Style.SUBT_B_NB,
                              centStyle: Style.MEDIUM_B_NB,
                            )
                          : Text("  ", style: Style.SUBT_B_NB),
                    )
                  ],
                ),
              ),
            ),
            isLoading
                ? Center(child: Spinner())
                : Padding(
                    padding: EdgeInsets.only(top: MainHeader.HEADER_HEIGHT),
                    child: Container(
                      width: MyApp.screenWidth,
                      child: Stack(
                        children: [
                          Container(
                            width: MyApp.screenWidth,
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    (orderDate == null)
                                        ? "     "
                                        : orderDate,
                                    style: Style.MEDIUM_M_W,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: MyApp.screenWidth * .9,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: CS.WHITE_3,
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          width: MyApp.screenHeight * .3,
                                          child: Text(
                                            shippingStatusString,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontSize: Sizes.MEDIUM,
                                              fontFamily: Fonts.MAIN_FONT,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RoundButtonAnim(
                                          () {
                                            stateChangeLightBox();
                                          },
                                          enabled:
                                              0 != order.items.length,
                                          text: "Cambiar Estado",
                                          icon: null,
                                          proportionSize: .3,
                                          height: 50,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 130, right: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    print('Agregando productos');
                                    Navigator.of(context).push(
                                      PageTransition(
                                          curve: Curves.easeOutCirc,
                                          type: PageTransitionType.slideLeft,
                                          child: ProductList(
                                            action:
                                                ProductAction.ADD_ITEM_ORDER,

                                            orderId: order.id,
                                            update: (){
                                              _loadOrder();
                                            },

                                          ),
                                          duration: const Duration(
                                              milliseconds: 200)),
                                    );
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text('Agregar producto',
                                          style: Style.SMALLER_B_W),
                                      Icon(FontAwesomeIcons.cartPlus,
                                          color: C.WHITE),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 150),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Container(
                                      width: MyApp.screenWidth * .9,
                                      child: ListView.builder(
                                        itemBuilder: (context, int) {
                                          var product = order.items[int];
                                          return _productCell(
                                            int,
                                            widget.orderId,
                                            product,
                                            () {
                                              _loadOrder();
                                            },
                                            () {
                                              Navigator.of(context).push(
                                                PageTransition(
                                                  curve: Curves.easeOutCirc,
                                                  type: PageTransitionType
                                                      .slideLeft,
                                                  child: ProductPage(
                                                    product.item,
                                                    (string) {},
                                                    ProductAction
                                                        .EDIT_ITEM_ODER,
                                                    refresh: () {
                                                      _loadOrder();
                                                    },
                                                    orderID: widget.orderId,
                                                    openCart: () {},
                                                  ),
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        itemCount: order.items.length,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MyApp.screenWidth,
                                  height: 140 /* 80+60 */,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          alignment: Alignment.centerLeft,
                                          width: MyApp.screenWidth * .9,
                                          height: 60,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "Dirección", // TODO: to Constants
                                                  style: Style.SMALL_M_W,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: AutoSizeText(
                                                  order.shippingAddress
                                                      .address1,
                                                  style: Style.MEDIUM_M_W,
                                                  maxLines: 1,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          width: MyApp.screenWidth * .9,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: CS.WHITE_3,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                RoundButtonAnim(
                                                    cancelOrderPrompth,
                                                    enabled: OrderStatusType
                                                                .CANCELLED ==
                                                            order.status
                                                        ? false
                                                        : true,
                                                    text: "Cancelar Pedido",
                                                    icon: Icons.cancel),
                                                RoundButtonAnim(
                                                  () {
                                                    Navigator.of(context).push(
                                                      PageTransition(
                                                        curve:
                                                            Curves.easeOutCirc,
                                                        type: PageTransitionType
                                                            .slideLeft,
                                                        child: ClientPage(
                                                            model:clientSlotWhenLoaded),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                      ),
                                                    );
                                                  },
                                                  text: "Cliente",
                                                  icon: Icons
                                                      .supervised_user_circle,
                                                  /* If client is loaded then activate button */
                                                  enabled: clientLoaded,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  cancelOrderPrompth() {
    cancelOrderPrompthAsync();
  }

  bool _cancelingOrder = false;
  cancelOrderPrompthAsync() async {
    lightBox(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            boxedText('¿Está seguro de cancelar?'),
            UserBtn(
              text: "Cancelar",
              width: 120,
              height: BUTTON_HEIGHT,
              callback: () async {
                await cancelOrder();
                Navigator.pop(context);
              },
            ),
            Container(
              height: 15,
            ),
            UserBtn(
              text: "Volver",
              width: 120,
              height: BUTTON_HEIGHT,
              callback: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        () {},
        []);
  }

  cancelOrder() async {
    print('Cancelando');

    Navigator.pop(context);
    setState(() {
      isLoading = true;
    });
    await OrderApi.cancelOrder(widget.orderId, context);

    print('Orden cancelada');
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
    Toasts.shortMessage("Su orden fue cancelada");

    _loadOrder();
  }

  setReasonsLightBox() {
    super.lightBox(
        context,
        Container(
            height: MyApp.screenHeightRaw,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Cambiar Estado", style: Style.MEDIUM_B_W),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                RoundButtonAnim(
                  () {
                    //
                    //cancelOrder()
                  },
                  text: "No Estaba",
                  height: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                RoundButtonAnim(
                  () {
                    //
                  },
                  text: "Ocupado",
                  height: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                RoundButtonAnim(
                  () {
                    //
                  },
                  text: "Cerrado",
                  height: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                RoundButtonAnim(
                  () {
                    //
                  },
                  text: "Dejo de existir",
                  height: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                RoundButtonAnim(
                  () {
                    //
                  },
                  text: "misc",
                  height: 50,
                ),
              ],
            )),
        () {},
        []);
  }

  stateChangeLightBox() {
    super.lightBox(
      context,
      Container(
        height: MyApp.screenHeightRaw,
        alignment: Alignment.center,
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Cambiar Estado", style: Style.MEDIUM_B_W),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 20,
              ),
              RoundButtonAnim(
                () {
                  OrderApi.shipOrder(widget.orderId, () {
                    _loadOrder();
                  }, context);
                  Navigator.of(context).pop();
                  _loadOrder();
                },
                text: "En Camino",
                height: 50,
                /* */
                enabled: (order.status == OrderStatusType.ORDERED),
              ),
              SizedBox(
                height: 20,
              ),
              RoundButtonAnim(
                () {
                  OrderApi.deliverOrder(widget.orderId, () {
                    _loadOrder();
                  }, context);
                  Navigator.of(context).pop();
                  _loadOrder();
                },
                text: "Entregado",
                height: 50,
                /* */
                enabled: (order.status == OrderStatusType.ON_THE_WAY),
              ),
              Container(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.white,
                  height: 2,
                  width: 12,
                ),
                height: 50,
              ),
              RoundButtonAnim(
                () {
                  Navigator.of(context).pop();
                  cancelOrderPrompth();
                },
                text: "Cancelar Pedido",
                height: 50,
                enabled: !(OrderStatusType.CANCELLED == order.status),
                /* */
              ),
            ],
          ),
        ]),
      ),
      () {},
      [],
    );
  }

  void backButton() {
    Navigator.pop(context);
  }
}

class RoundButtonAnim extends StatefulWidget {
  final bool enabled;
  final String text;
  final IconData icon;
  final double proportionSize;
  final double height;
  final VoidCallback callback;
  bool buttonPressed;
  RoundButtonAnim(this.callback,
      {this.text,
      this.icon,
      this.proportionSize = 0.34,
      this.height = 60,
      this.enabled = true}) {
    buttonPressed = false;
  }

  @override
  _RoundButtonAnimState createState() => _RoundButtonAnimState();
}

class _RoundButtonAnimState extends State<RoundButtonAnim> {
  @override
  Widget build(BuildContext context) {
    double buttonW = MyApp.screenWidth * widget.proportionSize;
    double buttonH = widget.height;

    double buttonWMPad = buttonW - 20;
    double buttonHMPad = buttonH - 20;
    double iconSize = 24;

    if (widget.icon == null) {
      iconSize = 0;
    }

    Color bg = CS.DEEP_SEA_BLUE;
    TextStyle text = Style.MEDIUM_M_W;
    Color border = CS.WHITE_3;
    if (widget.buttonPressed) {
      bg = CS.WHITE_3;
      text = Style.MEDIUM_M_DSB;
      border = CS.DEEP_SEA_BLUE;
    }
    if (!widget.enabled) {
      bg = CS.IN_GRAY;
      text = Style.MEDIUM_M_W;
      border = CS.IN_GRAY;
    }

    return InkWell(
      onTap: () {
        setState(() {
          widget.buttonPressed = false;
        });
        if (widget.enabled) widget.callback();
      },
      onTapCancel: () {
        setState(() {
          widget.buttonPressed = false;
        });
      },
      onTapDown: (stepState) {
        setState(() {
          widget.buttonPressed = true;
        });
      },
      child: Container(
        width: buttonW,
        height: buttonH,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: bg,
            border: Border.all(width: 1, color: border)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: text.color,
              size: iconSize,
            ),
            SizedBox(width: 3),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 20,
                maxWidth: buttonWMPad - iconSize - 3,
                minHeight: buttonHMPad - 30,
                maxHeight: buttonHMPad,
              ),
              child: AutoSizeText(
                widget.text,
                style: text,
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double proportionSize;
  final double height;
  RoundButton(
      {this.text, this.icon, this.proportionSize = 0.34, this.height = 60});

  @override
  Widget build(BuildContext context) {
    double buttonW = MyApp.screenWidth * proportionSize;
    double buttonH = height;

    double buttonWMPad = buttonW - 20;
    double buttonHMPad = buttonH - 20;
    double iconSize = 24;

    if (icon == null) {
      iconSize = 0;
    }

    return Container(
      width: buttonW,
      height: buttonH,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: CS.DEEP_SEA_BLUE,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: CS.WHITE_3,
            size: iconSize,
          ),
          SizedBox(width: 3),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 20,
              maxWidth: buttonWMPad - iconSize - 3,
              minHeight: buttonHMPad - 30,
              maxHeight: buttonHMPad,
            ),
            child: AutoSizeText(
              text,
              style: Style.MEDIUM_M_W,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
