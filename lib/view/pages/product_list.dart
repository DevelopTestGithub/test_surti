//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/api/product_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/models/product_group.dart';
import 'package:surtiSP/view/common/main_header.dart';
import 'package:surtiSP/view/common/product_veggie_list.dart';
import 'package:surtiSP/view/loadding/product_loading.dart';
import 'package:surtiSP/view/pages/product_page.dart';
import 'package:surtiSP/view/s_screen.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/wrappers/connection.dart';

class ProductList extends SScreen {
  ProductAction action;
  int orderId;
  bool offlineMode;
  VoidCallback update;
  ProductList(
      {this.action, this.orderId, @required this.offlineMode, this.update}) {
    if (update == null) {
      update = () {};
    }
  }

  @override
  _ProductListState createState() {
    /* required to check online*/
    initStateParams(updateCartDetection: true);
    return _ProductListState();
  }
}

class _ProductListState extends SurtiState<ProductList> {
  static const ROWS = 7; //SEARCH_PLACEHOLDER = T.PRODUCT_SEARCH_HINT;

  String _searchText = "";
  bool productsLoaded = false;
  ProductGroup group;
  ScrollController _scrollController = new ScrollController();
  TextEditingController _searchBar;

  @override
  void initState() {
    super.initState();
    loadProduct(!Connection.isConnectedOnline());
    _scrollController.addListener(() {
      var position = _scrollController.position;
      if (position.pixels == position.maxScrollExtent) {
        print("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.width == null) {
      widget.width = MyApp.screenWidth;
    }
    if (widget.height == null) {
      widget.height = MyApp.screenHeightRaw;
    }

    List<Product> renewedProductList = new List<Product>();

    if (_searchText != "") {
      int cachedSize = group.products.length;
      for (int i = 0; i < cachedSize; i++) {
        Product product = group.products[i];
        String starter = product.name.toLowerCase();
        String find = _searchText.toLowerCase();
        bool hasSearchWord = starter.contains(find);
        if (hasSearchWord) {
          renewedProductList.add(product);
        }
      }
    } else {
      if (group != null) {
        renewedProductList = group.products;
      }
    }

    int itemsAmmount = 0;
    if (!productsLoaded) {
      return buildExternal(
        topTextHint: T.PRODUCT_SEARCH_HINT,
        textEditingCallback: (message) {
          safeSetState(() {
            print("MESSAGE $message");
            _searchText = message;
          });
        },
        enableMainHeader: true,
        backgroundColor: Colors.white,
        child: ProductLoading(
          type: PrLoadingType.GENERAL,
        ),
      );
    } else {
      itemsAmmount = renewedProductList.length;
      double itemCount = itemsAmmount / 3;
      int itemsTotal = itemCount.ceil();

      return buildExternal(
        topTextHint: T.PRODUCT_SEARCH_HINT,
        textEditingCallback: (message) {
          safeSetState(() {
            print("MESSAGE $message");
            _searchText = message;
          });
        },
        enableMainHeader: true,
        hideHeaderCartButton: false,
        backgroundColor: Colors.white,
        nativeAndroidButtonCallback: () {
          backButton();
        },
        callbackBackButton: () {
          backButton();
        },
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      height: MainHeader.HEADER_HEIGHT,
                      width: widget.width,
                      color: Colors.white,
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Container(
                        height: widget.height - MainHeader.HEADER_HEIGHT,
                        width: MyApp.screenWidth,
                        color: Colors.white,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: itemsTotal,
                          itemBuilder: (context, index) {
                            Product model1 = renewedProductList[index * 3];
                            Product model2 = null;
                            Product model3 = null;

                            /* There's=*2* */
                            if (index * 3 + 1 < itemsAmmount) {
                              model2 = renewedProductList[index * 3 + 1];
                            }

                            /* There's=*3* */
                            if (index * 3 + 2 < itemsAmmount) {
                              model3 = renewedProductList[index * 3 + 2];
                            }
                            return ProductVeggieList(
                              model1: model1,
                              model2: model2,
                              model3: model3,
                              errorSnackBarCallback: (message) {
                                snackBar(message);
                              },
                              callbackCartButton: () {
                                widget.openCartDrawer();
                                print("CART CALLBACK WWWWW");
                              },
                              refreshCart: () {
                                safeSetState(() {
                                  print(
                                      "REFRESSSSSS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
                                  loadUserStatus();
                                  widget.update();
                                  //updateTheStatus();
                                });
                              },
                              action: widget.action,
                              orderId: widget.orderId,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
  }

  void backButton() {
    if (MyApp.tellMeIfUIIsDisabled()) return;
//    Navigator.of(context).pushReplacement(
////        PageTransition(type: PageTransitionType.fadeIn, child: HomePage()));
    Navigator.pop(context);
  }

  void loadProduct(bool offlineMode) async {
    //offlineMode
    if (offlineMode) {
      MyApp.disableUI();
      group = await ProductApi.getProductGroupOffline(
          UserController.me.currentId, context);
      MyApp.enableUI();
    } else {
      MyApp.disableUI();
      group = await ProductApi.getProductGroup(
          UserController.me.currentId, context);
      MyApp.enableUI();
    }
    if (group == null) {
      backButton();
      return;
    }

    safeSetState(
      () {
        productsLoaded = true;
      },
    );
  }
}
