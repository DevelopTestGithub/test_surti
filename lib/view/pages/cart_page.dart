//
//

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/cart_api.dart';
import 'package:surtiSP/api/purchase_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/purchase_send.dart';
import 'package:surtiSP/models/user_status.dart';
import 'package:surtiSP/models/cart_product.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/models/shoping_cart_group.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/util/view/size.dart';
import 'package:surtiSP/view/common/button_main.dart';
import 'package:surtiSP/view/common/price_tag.dart';
import 'package:surtiSP/view/loadding/cart_loading.dart';
import 'package:surtiSP/view/pages/product_page.dart';
import 'package:surtiSP/view/s_screen.dart';
import 'package:transparent_image/transparent_image.dart';


class CartPage extends SScreen {
  final SScreen prevPage;
  List<CartProduct> productGroup;
  DeliveryEstimatedTimeType deliveryTimeType;

  CartPage({this.prevPage}) {
    productGroup = List<CartProduct>();
  }
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends SurtiState<CartPage> {
  bool isLoading = false;
  bool isDeletingItem = false;
  bool isClearingCart = false;
  bool isCheckingCartActive = false;
  UserStatus cartActive;

  @override
  void initState() {
    loadCart();
    super.initState();
  }

  //TODO: Load cart from server

  static const double PRODUCT_HEIGHT = 60;

  @override
  Widget build(BuildContext context) {
    double price = UserController.cart.getTotalInCart();
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

    Widget _deleteProduct(int _index){
      return 
        isDeletingItem ?
        Padding(
          padding: EdgeInsets.all(15),
          child:
            SizedBox(
              height: 10.0,
              width: 10.0,
              child: CartLoading(type: CartLoadingType.PRODUCTS),
            )
        ) :
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            setState(() {
              isDeletingItem = true;
            });

            CartDeleteProduct cartDelete = CartDeleteProduct(
              UserController.cart.cartList[_index].id,
            );



            bool productDeleted =
            await CartApi.deleteProduct(cartDelete, context);//IMPORTANT: TODO: MAKE OFFLI



            if (productDeleted) {
              print(
                  'Product deleted: ${UserController.cart.cartList[_index].product.name}');
              setState(() {
                UserController.cart.cartList.removeAt(_index);
                isDeletingItem = false;
              });
            }
          },
        );
    }

