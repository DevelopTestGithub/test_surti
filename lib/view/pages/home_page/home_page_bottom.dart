import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/styles/sp/sp_style.dart';
import 'package:surtiSP/util/view/size.dart';
import 'package:surtiSP/view/common/button_main.dart';
import 'package:surtiSP/view/common/carousel.dart';
import 'package:surtiSP/view/pages/claro_page.dart';
import 'package:surtiSP/view/pages/home_page.dart';
import 'package:surtiSP/view/pages/home_page/top_items.dart';
import 'package:surtiSP/view/pages/product_list.dart';
import 'package:surtiSP/util/user_Controller.dart';

class HomePageBottom extends StatelessWidget {
  
  bool offlineMode;

  final VoidCallback openInfo, openProfile;
  final bool isOrdersActive;
  bool isLoading;
  //FeaturedGroup discounts;
  List<CarouselData> promotions2Show;

  HomePageBottom({
    @required this.openInfo,
    @required this.openProfile,
    @required this.offlineMode,
    this.isOrdersActive = false,
    this.isLoading,
    this.promotions2Show,
  });

  @override
  Widget build(BuildContext context) {

    double left, right;
    var widthScreen = MyApp.screenWidth * .6;
    var promotionsRad = BorderRadius.all(Radius.circular(18));
    var miniBtnSize = SizeSquare(MyApp.screenWidth * .2, MyApp.screenHeight * .08);
    var contentWidth = MyApp.screenWidth * .8;
    var easing = Curves.easeInOut;

    left = 0;
    right = 0;

    return AnimatedPositioned(
      duration: HomePage.duration,
      curve: easing,
      top: 0,
      bottom: 0,
      left: left,
      right: right,
      child: Material(
        animationDuration: HomePage.duration,
        color: Colors.white,
        child: Stack(
          children: [

            TopItems(
              profileButton: openProfile,
              infoButton: openInfo,
              isOrderActive: isOrdersActive,
            ),

            Container(
              width: MyApp.screenWidth,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MyApp.screenHeight * .01,
                  ),

                  /*
                  0 == promotions2Show.length ?
                  ClipRRect(
                    borderRadius: promotionsRad,
                    child: Center(
                      child: FeaLoading(type: FeaLoadingType.LINEAR,),
                    )
                  ) :
                  ClipRRect(
                    borderRadius: promotionsRad,
                    child: Carousel(
                      data2Show: promotions2Show,
                      visualIndication: FeaLoading(type: FeaLoadingType.FEATURED,),
                      ),
                    ),
*/
                  /*
                  TODO: Unlock features
                  Container(
                    width: widthScreen,
                    height: MyApp.screenHeight * .05,
                    color: Colors.teal.withAlpha(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MiniButton(
                        () {},
                        sizeSquare: miniBtnSize,
                      ),
                      MiniButton(
                        () {},
                        sizeSquare: miniBtnSize,
                      ),
                      MiniButton(
                        () {},
                        sizeSquare: miniBtnSize,
                      ),
                    ],
                  ),
                  */

                  Column(
                    children: <Widget>[
                      Text(
                        UserController.client.name,
                        style: Style.MEDIUM_BLUE,
                      ),
                      Text(
                        UserController.client.ptCode,
                        style: Style.MEDIUM_BLUE,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .01,
                  ),
                  ButtonMainAnim(
                    FontAwesomeIcons.carrot,
                    T.SEE_VEGGIES,
                    () {
                      UserController.me.currentId = UserController.me.vegetablesId;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductList(offlineMode:offlineMode);
                          },
                        ),
                      );
                    },
                    true,
                    sizeSquare:
                        SizeSquare(contentWidth, MyApp.screenHeight * .098),
                  ),
                
                    SizedBox(
                    height: MyApp.screenHeight * .01,
                  ),
                  InkWell(
                    onTap: () {
                      UserController.me.currentId =
                          UserController.me.vegetablesId;
                      Navigator.of(context).push(
                        PageTransition(
                            curve: Curves.easeOutCirc,
                            type: PageTransitionType.slideInUp,
                            child: ClaroPage(),
                            duration: const Duration(milliseconds: 200)),
                      );
                    },
                    child: Container(
                      child: Text(
                        "Recarga Celular",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Color.fromARGB(255, 210, 1, 1),
                        border: Border.all(width: 2, color: Colors.white),
                      ),
                      width: MyApp.screenWidth * .6,
                      height: 52,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}