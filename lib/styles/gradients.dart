import 'package:flutter/material.dart';

class Gradients {
  static const BoxDecoration
      //
      transparentUp = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.black26,
        Colors.transparent,
      ],
    ),
  ),
      transparentSideLeftToRight = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.black26,
        Colors.transparent,
      ],
    ),
  ),
      transparentSideRightToLeft = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        Colors.black26,
        Colors.transparent,
      ],
    ),
  )
      ;

  static BoxDecoration leftToRight(double alpha, GradientDir direction) {
    switch (direction) {
      case GradientDir.LEFT:
        return BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black.withAlpha((alpha * 255).toInt()),
            Colors.transparent,
          ],
        ));
        break;
      case GradientDir.RIGHT:
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Colors.black.withAlpha((alpha * 255).toInt()),
              Colors.transparent,
            ],
          ),
        );
        break;
    }
  }
}

enum GradientDir { RIGHT, LEFT }
