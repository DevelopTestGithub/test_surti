//
//

import 'package:flutter/material.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/view/common/main_header.dart';

class TopItems extends StatelessWidget {
  final VoidCallback profileButton;
  final VoidCallback infoButton;
  final bool isOrderActive;
  final Color color;

  TopItems({this.profileButton, this.infoButton, this.isOrderActive = false, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyApp.screenWidth,
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            Padding(
              padding: EdgeInsets.only(top: 14, left: 10),
              child: TopButton(
                hasBadge: isOrderActive,
                pressButton: infoButton,
                topBType: TopBType.INFO,
                color: color
              ),
            ),
            //
            Padding(
              padding: EdgeInsets.only(top: 14, right: 10),
              child: TopButton(
                pressButton: profileButton,
                topBType: TopBType.PROFILE,
                color: color
              ),
            ),
            //
          ],
        ),
      ),
    );
  }
}

enum TopBType { INFO, PROFILE, HAMBURGER }

class TopButton extends StatelessWidget {
  static const double BADGE_SIZE = 10;

  final VoidCallback pressButton;
  final bool hasBadge;
  final TopBType topBType;
  final Color color;

  TopButton(
      {this.hasBadge = false, this.topBType, this.pressButton, this.color});
  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (topBType) {
      case TopBType.INFO:
        icon = Icons.info;
        break;
      case TopBType.HAMBURGER:
        icon = Icons.menu;
        break;
      case TopBType.PROFILE:
      default:
        //  icon = Icons.supervised_user_circle;
        //! temp
        icon = Icons.shopping_cart;
        break;
    }

    return InkWell(
      onTap: pressButton,
      splashColor: Colors.transparent,
      child: Container(
        width: 60,
        height: MainHeader.HEADER_HEIGHT,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(right: 3),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Icon(
                icon,
                color: color,
                size: 40,
              ),
              hasBadge
                  ? Container(
                      width: BADGE_SIZE,
                      height: BADGE_SIZE,
                      decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(BADGE_SIZE * .5)),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
