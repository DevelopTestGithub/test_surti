import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/models/consts/texts_es.dart';
import 'package:surtiSP/view/pages/help_page.dart';
import 'package:surtiSP/view/pages/home_page.dart';
import 'package:surtiSP/view/pages/order_list_page.dart';
import 'package:surtiSP/view/pages/product_list.dart';
import 'package:surtiSP/util/user_Controller.dart';

class InfoPage extends StatelessWidget {
  static const PROPORTIONAL_SIZE = 0.7;

  final bool open;
  final VoidCallback closePage;

  InfoPage(this.open, {this.closePage});

  @override
  Widget build(BuildContext context) {
    double width = (1 - PROPORTIONAL_SIZE) * MyApp.screenWidth;
    double reversewidth = PROPORTIONAL_SIZE * MyApp.screenWidth;
    double left = 0, right = width;
    if (!open) {
      left = -reversewidth;
      right = MyApp.screenWidth;
    }
    return AnimatedPositioned(
      duration: HomePage.duration,
      curve: Curves.easeInOut,
      top: 0,
      bottom: 0,
      left: left,
      right: right,
      child: Container(
        color: Colors.blue,
        width: width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Container(
                height: 10,
                width: 20,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      print("ss");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MyApp.screenWidth * .11,
                        ),
                        InkWell(
                          onTap: () {
                            closePage();
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Icon(Icons.arrow_forward_ios,
                                  size: 30, color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .07,
                  ),

                  //!! TODO: TO MODELS
                  // TODO: standarize buttons

                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        PageTransition(
                            curve: Curves.easeOutCirc,
                            type: PageTransitionType.slideLeft,
                            //child: OrderPage(),
                            child: OrderListPage(),
                            duration: const Duration(milliseconds: 200)),
                      );
                    },
                    child: Text(
                      T.MY_PAYMENT,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .1,
                  ),
                  InkWell(
                    onTap: () {
                      UserController.me.currentId = UserController.me.promosId;
                      Navigator.of(context).pushReplacement(
                        PageTransition(
                            curve: Curves.easeOutCirc,
                            type: PageTransitionType.slideLeft,
                            //child: OrderPage(),
                            child: ProductList(),
                            duration: const Duration(milliseconds: 200)),
                      );
                    },
                    child: Text(
                      T.PROMOS,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .1,
                  ),
                  Text(
                    T.PROMOS,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .09,
                  ),
                  Container(
                    width: MyApp.screenWidth * .4,
                    height: 2,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: MyApp.screenHeight * .04,
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        PageTransition(
                            curve: Curves.easeOutCirc,
                            type: PageTransitionType.slideLeft,
                            //child: OrderPage(),
                            child: HelpPage(),
                            duration: const Duration(milliseconds: 200)),
                      );
                    },
                    child:

                      Row(
                        children: [
                          Icon(Icons.people),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            T.HELP,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )
                        ],
                      ),
                  ),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
