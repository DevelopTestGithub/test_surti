import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/cart_api.dart';
import 'package:surtiSP/api/purchase_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/order_extended.dart';
import 'package:surtiSP/models/order_item.dart';
import 'package:surtiSP/models/purchase_send.dart';
import 'package:surtiSP/models/user_status.dart';
import 'package:surtiSP/models/cart_product.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/models/shoping_cart_group.dart';
import 'package:surtiSP/settings.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/money/discount_controller.dart';
import 'package:surtiSP/util/transitions/open_app.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/util/view/size.dart';
import 'package:surtiSP/view/common/button_main.dart';
import 'package:surtiSP/view/common/price_tag.dart';
import 'package:surtiSP/view/common/toasts.dart';
import 'package:surtiSP/view/loadding/cart_loading.dart';
import 'package:surtiSP/view/pages/delivery_home_page.dart';
import 'package:surtiSP/view/pages/product_page.dart';
import 'package:surtiSP/view/pages/vendor_data_page.dart';
import 'package:surtiSP/wrappers/connection.dart';
import 'package:transparent_image/transparent_image.dart';

import '../s_screen.dart';

class Cart extends StatefulWidget {
  final SScreen prevPage;
  List<CartProduct> productGroup;
  DeliveryEstimatedTimeType deliveryTimeType;
  BoolCallBack refreshCartCallback;
  VoidCallback closeCart;

  Cart({this.prevPage, this.refreshCartCallback}) {
    productGroup = List<CartProduct>();
  }

  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isLoading = false;
  bool isDeletingItem = false;
  bool isClearingCart = false;
  bool isCheckingCartActive = false;
  bool isBuying = false;
  UserStatus cartActive;
  _CartState();

  @override
  void initState() {
    loadCart();
    super.initState();
  }

  static const double PRODUCT_HEIGHT = 60;

