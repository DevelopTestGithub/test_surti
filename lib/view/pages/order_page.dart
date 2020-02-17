//
//

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/order_api.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/util/view/size.dart';
import 'package:surtiSP/view/common/button_main.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/order.dart';
import 'package:surtiSP/models/order_extended.dart';
import 'package:surtiSP/models/order_group.dart';
import 'package:surtiSP/models/order_item.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/money/price.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/price_tag.dart';
import 'package:surtiSP/view/loadding/order_loading.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:surtiSP/util/date/brute_date.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  final Order model;
  List<OrderItem> items;

  ExtOrderGroup orders;
  OrderPage({
    @required this.model,
  });

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderStatusType currentStatus = OrderStatusType.LOADING;
  bool isLoading = false;
  OrderExtended order;
  String orderDate;
  String orderTime;
  String shippingStatusString = "";

  @override
  void initState() {
    _loadOrder();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadOrder() async {
    setState(() {
      isLoading = true;
    });

    widget.orders = await OrderApi.getOrderById(widget.model.id,context);
    order = widget.orders.orders[0];
    widget.items = order.items;
    orderDate = DateFormat('d').format(order.orderDate) +
        " de " +
        BruteDate.monthToMes(DateFormat('MMMM').format(order.orderDate)) +
        ", " +
        DateFormat('y').format(order.orderDate);
    orderTime = DateFormat('h:mm a').format(order.orderDate);

    switch (order.shippingStatus) {
      case OrderShippingStatusType.CANCELLED:
        shippingStatusString = T.ORDER_CANCELLED_BTN; //To texts
        break;
      case OrderShippingStatusType.ORDERED:
        shippingStatusString = T.ORDER_ORDERED_BTN;
        break;
      case OrderShippingStatusType.ON_THE_WAY:
        shippingStatusString = T.ORDER_ON_THE_WAY_BTN;
        break;
      case OrderShippingStatusType.DELIVERED:
        shippingStatusString = T.ORDER_DELIVERED_BTN;
        break;
      case OrderShippingStatusType.LOADING:
      default:
        shippingStatusString = T.ORDER_LOADING_BTN;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Order order2Show = widget.model;
    String statusString = stateToString(order2Show.status);
    Price price = Price(order2Show.orderTotal);

    List<Widget> productList = [];
    List<Widget> infoList = [];
    List<Widget> addressList = [];

    Widget products2Show(int index) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              height: MyApp.screenHeight / 8,
              width: MyApp.screenWidth / 4,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.items[index].item.images[0].src,
                fit: BoxFit.cover,
                //width: 1000.0,
              ),
            ),
            title: Text(widget.items[index].item.name),
            subtitle: Text(
              widget.items[index].item.price.toStringAsFixed(2) +
                  ' X ' +
                  widget.items[index].quantity.toString(),
            ),
            trailing: Text(
              widget.items[index].priceWithTax.toStringAsFixed(2) + ' \$',
            ),
          ),
          Divider(),
        ],
      );
    }

    Widget cancelToShow(){
        return 
        Container(
          width: 250,
          height: 80,
          child: ButtonMainAnim(
            null,//FontAwesomeIcons.carrot,
            T.CANCEL,
            () {
              cancelOrder(order.id);
            },
            true,
            sizeSquare:
                SizeSquare(50, MyApp.screenHeight * .098),
          ),
        )
        ;
    }

    Widget addressToShow() {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Dirección de entrega:",
                style: Style.CART_TITLE,
              ),
              Text(
                order.shippingAddress.address1,
                style: Style.CART_TITLE,
              ),
              Text(
                order.shippingAddress.city +
                    ", " +
                    order.shippingAddress.province,
                style: Style.CART_TITLE,
              ),
            ],
          ),
        ),
      );
    }

    Widget infoToShow(){
      return Container(child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

        Text(
            "Fecha de Órden:",
            style: Style.CART_TITLE,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text(
                    orderDate,
                    style: Style.CART_TITLE,
                  ),
                  Text(
                    orderTime,
                    style: Style.CART_TITLE,
                  ),
                ]
              ),
              Container(
                alignment: Alignment.center,
                child:
                Text(
                    shippingStatusString,
                    style: Style.CART_TITLE,
                  ),
              ),
            ],
          ),
            ],
          ),
        ),
      );
    }

    Widget _productsLoading() {
      return ListTile(
        leading: Container(
          height: MyApp.screenHeight / 8,
          width: MyApp.screenWidth / 4,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: OrderLoading(
            type: OrderLoadingType.GENERAL,
          ),
        ),
        title: OrderLoading(
          type: OrderLoadingType.STATUS,
        ),
        subtitle: OrderLoading(
          type: OrderLoadingType.STATUS,
        ),
        trailing: Container(
            width: 10.0,
            child: OrderLoading(
              type: OrderLoadingType.STATUS,
            )),
      );
    }

    if (isLoading) {
      for (int i = 0; i < 4; i++) {
        productList.add(_productsLoading());
      }
    } else {
      for (int i = 0; i < widget.items.length; i++) {
        productList.add(products2Show(i));
        print('${widget.items[i].priceWithTax.toStringAsFixed(2)}');
      }
      infoList.add(infoToShow());
      addressList.add(addressToShow());
      if (order.shippingStatus == OrderShippingStatusType.ORDERED)
        addressList.add(cancelToShow());
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: Container(),
                    pinned: true,
                    expandedHeight: MyApp.screenHeight / 4.5,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Center(
                        child: Stack(
                          children: <Widget>[

                            Opacity(
                              opacity: 0.2,
                              child: Image.asset(
                                'assets/sp/images/promo1.jpg',
                                fit: BoxFit.fitWidth,
                              ),
                            ),

                            SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        statusString,
                                        style: Style.CART_TITLE,
                                      ),
                                      Text(
                                        stateToString(widget.model.status),
                                      ),
                                    ],
                                  ),
                                  PriceTag(widget.model.orderTotal),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 90,
                    delegate: SliverChildListDelegate(
                      infoList,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      productList,
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 90,
                    delegate: SliverChildListDelegate(
                      addressList,
                    ),
                  ),
                ],
              ),
            ),
            MainHeader(
              () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  String stateToString(OrderStatusType type) {
    switch (type) {
      case OrderStatusType.CANCELLED:
        return "Orden esta cancelada";
      case OrderStatusType.DELIVERED:
        return "Orden Entregada";
      case OrderStatusType.LOADING:
        return "Cargando status";
      case OrderStatusType.ON_THE_WAY:
        return "Orden en camino";
      case OrderStatusType.ORDERED:
      default:
        return "Ordenada";
    }
  }

  void cancelOrder(int orderId) async {
    MyApp.disableUI();
    var cancelledOrder = await OrderApi.cancelOrder(orderId,context);
    MyApp.enableUI();

    if (cancelledOrder == null) {
      print("cancel order: returned null");
      return;
    }

    if (cancelledOrder.contains("Ok")) {
      print("cancel order: complete");
      //UserController.cart.setCartAsInactive();
      //backButton(snackBarMessageStarter: T.THANKS_FOR_PURCHASE);
    } else {
      print("cancel order: had an issue");
      //snackBar(T.PURCHASE_ERROR);
    }
    Navigator.pop(context);
  }
}