    Widget products2Show (int _index) {

      Product product = UserController.cart.cartList[_index].product;
      print('${UserController.cart.cartList[_index].id}');

      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: (){

              print('Editing: ${UserController.cart.cartList[_index].product.name}');
              Navigator.of(context).push(
                PageTransition(
                    curve: Curves.easeOutCirc,
                    type: PageTransitionType.slideLeft,
                    child: ProductPage(
                        UserController.cart.cartList[_index].product,
                            (string){},
                        ProductAction.EDIT, openCart: (){ },
                    ),
                    duration: const Duration(milliseconds: 200)),
              );

            },

            child: ListTile(
              leading: Container(
                height: MyApp.screenHeight / 8,
                width: MyApp.screenWidth / 4,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: product.images[0].src,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(
                  product.name
              ),
              subtitle: Text(
                product.price.toStringAsFixed(2) + ' X ' +
                    UserController.cart.cartList[_index].quantity.toString()
              ),
              trailing:
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      (UserController.cart.cartList[_index].quantity *
                        product.price
                      ).toStringAsFixed(2),
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

    Widget _productsLoading(){
      return ListTile(
        leading: Container(
          height: MyApp.screenHeight / 8,
          width: MyApp.screenWidth / 4,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: CartLoading(type: CartLoadingType.GENERAL,),
        ),

        title: CartLoading(type: CartLoadingType.STATUS,),

        subtitle: CartLoading(type: CartLoadingType.STATUS,),
        trailing: Container(
            width: 10.0,
            child: CartLoading(type: CartLoadingType.STATUS,)
        ),
      );

    }

    if (isLoading) {
      for (int i = 0; i < 4; i++){
        productList.add(_productsLoading());
      }
    } else {
      for (int i = 0; i < cacheSize; i++) {
        productList.add(products2Show(i));
      }
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
                setState(() {
                  isClearingCart = true;
                });
                MyApp.disableUI();
                CartClear cartClear = CartClear();


                bool productDeleted = await CartApi.clear(cartClear, context); //IMPORTANT: TODO: MAKE OFFLI
                
                
                
                MyApp.enableUI();
                if (productDeleted) {
                  UserController.cart.cartList.length = 0;
                }
                setState(() {
                  isClearingCart = false;
                });
              },
              child: Opacity(
                opacity: 0.8,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Vaciar carrito',
                        style: TextStyle(color: Colors.red),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.remove_shopping_cart,
                          color: Colors.red,
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    }

    double scrollViewHeight =
        MyApp.screenHeightRaw + cacheSize * PRODUCT_HEIGHT;

    Widget _loadingCart(){
      return Container(
        child: CartLoading(type: CartLoadingType.GENERAL,),
      );
    }

    Widget _inactiveCart(){
      return
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    T.CART_EMPTY,
                    style: Style.CART_TITLE
                ),
              ),

              ButtonMainAnim(
                Icons.add_shopping_cart,
                T.CONTINUE_SHOPPING,
                    () {
                  backButton();
                },
                true,
                sizeSquare: SizeSquare(
                    MyApp.screenWidth * .45, MyApp.screenHeight * .098),
              ),
            ],
          );
    }

    Widget _activeCart(){
      return
        Material(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    height: scrollViewHeight,
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: MyApp.screenHeight * .1,
                        ),
                        Container(
                          width: 200,
                          height: 50,
                        ),

                        Container(
                          child: clearCart(),
                        ),

                        Column(
                          children: productList,
                        ),

                        SizedBox(
                          height: MyApp.screenHeight * .1,
                        ),
                        Text(
                          //TODO: text
                          'Costo total',
                          style: Style.CART_TITLE,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            PriceTag(price),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${T.DELIVERY_TIME}: ',
                                style: Style.CART_TITLE,
                              ) ,
                              Text(
                                estimatedDeliveryTime,
                                style: Style.CART_DESCRIPTION,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MyApp.screenHeightRaw,
                width: MyApp.screenWidth,
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonMainAnim(
                          Icons.add_shopping_cart,
                          T.CONTINUE_SHOPPING,
                              () {
                            backButton();
                          },
                          true,
                          sizeSquare: SizeSquare(
                              MyApp.screenWidth * .45, MyApp.screenHeight * .098),
                        ),
                        ButtonMainAnim(
                          Icons.attach_money,
                          T.BUY,
                              () {
                            buy();
                          },
                          true,
                          sizeSquare: SizeSquare(
                              MyApp.screenWidth * .45, MyApp.screenHeight * .098),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }

    return buildExternal(
      backgroundColor: Colors.white,
      updateCartDetection: false,
      forceCartButtonInnactive: true,
      nativeAndroidButtonCallback: (){
         backButton();
      },
      callbackBackButton: () {
        backButton();
      },
      child: isCheckingCartActive ?

        _loadingCart() :

        !cartActive.isCartActive ?
          _inactiveCart() :
          _activeCart(),

    );
  }

  void loadCart() async {
    setState(() {
      isCheckingCartActive = true;
    });


//
    cartActive = await CartApi.isCartActive(context);//IMPORTANT: TODO: MAKE OFFLI
//



    if ( cartActive.isCartActive ){

      setState(() {
        isCheckingCartActive = false;
        isLoading = true;
      });

      MyApp.disableUI();



//
      ShopingCarts cart = await CartApi.viewCart(context); //IMPORTANT: TODO: MAKE OFFLI
      //
      
      
      
      
      MyApp.enableUI();

      if (cart == null) return;

      widget.productGroup = cart.products;
      widget.deliveryTimeType = cart.type;
    }

    setState(() {
      isCheckingCartActive = false;
      isLoading = false;
      UserController.cart.cartList = widget.productGroup;
    });
  }

  void buy() async {
    PurchaseSend purchaseData = PurchaseSend(user: UserController.me);

    MyApp.disableUI();
//

    var purchase = await PurchaseApi.createPurchase(purchaseData, context); //IMPORTANT: TODO: MAKE OFFLI
  
  //
    MyApp.enableUI();

    if (purchase.purchaseSuccessful) {
      print("purchase: complete");
      UserController.cart.setCartAsInactive();

      backButton(snackBarMessageStarter: T.THANKS_FOR_PURCHASE);

    } else {
      print("purchase: had an issue");
      snackBar(T.PURCHASE_ERROR);
    }
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
}