  @override
  Widget build(BuildContext context) {
    double price = 0;
    double moneyLeft = UserController.me.money - price;
    String estimatedDeliveryTime = '';

    switch (widget.deliveryTimeType) {
      case DeliveryEstimatedTimeType.TODAY:
        estimatedDeliveryTime = T.ESTIMATED_TIME_TODAY; //To texts
        break;
      case DeliveryEstimatedTimeType.TOMORROW:
        estimatedDeliveryTime = T.ESTIMATED_TIME_TODAY; //To texts
        break;
    }

    int cacheSize = UserController.cart.cartList.length;
    List<Widget> productList = List<Widget>();

    Widget _deleteProduct(int _index) {
      return isDeletingItem
          ? Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(
                height: 10.0,
                width: 10.0,
                child: CartLoading(type: CartLoadingType.PRODUCTS),
              ),
            )
          : IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                safeSetState(
                  () {
                    isDeletingItem = true;
                  },
                );

                CartDeleteProduct cartDelete = CartDeleteProduct(
                  UserController.cart.cartList[_index].id,
                );
                bool productDeleted =
                    await CartApi.deleteProduct(cartDelete, context);

                if (productDeleted) {
                  safeSetState(
                    () {
                      UserController.cart.cartList.removeAt(_index);
                      if (UserController.cart.cartList.length == 0) {
                        widget.refreshCartCallback(true);
                      } else {
                        widget.refreshCartCallback(false);
                      }
                      isDeletingItem = false;
                    },
                  );
                }
              },
            );
    }

    Widget products2Show(int _index) {
      Product product = UserController.cart.cartList[_index].product;
      print('${UserController.cart.cartList[_index].id}');

      double currentPrice = DiscountController(
        UserController.cart.cartList[_index].product,
        UserController.cart.cartList[_index].quantity,
      ).getDiscountedPrice();

      price += currentPrice;

      var length =
          UserController.cart.cartList[_index].product.discountIds.length;

      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print(
                  'Editing: ${UserController.cart.cartList[_index].product.name}');
              Navigator.of(context).push(
                PageTransition(
                    curve: Curves.easeOutCirc,
                    type: PageTransitionType.slideLeft,
                    child: ProductPage(
                      UserController.cart.cartList[_index].product,
                      (String) {},
                      ProductAction.EDIT,
                      refresh: () {
                        safeSetState(() {});
                      },
                    ),
                    duration: const Duration(milliseconds: 200)),
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5.0),
                    height: MyApp.screenHeight / 10,
                    width: MyApp.screenWidth / 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: product.images[0].src,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  0 == length
                      ? Container(
                          width: 0,
                          height: 0,
                        )
                      : Text(
                          'Descontado',
                          style: TextStyle(color: Colors.red),
                        ),
                ],
              ),
              title: Text(product.name),
              subtitle: Text("\$${DiscountController(
                    UserController.cart.cartList[_index].product,
                    1,
                  ).getDiscountedPrice().toStringAsFixed(2)}" +
                  ' X ' +
                  UserController.cart.cartList[_index].quantity.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "\$${currentPrice.toStringAsFixed(2)}",
                  ),
                  _deleteProduct(_index),
                ],
              ),
            ),
          ),
          Divider(),
        ],
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
          child: CartLoading(
            type: CartLoadingType.GENERAL,
          ),
        ),
        title: CartLoading(
          type: CartLoadingType.STATUS,
        ),
        subtitle: CartLoading(
          type: CartLoadingType.STATUS,
        ),
        trailing: Container(
            width: 10.0,
            child: CartLoading(
              type: CartLoadingType.STATUS,
            )),
      );
    }

    if (isLoading) {
      for (int i = 0; i < 4; i++) {
        productList.add(_productsLoading());
      }
    } else {
      for (int i = 0; i < cacheSize; i++) {
        productList.add(products2Show(i));
      }
      productList.add(
        Container(
          height: MyApp.screenHeight / 8,
        ),
      );
    }

    Widget clearCart() {
      if (isClearingCart) {
        return CartLoading(type: CartLoadingType.CLEAR);
      } else if (0 != UserController.cart.cartList.length && !isLoading) {
        return Row(
          textDirection: TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: () async {
                safeSetState(() {
                  isClearingCart = true;
                });
                MyApp.disableUI();
                CartClear cartClear = CartClear();
                bool productDeleted = await CartApi.clear(cartClear, context);
                MyApp.enableUI();
                if (productDeleted) {
                  UserController.cart.cartList.length = 0;
                }
                widget.refreshCartCallback(true);
                safeSetState(() {
                  isClearingCart = false;
                  cartActive.isCartActive = false;
                });
              },
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Vaciar carrito', //TODO: to constants
                      style: TextStyle(color: Colors.orange[900]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(
                        Icons.remove_shopping_cart,
                        color: Colors.orange[900],
                      ),
                    ),
                  ]),
            ),
          ],
        );
      } else {
        return Container();
      }
    }

    Widget _loadingCart() {
      return Container(
        child: CartLoading(
          type: CartLoadingType.GENERAL,
        ),
      );
    }

    Widget _inactiveCart() {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(T.CART_EMPTY, style: Style.CART_TITLE),
          ),
          ButtonMainAnim(
            Icons.add_shopping_cart,
            T.CONTINUE_SHOPPING,
            () {
              backButton();
            },
            true,
            sizeSquare:
                SizeSquare(MyApp.screenWidth * .45, MyApp.screenHeight * .098),
          ),
        ],
      );
    }

    Widget _activeCart() {
      return Material(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: Container(),
                    floating: true,
                    actions: <Widget>[
                      Container(),
                    ],
                    expandedHeight: MyApp.screenHeight * 0.15,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Center(
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '${T.DELIVERY_TIME}: ',
                                            style: Style.CART_TITLE,
                                          ),
                                          Text(
                                            estimatedDeliveryTime,
                                            style: Style.CART_DESCRIPTION,
                                          )
                                        ],
                                      ),
                                      PriceTag(price),
                                    ],
                                  ),
                                  Container(
                                    child: clearCart(),
                                    alignment: Alignment.bottomRight,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      productList,
                    ),
                  ),
                ],
              ),
            ),

            isBuying ? LinearProgressIndicator() : Container(),
            Container(
              height: MyApp.screenHeightRaw,
              width: MyApp.screenWidth,
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ButtonMainAnim(
                      Icons.attach_money,
                      T.BUY,
                      () {
                        buy();
                      },
                      true,
                      sizeSquare: SizeSquare(
                          MyApp.screenWidth * .45, MyApp.screenHeight * .098),
                    )),
              ),
            ),
            //MainHeader(backButton),
          ],
        ),
      );
    }

    return Container(
      child: isCheckingCartActive
          ? _loadingCart()
          : !cartActive.isCartActive ? _inactiveCart() : _activeCart(),
    );
  }

  void loadCart() async {
    safeSetState(() {
      isCheckingCartActive = true;
    });
    UserController.cart.cartList;
    //if (!Connection.isConnectedOnline()) {
    cartActive = await CartApi.isCartActive(context);
    //}
    if (!Connection.isConnectedOnline()) {
      cartActive.isActiveOrder = UserController.cart.cartList.length > 0;
    }
    if (cartActive.isCartActive) {
      safeSetState(
        () {
          isCheckingCartActive = false;
          isLoading = true;
        },
      );
      //if (Connection.isConnectedOnline()) {
      MyApp.disableUI();
      ShopingCarts cart = await CartApi.viewCart(context);
      MyApp.enableUI();

      if (cart == null) return;

      widget.productGroup = cart.products;
      widget.deliveryTimeType = cart.type;
      // }

      safeSetState(() {
        isCheckingCartActive = false;
        isLoading = false;
        UserController.cart.cartList = widget.productGroup;
      });
    } else {
      safeSetState(() {
        isCheckingCartActive = false;
        isLoading = false;
      });
    }
  }

  void buy() async {
    if (Global.env.vendorMode) {
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.fadeIn,
          child: VendorDataPage(restartCart: () {
            safeSetState(() {
              cartActive.isCartActive = false;
              loadCart();
            });
          }),
          duration: const Duration(milliseconds: 200)));
      return;
    }

    PurchaseSend purchaseData = PurchaseSend(user: UserController.me);

    MyApp.disableUI();
    safeSetState(() {
      isBuying = true;
    });

    if (Connection.isConnectedOnline()) {
      var purchase = await PurchaseApi.createPurchase(purchaseData, context);
      safeSetState(() {
        isBuying = false;
      });
      MyApp.enableUI();
      if (purchase.purchaseSuccessful) {
        print("purchase: complete");
        Toasts.shortMessage("Su compra se realizó exitosamente");
        UserController.cart.setCartAsInactive();
        backButton(snackBarMessageStarter: T.THANKS_FOR_PURCHASE);
        if (UserController.me.intent) {
          returnToHome(context);
          UserController.client = UserController.me;
          UserController.cart.deleteAllProducts();
          UserController.me.intent = false;
          OpenApp.launch("org.odk.collect.android", "odkagreegate");
        }
        widget.refreshCartCallback(true);
      } else {
        print("purchase: had an issue");
      }
    } else {
      List<OrderItem> orderItems = List<OrderItem>();
      var cart = UserController.cart.cartList;
      int size = cart.length;

      for (int i = 0; i < size; i++) {
        var cartProd = cart[i];
        OrderItem item = OrderItem(
            id: cartProd.id,
            item: cartProd.product,
            quantity: cartProd.quantity,
            priceNoTax: cartProd.product.price,
            priceWithTax: cartProd.product.price);
        orderItems.add(item);
      }

      OrderExtended order = OrderExtended(
          items: orderItems, id: int.parse(UserController.client.currentId));
          // - 
      Toasts.shortMessage("Compra Offline efectuada, pero no guardada para sync");
    }
  }

  void returnToHome(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            curve: Curves.easeOutCirc,
            type: PageTransitionType.slideLeft,
            //child: OrderPage(),
            child: Home(),
            duration: const Duration(milliseconds: 200)
        ),
            (Route<dynamic> route) => false
    );
  }

  void backButton({String snackBarMessageStarter = ""}) {
    SScreen prevScreen = widget.prevPage;
    prevScreen = widget.prevPage;
    prevScreen.setOpeningMessage(
        snackBarOpeningMessage: snackBarMessageStarter);
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.fadeIn,
        child: widget.prevPage,
        duration: const Duration(milliseconds: 200)));
  }

  void safeSetState(VoidCallback safeState) {
    if (mounted)
      setState(() {
        safeState();
      });
  }
}
