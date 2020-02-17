import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/order_api.dart';
import 'package:surtiSP/models/order.dart';
import 'package:surtiSP/models/order_extended.dart';
import 'package:surtiSP/models/order_sp.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/toasts.dart';
import 'package:surtiSP/view/loadding/order_loading.dart';
import 'package:surtiSP/view/s_screen.dart';

import '../../main.dart';
import '../../styles/colors.dart';
import 'delivery_home_page.dart';
import 'delivery_page.dart';

enum DeliveriesType{
  ALL_ACTIVE,
  BY_CLIENT,
}

class DeliveriesPage extends SScreen {
  DeliveriesType type;
  int customerId;

  DeliveriesPage(
    this.type,
    this.customerId
  );
  _DeliveriesPageState createState() => _DeliveriesPageState(type);
}

class _DeliveriesPageState extends SurtiState<DeliveriesPage> {
  DeliveriesType type;
  _DeliveriesPageState(this.type);

  List<OrderSP> _deliveries = [];
  List<OrderSP> _ordered = [];
  List<OrderSP> _onTheWay = [];
  List<OrderSP> _orderedCopy = [];
  List<OrderSP> _onTheWayCopy = [];
  List<Widget> _deliveryList = [];
  TextEditingController _searchText;
  bool isLoading = false;
  bool empty = false;

  @override
  void initState() {
    super.initState();
    _searchText = TextEditingController();
    _loadClients();
  }

  _loadClients() async {
    setState(() {
      isLoading = true;
    });

    switch(this.type){

      case DeliveriesType.ALL_ACTIVE:
        _deliveries = await OrderApi.getOrders2Deliver(context);
        break;
      case DeliveriesType.BY_CLIENT:
        if(null == widget.customerId){
          Toasts.shortMessage("No hay Id del Cliente");
          Navigator.pop(context);
        }

        OrderActiveByCustomer params = OrderActiveByCustomer(widget.customerId.toString());
        _deliveries = await OrderApi.getActiveOrdersByCustomer(params, context);
        break;
    }

    if (0 < _deliveries.length) {
      _organizeDeliveries();
    } else {
      empty = true;
    }

    setState(() {
      isLoading = false;
    });
  }

  _organizeDeliveries(){
    for (int i = 0; i < _deliveries.length; i++){

      switch(OrderExtended.statusFromString(_deliveries[i].orderStatus)){
        case OrderStatusType.ORDERED:
          _ordered.add(_deliveries[i]);
        break;
        default:
          _onTheWay.add(_deliveries[i]);
      }
    }
  }

  Widget _cardColumn(OrderSP _delivery){

    switch(widget.type){

      case DeliveriesType.ALL_ACTIVE:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            null != _delivery.businessName ?
            Text(
              _delivery.businessName,
              style: Style.BIG_BLUE,
            ): Container(),

            null != _delivery.firstName ? null != _delivery.lastName ?
            Text(
              _delivery.firstName + " " + _delivery.lastName,
              style: Style.MEDIUM_BLUE,
            ):Container()
                :Container(),
            null != _delivery.address ?
            Text(
              _delivery.address,
              style: Style.MINI_M_DSB,
            ): Container(),
          ],
        );
        break;

