//

//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/api/product_api.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/featured_group.dart';
import 'package:surtiSP/models/product.dart';
import 'package:surtiSP/styles/gradients.dart';
import 'package:surtiSP/util/transitions/getIntent.dart';
import 'package:surtiSP/util/user/cart_data.dart';
import 'package:surtiSP/util/user_Controller.dart';
import 'package:surtiSP/util/user_Controller.dart' as prefix0;
import 'package:surtiSP/view/common/carousel.dart';
import 'package:surtiSP/view/pages/cart_page.dart';
import 'package:surtiSP/view/pages/delivery_home_page.dart';
import 'package:surtiSP/view/pages/home_page/home_page_bottom.dart';
import 'package:surtiSP/view/pages/product_page.dart';
import 'package:surtiSP/view/s_screen.dart';

enum HomePageType { CENTERED, INFO_PAGE, PROFILE_PAGE }

class HomePage extends SScreen {
  static const Duration duration = const Duration(milliseconds: 350);
  final HomePageType startingState;
  bool offlineMode = false;
  HomePage(
      {this.startingState = HomePageType.CENTERED,
      @required offlineMode = false});
  @override
  _HomePageState createState() {
    /* required to check online*/
    initStateParams(updateCartDetection: true);
    return _HomePageState();
  }
}

class _HomePageState extends SurtiState<HomePage>
    with SingleTickerProviderStateMixin {
  HomePageType screenActive = HomePageType.CENTERED;
  HomePageType screeninTheBack = HomePageType.INFO_PAGE;
  AnimationController _controller;
  FeaturedGroup promotions;
  bool isLoading = false;
  List<CarouselData> promotions2Show = [];

  bool isBackButtonActivated = false;
  bool isCollapsed = true;

  @override
  void initState() {
    GetIntent.lockCurrentIntentPTCode();
    screenActive = widget.startingState;

    super.initState();
    screenActive = widget.startingState;
    _controller = AnimationController(vsync: this, duration: HomePage.duration);
  }

  Future<void> initCarouselData() async {
    if (null != promotions.featured) {
      for (int i = 0; i < promotions.featured.length; i++) {
        if (null != promotions.featured[i].imageUrl) {
          Product discountedProduct = await ProductApi.getProductById(
              promotions.featured[i].productId, context);
          CarouselData actualPromotion;
          actualPromotion = CarouselData(
            imageUrl: promotions.featured[i].imageUrl,
            imageAction: () {
              print('Carousel Promotion ${i + 1}: ${discountedProduct.name}');
              Navigator.of(context).push(
                PageTransition(
                    curve: Curves.easeOutCirc,
                    type: PageTransitionType.slideLeft,
                    child: ProductPage(
                        discountedProduct, (String) {}, ProductAction.ADD),
                    duration: const Duration(milliseconds: 200)),
              );
            },
          );
          promotions2Show.add(actualPromotion);
        }
      }
    }
  }

  _closeApp() {
    print('Saliendo de la aplicación');
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    bool isInfoScreenOpen = false;
    bool isProfileScreenOpen = false;

    switch (screenActive) {
      case HomePageType.INFO_PAGE:
        isInfoScreenOpen = true;
        break;
      case HomePageType.PROFILE_PAGE:
        isProfileScreenOpen = true;
        break;
      case HomePageType.CENTERED:
      default:
        isInfoScreenOpen = false;
        isProfileScreenOpen = false;
        break;
    }

    return buildExternal(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      nativeAndroidButtonCallback: () {
        UserController.client = UserController.me;
        UserController.cart.deleteAllProducts();
        UserController.me.intent = false;
        Navigator.of(context).pop(
          PageTransition(
            curve: Curves.easeOutCirc,
            type: PageTransitionType.slideLeft,
            child: Home(),
            duration: const Duration(milliseconds: 200),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          HomePageBottom(
            offlineMode: widget.offlineMode,
            isOrdersActive: super.isOrderActive,
            openInfo: () {
              super.widget.openInfoDrawer();
            },
            openProfile: () {
              print("what");
              super.widget.openCartDrawer();
            },
            isLoading: this.isLoading,
            promotions2Show: this.promotions2Show,
          ),
        ],
      ),
    );
  }

  void openInfoScreen() {
    setState(() {
      if (screenActive == HomePageType.CENTERED) {
        screenActive = HomePageType.INFO_PAGE;
        screeninTheBack = HomePageType.INFO_PAGE;
        isCollapsed = true;
      } else {
        screenActive = HomePageType.CENTERED;
        isCollapsed = false;
      }
    });
  }

  void openProfileScreen() {
    setState(() {
      if (screenActive == HomePageType.CENTERED) {
        screenActive = HomePageType.PROFILE_PAGE;
        screeninTheBack = HomePageType.PROFILE_PAGE;
        isCollapsed = true;
      } else {
        screenActive = HomePageType.CENTERED;
        isCollapsed = false;
      }
    });
  }

  void openCart() {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.slideInUp,
        child: CartPage(
          prevPage: this.widget,
        ),
        duration: const Duration(
          milliseconds: 400,
        ),
      ),
    );
  }

  void closeAllPages() {
    setState(() {
      screenActive = HomePageType.CENTERED;
      isCollapsed = false;
    });
  }

  Widget GradientScreen(double alpha, double alpha2, GradientDir direction,
      double positionX, bool open) {
    Alignment screenSide;

    double leftMini = 0, rightMini = 0;
    double leftBig = 0, rightBig = 0;

    switch (direction) {
      case GradientDir.LEFT:
        screenSide = Alignment.centerLeft;
        if (open) {
          leftMini = 0 + positionX;
          rightMini = MyApp.screenWidth * .9 - positionX;
          leftBig = 0 + positionX;
          rightBig = 0 - positionX;
        } else {
          leftMini = -MyApp.screenWidth * .1;
          rightMini = MyApp.screenWidth;
          leftBig = -MyApp.screenWidth;
          rightBig = MyApp.screenWidth;
        }
        break;
      case GradientDir.RIGHT:
        screenSide = Alignment.centerRight;
        if (open) {
          leftMini = MyApp.screenWidth * .9 + positionX;
          rightMini = 0 - positionX;
          leftBig = 0 + positionX;
          rightBig = 0 - positionX;
        } else {
          leftMini = MyApp.screenWidth;
          rightMini = -MyApp.screenWidth * .1;
          leftBig = MyApp.screenWidth;
          rightBig = -MyApp.screenWidth;
        }
        break;
    }

    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: HomePage.duration,
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          left: leftMini,
          right: rightMini,
          child: Container(
            decoration: Gradients.leftToRight(alpha2, direction),
          ),
        ),
        AnimatedPositioned(
          duration: HomePage.duration,
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          left: leftBig,
          right: rightBig,
          child: Container(
            decoration: Gradients.leftToRight(alpha, direction),
          ),
        ),
      ],
    );
  }
}
