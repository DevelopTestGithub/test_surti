//
//

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:surtiSP/api/cart_api.dart';
import 'package:surtiSP/Models/consts/texts_es.dart';
import 'package:surtiSP/api/order_api.dart';
import 'package:surtiSP/models/cart_product.dart';
import 'package:surtiSP/models/discount.dart';
import 'package:surtiSP/models/editedCartProduct.dart';
import 'package:surtiSP/models/log_api.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/shoping_cart_group.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/http/addresses.dart';
import 'package:surtiSP/util/persistency/logs_persistency.dart';
import 'package:surtiSP/util/typeDef/call_backs.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/view/common/bottom_button.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/plus_and_minus.dart';
import 'package:surtiSP/view/common/price_tag.dart';
import 'package:surtiSP/view/common/spinner.dart';
import 'package:surtiSP/view/loadding/product_loading.dart';




enum ApiState {
  INNACTIVE,
  LOADED,
}
enum ProductAction {
  ADD,
  EDIT,
  EDIT_ITEM_ODER,
  ADD_ITEM_ORDER,
}

class ProductPage extends StatefulWidget {
  Product model = new Product();
  MessageCallback snackBarMessageCallback;
  bool enabledToCart = true;
  ProductAction actionInCart;
  final int orderID;
  VoidCallback refresh;
  VoidCallback openCart;

  ProductPage(this.model, this.snackBarMessageCallback, this.actionInCart,
      {this.refresh, @required this.openCart, this.orderID}) {
    if (this.refresh == null) {
      this.refresh = () {};
    }
    if (openCart == null) {
      this.openCart = () {};
    }
    if (null == this.actionInCart) {
      this.actionInCart = ProductAction.ADD;
    }
  }
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int currentAmountOfItems = 1;
  String url = "";
  bool isLoading = false;
  bool isEditing = false;
  List<Discount> productDiscounts = [];
  List<double> currentDiscounts = [];
  CartProduct currentProduct;

  bool processedDiscount = false;
  double currentPrice = 0;
  double currentDiscount = 0;
  int _pructIndex;

  @override
  void initState() {
    switch (widget.actionInCart) {
      case ProductAction.ADD:
        currentAmountOfItems = widget.model.numberForCart;
        break;
      case ProductAction.EDIT:
        for (int i = 0; i < UserController.cart.cartList.length; i++) {
          if (widget.model.id == UserController.cart.cartList[i].product.id) {
            currentProduct = UserController.cart.cartList[i];
            _pructIndex = i;
            i = UserController.cart.cartList.length;
          }
        }
        currentAmountOfItems = currentProduct.quantity;
        break;
      case ProductAction.EDIT_ITEM_ODER:
        currentAmountOfItems = widget.model.ammount;

        currentProduct = CartProduct(
            product: widget.model,
            quantity: widget.model.ammount,
            id: widget.model.id);
        break;
      case ProductAction.ADD_ITEM_ORDER:
        currentAmountOfItems = 1;
        break;
    }

    if (null != widget.model.discountIds) {
      _getDiscounts();
    }

    super.initState();
  }

  void updateDiscount(bool _isInitializing) {
    double _totalDiscount = 0;
    for (int i = 0; i < this.productDiscounts.length; i++) {
      if (this.productDiscounts[i].isPercentage) {
        if (_isInitializing) {
          this.currentDiscounts.add(
              (widget.model.price * currentAmountOfItems) *
                  ((this.productDiscounts[i].discountPercentage) / 100));
        } else {
          this.currentDiscounts[i] =
              (widget.model.price * currentAmountOfItems) *
                  ((this.productDiscounts[i].discountPercentage) / 100);
        }
      } else {
        if (_isInitializing) {
          this.currentDiscounts.add(this.productDiscounts[i].discountAmount);
        } else {
          this.currentDiscounts[i] = this.productDiscounts[i].discountAmount;
        }
      }
      print('Percentage discount: ${this.currentDiscounts[i]}');

      _totalDiscount += this.currentDiscounts[i];
      this.currentPrice =
          (widget.model.price * this.currentAmountOfItems) - _totalDiscount;
      this.currentPrice = this.currentPrice < 0 ? 0 : this.currentPrice;
      processedDiscount = true;
    }
  }

