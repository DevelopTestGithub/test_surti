

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/order_api.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/order_item.dart';
import 'package:surtiSP/styles/sp/colors.dart';
import 'package:surtiSP/styles/sp/sp_style.dart' ;
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/price_tag.dart';
import 'package:surtiSP/view/loadding/order_loading.dart';
import 'package:surtiSP/view/pages/delivery_home_page.dart';
import 'package:surtiSP/view/s_screen.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../main.dart';

class UnifiedOrder extends SScreen{

  UnifiedOrderState createState() => UnifiedOrderState();
}

class UnifiedOrderState extends SurtiState<UnifiedOrder>{

  UnifiedOrderState();

  List<OrderItem> _unifiedOrders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders()async{

    setState(() {
      isLoading = true;
    });

    _unifiedOrders = await OrderApi.getUnifiedOrder(context);

    setState(() {
      isLoading = false;
    });

  }

  double _getPrice(){
    double totalPrice = 0;
    for (int i=0; i<_unifiedOrders.length; i++){
      totalPrice += (_unifiedOrders[i].item.price * _unifiedOrders[i].quantity);
    }
    return totalPrice;
  }

  Widget _products2Show (BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(

          decoration: BoxDecoration(
            color: CS.WHITE,
          ),
          

          child: Row(
            children: <Widget>[
              Container(
                height: MyApp.screenHeight / 8,
                width: MyApp.screenWidth / 4,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: _unifiedOrders[index].item.images[0].src,
                  fit: BoxFit.cover,
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    _unifiedOrders[index].item.name,
                    style: Style.MEDIUM_M_DSB,
                  ),
                ),
              ),

              Container(
                width: MyApp.screenWidth/8,
                height: MyApp.screenHeight / 8,
                color: Colors.white,
                child: Center(
                  child: Text(
                    _unifiedOrders[index].quantity.toString(),
                    style: Style.MEDIUM_B_DSB,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingTotalOrder(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Container(
          child: Text(
            T.LOADING_UNIFIED_ORDER,
            style: Style.SMALL_B_W,
            textAlign: TextAlign.center,
            maxLines: 2,
          )
        ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: OrderLoading(type: OrderLoadingType.ORDER,),
          )
        ],
      ),
    );
  }

  Widget _totalOrder(){
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
            height: MainHeader.HEADER_HEIGHT,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  T.UNIFIED_ORDER,
                  style: Style.LARGE_B_W,
                ),
                PriceTag(_getPrice()),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: MainHeader.HEADER_HEIGHT,),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Style.GATTER_PADDING,
                    right: Style.GATTER_PADDING),
                child: ListView.builder(
                  itemBuilder: _products2Show,
                  itemCount: _unifiedOrders.length,
                ),
              ),
            ),
          ),
          
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return buildExternal(
      updateCartDetection: false,
      forceCartButtonInnactive: false,
      backgroundColor: CS.DEEP_SEA_BLUE,
      nativeAndroidButtonCallback: (){
        _backButton();
      },
      enableMainHeader: true,
      callbackBackButton: () {
        _backButton();
      },
      child: isLoading ?
        _loadingTotalOrder() :
        _totalOrder(),
    );
  }

  void _backButton(){
    Navigator.of(context).pop(
      PageTransition(
          curve: Curves.easeOutCirc,
          type: PageTransitionType.slideLeft,
          child: Home(),
          duration: const Duration(milliseconds: 300)),
    );
  }

}