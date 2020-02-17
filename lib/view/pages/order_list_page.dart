//
//

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/order.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/money/price.dart';
import 'package:surtiSP/api/order_api.dart';
import 'package:surtiSP/models/order_group.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/loadding/order_loading.dart';
import 'package:surtiSP/view/pages/order_page.dart';
import 'package:surtiSP/util/date/brute_date.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class OrderListPage extends StatefulWidget {
  OrderListPage({Key key}) : super(key: key);
  OrderListState createState() => new OrderListState();
}

class OrderListState extends State<OrderListPage> {
  OrderGroup _ordersList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    MyApp.disableUI();
    _ordersList = await OrderApi.getOrders(context);
    MyApp.enableUI();

    setState(() {
      isLoading = false;
    });

    if (_ordersList == null) {
      /* ORDER FAILED */
      BackButton();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Process the list

    if (isLoading) {
      return OrderLoading(type: OrderLoadingType.GENERAL);
    } else {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: MainHeader.HEADER_HEIGHT),
              child: FullList(_ordersList),
            ),
            MainHeader(
              () {
                Navigator.of(context).pushReplacement(
                  PageTransition(
                      curve: Curves.easeOutCirc,
                      type: PageTransitionType.fadeIn,
                      child: HomePage(startingState: HomePageType.INFO_PAGE),
                      duration: const Duration(milliseconds: 300)),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}

class FullList extends StatelessWidget {
  final OrderGroup _ordersList;
  FullList(this._ordersList);

  @override
  Widget build(BuildContext context) {
    if (_ordersList == null) {
      return Container();
    }
    /* If there are no orders */
    if (_ordersList.orders.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          T.ORDER_LIST_EMPTY,
          style: Style.REGULAR_BLACK,
        ),
      );
    }

    var startList = _ordersList.orders;
    List<Order> activeOrders = List<Order>();
    List<Order> inactiveOrders = List<Order>();
    int cachedListSize = startList.length;

    if (cachedListSize == 0) {
      return Container();
    }

    for (int i = 0; i < cachedListSize; i++) {
      var currentOrder = startList[i];
      switch (currentOrder.status) {
        // ACTIVE
        case OrderStatusType.CANCELLED:
        case OrderStatusType.DELIVERED:
          inactiveOrders.add(currentOrder);
          break;
        // INACTIVE
        case OrderStatusType.ORDERED:
        case OrderStatusType.ON_THE_WAY:
          activeOrders.add(currentOrder);
          break;
        case OrderStatusType.LOADING:
          break;
      }
    }

    int totalListSize = 0;

    // booleans for lists
    bool theresActiveOrders = false;
    bool theresInActiveOrders = false;
    var sepparatorMain = ListSepparatorText.ACTIVE;
    if (activeOrders.length > 0) {
      totalListSize += activeOrders.length;
      theresActiveOrders = true;
    }
    if (inactiveOrders.length > 0) {
      totalListSize += inactiveOrders.length;
      theresInActiveOrders = true;
    }

    // If there's more than one list, there's 2 sepparators
    if (theresInActiveOrders && theresActiveOrders) {
      totalListSize = activeOrders.length + inactiveOrders.length + 2;

      // Else there's only one sepparator
    } else if (theresActiveOrders) {
      totalListSize++;
      sepparatorMain = ListSepparatorText.ACTIVE;
    } else if (theresInActiveOrders) {
      totalListSize++;
      sepparatorMain = ListSepparatorText.INACTIVE;
    }

    return ListView.builder(
      itemCount: totalListSize,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListSepparator(sepparatorMain);
        }
        int modIndex = index - 1;
        if (theresActiveOrders && theresInActiveOrders) {
          // starts with activeOrders
          if (modIndex < activeOrders.length) {
            return OrderButton(
              model: activeOrders[modIndex],
            );
          }

          // minus sepparator and active orders
          modIndex = index - 1 - (activeOrders.length);
          if (modIndex == 0) {
            return ListSepparator(ListSepparatorText.INACTIVE);
          }

          // minus sepparator and active orders AND sepparator 2
          modIndex = index - 1 - (activeOrders.length) - 1;
          if (modIndex < inactiveOrders.length) {
            return OrderButton(
              model: inactiveOrders[modIndex],
            );
          }
        } else if (theresActiveOrders) {
          return OrderButton(
            model: activeOrders[modIndex],
          );
        } else if (theresInActiveOrders) {
          return OrderButton(
            model: inactiveOrders[modIndex],
          );
        }
        //yes
      },
    );
  }
}