  void _getDiscounts() {
    setState(() {
      isLoading = true;
    });

    UserController.discounts.grabDiscountListFromIds(widget.model.discountIds,
        (discounts, success) {
      productDiscounts = new List<Discount>();
      List<Discount> discountList = discounts;
      var discountsLength = discountList.length;

      for (int i = 0; i < discountsLength; i++) {
        Discount discount = discountList[i];
        productDiscounts.add(discount);
      }

      updateDiscount(true);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.model.images[0].src;
    const imageRadius = 10.0;
    const productRadius = BorderRadius.all(Radius.circular(imageRadius));

    Widget imageContent = CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => new Spinner(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      httpHeaders: {HttpHeaders.authorizationHeader: HTTP.getHeader()},
      fit: BoxFit.fill,
    );

    String _getDiscountName(Discount _actualDiscount) {
      String _discountName;
      //todo: add more cases
      if ("'20% order total' discount" == _actualDiscount.name) {
        _discountName = T.DISCOUNT_TYPE_20_TOTAL;
      } else if ("Flat 10%" == _actualDiscount.name) {
        _discountName = T.DISCOUNT_TYPE_10_PERCENT;
      } else if ("Sample discount with coupon code" == _actualDiscount.name) {
        _discountName = T.DISCOUNT_TYPE_COUPON;
      } else {
        _discountName = T.DISCOUNT_TYPE_DEFAULT;
      }

      return _discountName;
    }

    Widget _buildTile(BuildContext context, int index) {
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            _getDiscountName(productDiscounts[index]),
            style: Style.PRODUCT_TITLE,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, right: 20),
            child: PriceTag(this.currentDiscounts[index]),
          ),
        ),
      ]);
    }

    Widget discounts() {
      if (0 == widget.model.discountIds.length ||
          null == widget.model.discountIds) {
        return Container();
      } else {
        return Container(
            height: MyApp.screenHeight * 0.3,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(children: [
                Text(
                  T.DISCOUNTS,
                  style: Style.PRODUCT_NAME,
                  textAlign: TextAlign.center,
                ),
                isLoading
                    ? ProductLoading(
                        type: PrLoadingType.FEATURED,
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.model.discountIds.length,
                        itemBuilder: _buildTile),
              ]),
            ));
      }
    }

    // if not processed discount
    if (!processedDiscount) {
      this.currentPrice = widget.model.price * this.currentAmountOfItems;
    }
    var priceTag = Padding(
      padding: EdgeInsets.only(bottom: 20, right: 20),
      child: isLoading
          ? ProductLoading(type: PrLoadingType.PRICE)
          : PriceTag(this.currentPrice),
    );

    var identifier = Padding(
      padding: EdgeInsets.only(
        top: MyApp.screenHeight * .18,
      ),
      child: Container(
        width: MyApp.screenWidth * .75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  borderRadius: productRadius,
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: productRadius,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: MyApp.screenHeight * .24,
                      height: MyApp.screenHeight * .24,
                      child: Stack(
                        children: [
                          Container(
                              alignment: Alignment.center, child: imageContent)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.model.name,
                      style: Style.PRODUCT_NAME,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    priceTag
                  ]),
            ),
          ],
        ),
      ),
    );
    bool enabledToCart;
    if (currentAmountOfItems > 0) {
      enabledToCart = true;
    } else {
      enabledToCart = false;
    }

    Widget _actionButton() {
      Widget actionButton;

      switch (widget.actionInCart) {
        case ProductAction.ADD:
          actionButton = BottomButton(
            text: T.CART_ADD,
            enabled: enabledToCart,
            callback: () {
              print('ProductAction: Add');
              //AQUI

              getInCart(widget.model, currentAmountOfItems);
            },
          );
          break;

        case ProductAction.EDIT:
        case ProductAction.EDIT_ITEM_ODER:
          actionButton = BottomButton(
            text: T.CART_EDIT,
            enabled: enabledToCart,
            callback: () {
              print('ProductAction: Edit');
              editProduct(currentProduct, currentAmountOfItems);
            },
          );
          break;

        case ProductAction.ADD_ITEM_ORDER:
          actionButton = BottomButton(
            text: T.ORDER_ADD_ITEM,
            enabled: enabledToCart,
            callback: () {
              print('ProductAction: Edit');
              editProduct(currentProduct, currentAmountOfItems);
            },
          );
          break;
      }

      return actionButton;
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: () async {
          backButton();
          return false;
        },
        child: Stack(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  identifier,
                  discounts(),
                  /*
                  TODO:
                  !UNLOCK LATER
                  
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.teal),
                    width: MyApp.screenWidth * .75,
                    height: MyApp.screenHeight * .3,
                  ),*/

                  PlusMinus(
                    "",
                    currentAmountOfItems,
                    (count) {
                      setState(() {
                        currentAmountOfItems = count;
                        updateDiscount(false);
                      });
                    },
                    width: MyApp.screenWidth * .7,
                  ),
                  isEditing
                      ? ProductLoading(type: PrLoadingType.EDIT)
                      : Container(),
                  _actionButton(),
                ],
              ),
            ),
            MainHeader(
              backButton,
              cartButton: () {
                backButton();
                widget.openCart();
              },
            ),
          ],
        ),
      ),
    );
  }

  void getInCart(Product product, int amount) async {
    product
        .setAmmountForCart(amount); //!fix remove this, for the time redundant.

    CartPost cartpost = CartPost(product.id.toString(), quantity: amount);

    print("Cart st: ${cartpost.quantity} q = ${cartpost.quantity}");
    backButton();

// AL SERVER
    MyApp.disableUI();
    ShopingCarts cartAddingResponse = await CartApi.addProduct(
        cartpost,
        context,
        CartProduct(product: product, quantity: amount, id: product.id));
    MyApp.enableUI();
    int ammountOfProducts = cartAddingResponse.products.length;
    if (ammountOfProducts < 1) {
      widget.snackBarMessageCallback(T.ERROR_ADDING_TO_CART);
      LogActions logApiModel= LogActions(
        className:"LogApiModel",
        methodName:"getInCart",
        text:T.ERROR_ADDING_TO_CART,
        action:"Error: AddProductToCart",
        user: UserController.client.userId,
        product:product.id.toString(),
        dateTime:DateTime.now().toString(),
      );
      LogsPersistency _logsP = await LogsPersistency();
      await _logsP.init(logApiModel, context);
      var resultado= _logsP.logs();
       return;
    }
    widget.refresh();
    LogActions logApiModel= LogActions(
      className:"LogApiModel",
      methodName:"getInCart",
      text:"Add Product Car",
      action:"AddProductToCart",
      user: UserController.client.userId,
      product:product.id.toString(),
      dateTime:DateTime.now().toString(),
    );
    LogsPersistency _logsP = await LogsPersistency();
    await _logsP.init(logApiModel, context);
    print('${_logsP.logs().toString()}');
    print(logApiModel.toString());
  }


  void editProduct(
      CartProduct currentProduct, int _currentAmountOfItems) async {
    if (MyApp.tellMeIfUIIsDisabled()) return;

    setState(
      () {
        isEditing = true;
      },
    );

    EditedCartProduct cartEditedResponse;

    bool ack;

    MyApp.disableUI();

    switch (widget.actionInCart) {
      case ProductAction.ADD:
        // TODO: Handle this case.
        break;
      case ProductAction.EDIT:
        CartEdit cartEdit = CartEdit(
          currentProduct.id.toString(),
          quantity: currentAmountOfItems,
        );
        cartEditedResponse = await CartApi.editProduct(cartEdit, context);

        if (null != cartEditedResponse) {
          ack = true;
          UserController.cart.cartList[_pructIndex].quantity =
              currentAmountOfItems;
        }

        break;
      case ProductAction.EDIT_ITEM_ODER:
        CartOrderEdit cartedit = CartOrderEdit(
          currentProduct.id.toString(),
          widget.orderID.toString(),
          quantity: currentAmountOfItems,
        );
        cartEditedResponse = await CartApi.editProductOrder(
            cartedit, widget.orderID.toString(), context);

        if (null != cartEditedResponse) {
          ack = true;
        }

        break;
      case ProductAction.ADD_ITEM_ORDER:
        ack = await OrderApi.editProduct(EditProductAction.ADD, widget.orderID,
            widget.model.id, currentAmountOfItems, context);
        break;
    }

//    if (widget.actionInCart == ProductAction.EDIT_ITEM_ODER) {
//
//    } else {
//      CartEdit cartedit = CartEdit(
//        currentProduct.id.toString(),
//        quantity: currentAmountOfItems,
//      );
//      cartEditedResponse = await CartApi.editProduct(cartedit, context);
//    }

    MyApp.enableUI();

    setState(() {
      isEditing = false;
    });

    if (ack) {
      widget.refresh();
      backButton();
    }
//    if (null != cartEditedResponse || ack) {
//      if (widget.actionInCart == ProductAction.EDIT_ITEM_ODER) {
//      } else {
//        UserController.cart.cartList[_pructIndex].quantity =
//            currentAmountOfItems;
//      }
//      widget.refresh();
//      backButton();
//    } else {
//      //TODO: Handle error.
//      print('Error while editing product.');
//    }
  }

  void backButton() {
    Navigator.pop(context);
  }
}