      case DeliveriesType.BY_CLIENT:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              _delivery.getStatus(),
              style: Style.BIG_BLUE,
            ),

            null != _delivery.businessName ?
            Text(
              _delivery.businessName,
              style: Style.MEDIUM_BLUE,
            ): Container(),

            null != _delivery.firstName ? null != _delivery.lastName ?
            Text(
              _delivery.firstName + " " + _delivery.lastName,
              style: Style.SMALL_B_G,
            ):Container()
                :Container(),
          ],
        );
        break;

      default:
        return Container();
        break;
    }
  }
  
  Widget _cardButton(OrderSP _delivery){
    
    switch(widget.type){
      
      case DeliveriesType.ALL_ACTIVE:
          
          if(null != _delivery.code){
            return AutoSizeText(
              _delivery.code,
              style: Style.MEDIUM_B_DSB,
              maxLines: 1,
            );
            
          } else {
            Container();
          }
          
        break;
      case DeliveriesType.BY_CLIENT:
        if(null != _delivery.priceTotal){
          return AutoSizeText(
            _delivery.priceTotal.toStringAsFixed(2) + " \$",
            style: Style.MEDIUM_B_DSB,
            maxLines: 1,
          );

        } else {
          Container();
        }
        break;
    }
  }

  Widget _deliveryCard(OrderSP _delivery) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DeliveryPage(_delivery.id);
            },
          ),
        );
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
                    child: _cardColumn(_delivery),
                    decoration: BoxDecoration(
                        color: C.WHITE,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: _cardButton(_delivery)
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

  _deliveriesPage(){
    return SafeArea(
      child: Stack(
        children: <Widget>[
          isLoading
              ? OrderLoading(type: OrderLoadingType.ORDER,)
              : Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MainHeader.HEADER_HEIGHT,
                    ),
                    Column(
                      children: _deliveryList,
                    ),
                  ],
                ),
              ),
            ),
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
              padding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  _emptyPage(){
    return Center(
      child: Text(
        "EL cliente no tiene ordenes",
        textAlign: TextAlign.center,
        style: Style.MEDIUM_M_W,
      ),
    );
  }

  String _getStarter(OrderSP _actualOrder) {
    String _starter = "";
    if (null != _actualOrder?.firstName) {
      _starter += _actualOrder.firstName;
    }

    if (null != _actualOrder?.lastName) {
      _starter += " " + _actualOrder.lastName;
    }

    if (null != _actualOrder?.businessName) {
      _starter += _actualOrder.businessName;
    }

    if (null != _actualOrder?.code) {
      _starter += _actualOrder.code;
    }

    return _starter;
  }

  void _searchDeliveryList(List<OrderSP> _orderedSearch, List<OrderSP> _onTheWaySearch,){

    if (0 < _deliveries.length) {

      if (0 < _orderedSearch.length ) {
        _deliveryList.add(
          Text(
            "Ordenadas",
            style: Style.MEDIUM_M_W,
          ),
        );

        for (int i = 0; i < _orderedSearch.length; i++) {
          _deliveryList.add(_deliveryCard(_orderedSearch[i]));
        }
      }

      if (0 < _onTheWaySearch.length) {
        _deliveryList.add(
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Text(
              "En camino",
              style: Style.MEDIUM_M_W,
            ),
          ),
        );

        for (int i = 0; i < _onTheWaySearch.length; i++) {
          _deliveryList.add(_deliveryCard(_onTheWaySearch[i]));
        }
      }

      _deliveryList.add(
        SizedBox(
          height: MyApp.screenHeight * .1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    _deliveryList.clear();
    if (_searchText.text != "") {
      _orderedCopy.clear();
      _onTheWayCopy.clear();
      int cachedSize = _deliveries.length;
      for (int i = 0; i < cachedSize; i++) {
        OrderSP _order = _deliveries[i];
        String starter = _getStarter(_order).toLowerCase();
        String find = _searchText.text.toLowerCase();
        bool hasSearchWord = starter.contains(find);
        if (hasSearchWord) {
          switch(OrderExtended.statusFromString(_deliveries[i].orderStatus)){
            case OrderStatusType.ORDERED:
              _orderedCopy.add(_deliveries[i]);
              break;
            default:
              _onTheWayCopy.add(_deliveries[i]);
          }
        }
      }
      _searchDeliveryList(_orderedCopy, _onTheWayCopy);
    } else {
      _searchDeliveryList(_ordered, _onTheWay);
    }

    return buildExternal(
        backgroundColor: C.DEEP_SEA_BLUE,
        updateCartDetection: false,
        callbackBackButton: backButton,
        nativeAndroidButtonCallback: backButton,
        forceCartButtonInnactive: true,
        enableMainHeader: true,
        textEditingCallback: (search) {
          safeSetState(() {
            _searchText.text = search;
            _deliveryList.clear();
          });
        },
        mainHeaderColor: Colors.white,
        child: this.empty ?
            _emptyPage():
            _deliveriesPage(),
    );
  }

  void backButton() {
    Navigator.of(context).pop(
      PageTransition(
        curve: Curves.easeOutCirc,
        type: PageTransitionType.slideLeft,
        child: Home(),
        duration: const Duration(milliseconds: 200),
      ),
    );
  }
}