class OrderButton extends StatelessWidget {
  static const double //
      HEIGHT = 90,
      INNER_PADDING_SIDES = 20,
      INNER_PADDING_TOP = 10;

  final Order model;
  final VoidCallback callback;

  OrderButton({this.model, this.callback});

  @override
  Widget build(BuildContext context) {
    var buttonWidth = MyApp.screenWidth - INNER_PADDING_SIDES;
    var buttonHeight = HEIGHT - INNER_PADDING_TOP;
    String statusString = "";

    switch (model.shippingStatus) {
      case OrderShippingStatusType.CANCELLED:
        statusString = T.ORDER_CANCELLED_BTN; //To texts
        break;
      case OrderShippingStatusType.ORDERED:
        statusString = T.ORDER_ORDERED_BTN;
        break;
      case OrderShippingStatusType.ON_THE_WAY:
        statusString = T.ORDER_ON_THE_WAY_BTN;
        break;
      case OrderShippingStatusType.DELIVERED:
        statusString = T.ORDER_DELIVERED_BTN;
        break;
      case OrderShippingStatusType.LOADING:
      default:
        statusString = T.ORDER_LOADING_BTN;
    }

    Price orderCostProcess = Price(model.orderTotal);
    String orderIdString = model.id.toString();
    String priceString = orderCostProcess.getFormatted();
    String orderDate = DateFormat('d').format(model.orderDate) +
        " de " +
        BruteDate.monthToMes(DateFormat('MMMM').format(model.orderDate)) +
        ", " +
        DateFormat('y').format(model.orderDate);

    return Container(
      width: MyApp.screenWidth,
      height: HEIGHT,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageTransition(
                curve: Curves.easeOutCirc,
                type: PageTransitionType.slideLeft,
                child: OrderPage(
                  model: model,
                ),
                duration: const Duration(milliseconds: 200)),
          );
          callback();
        },
        child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: buttonWidth - (buttonWidth * .5),
                            child: Text(
                              orderDate,
                              style: Style.ORDER_BTN_TITLE,
                            )),
                        Container(
                          width: buttonWidth - (buttonWidth * .5),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("# " + orderIdString,
                                      style: Style.ORDER_BTN_TITLE)),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(priceString,
                                        style: Style.ORDER_BTN_TITLE)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: buttonHeight,
                    width: buttonWidth * .3, //to constants
                    alignment: Alignment.center,
                    color: Colors.grey,
                    child: Text(
                      statusString,
                      style: Style.REGULAR,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ListSepparatorText { ACTIVE, INACTIVE }

class ListSepparator extends StatelessWidget {
  static const double //
      HEIGHT = 70;

  ListSepparatorText listSepparatorText;
  ListSepparator(this.listSepparatorText);
  @override
  Widget build(BuildContext context) {
    String text = "";
    switch (listSepparatorText) {
      case ListSepparatorText.ACTIVE:
        text = T.ORDERS_ACTIVE;
        break;
      case ListSepparatorText.INACTIVE:
        text = T.ORDERS_INACTIVE;
        break;
    }
    return Container(
      height: HEIGHT,
      width: MyApp.screenWidth,
      alignment: Alignment.center,
      child: Text(
        text,
        style: Style.ORDER_BTN_SEPPARATOR,
      ),
    );
  }
}
