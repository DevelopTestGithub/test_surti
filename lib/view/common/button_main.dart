import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surtiSP/main.dart';
import 'package:surtiSP/styles/colors.dart';
import 'package:surtiSP/styles/style_sheet.dart';
import 'package:surtiSP/util/view/size.dart';

enum ButtonType { REGULAR, SIMPLE }

class ButtonMainAnim extends StatefulWidget {

  IconData icon;
  final String text;
  final VoidCallback press;
  final bool enabled;
  final bool canItBeDisabledViaLoading;
  final SizeSquare sizeSquare;

  ButtonType buttonType;

  ButtonMainAnim(
    this.icon,
    this.text,
    this.press,
    this.enabled, {
    this.buttonType = ButtonType.REGULAR,
    this.canItBeDisabledViaLoading = true,
    this.sizeSquare = const SizeSquare(150, 30, hasData: true),
  });

  @override
  _ButtonMainAnimState createState() => _ButtonMainAnimState();
}

class _ButtonMainAnimState extends State<ButtonMainAnim>
    with TickerProviderStateMixin {
  static const double RADIUS = 10;

  static const double ELEVATION_PRESS = 1;
  static const double ELEVATION_UP = 5;

  double _scale;
  double _elevation;
  AnimationController _controller;
  Color _buttonColor = C.REGULAR.normal.bg;
  Color _textColor = C.REGULAR_BUTTON_TEXT;
  TextStyle _textStyle = Style.REGULAR_BUTTON;

  @override
  void initState() {
    super.initState();
    if (_controller == null) createAnimator();
  }

  void createAnimator() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1),
      lowerBound: 0.0,
      upperBound: 1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _startAnimation();
  }

  void _onTapUp(TapUpDetails details) {
    _reverseAnimation();
  }

  void _startAnimation() {
    _controller.duration = Duration(milliseconds: 1);
    _controller.forward();
  }

  void _reverseAnimation() {
    _controller.duration = Duration(milliseconds: 200);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    var radiusBtn = BorderRadius.all(Radius.circular(RADIUS));

    if (_controller == null) print("FLUTTER $_controller");

    _scale = 1.0 - _controller.value * 0.01;
    if (_controller.value >= _controller.upperBound) {
      // PRESSED
      if (widget.buttonType == ButtonType.REGULAR) {
        _buttonColor = C.REGULAR.press.bg;
        _textColor = C.REGULAR.press.text;
        _textStyle = Style.REGULAR_BUTTON_PRESS;
      } else {
        _buttonColor = C.SIMPLE.press.bg;
        _textColor = C.SIMPLE.press.text;
        _textStyle = Style.SIMPLE_BUTTON_PRESS;
      }
    } else {
      if (widget.buttonType == ButtonType.REGULAR) {
        _buttonColor = C.REGULAR.normal.bg;
        _textColor = C.REGULAR.normal.text;
        _textStyle = Style.REGULAR_BUTTON;
      } else {
        _buttonColor = C.SIMPLE.normal.bg;
        _textColor = C.SIMPLE.normal.text;
        _textStyle = Style.SIMPLE_BUTTON;
      }
    }
    if (widget.buttonType == ButtonType.REGULAR) {
      _elevation = ELEVATION_UP - _controller.value * 5;
    } else {
      _elevation = 0;
    }

    if (!IsEnabled()) {
      if (widget.buttonType == ButtonType.REGULAR) {
        _buttonColor = C.REGULAR.disabled.bg;
        _textColor = C.REGULAR.disabled.text;
        _textStyle = Style.REGULAR_BUTTON_DISABLED;
      } else {
        _buttonColor = C.SIMPLE.disabled.bg;
        _textColor = C.SIMPLE.disabled.text;
        _textStyle = Style.SIMPLE_BUTTON_DISABLED;
      }
    }

    double width = null;
    double height = null;

    if (widget.sizeSquare.hasData) {
      width = widget.sizeSquare.width;
      height = widget.sizeSquare.height;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          _startAnimation();
        },
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () {
          _reverseAnimation();
        },
        onForcePressEnd: (ForcePressDetails) {
          _reverseAnimation();
        },
        child: Transform.scale(
          scale: _scale,
          child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: _buttonColor,
                borderRadius: radiusBtn,
              ),
              child: _animatedButtonUI),
        ),
      ),
    );
  }

  Widget get _animatedButtonUI {
    var radiusBtn = BorderRadius.all(Radius.circular(RADIUS));
    return Material(
      elevation: _elevation,
      color: _buttonColor,
      borderRadius: radiusBtn,
      child: InkWell(
        borderRadius: radiusBtn,
        enableFeedback: IsEnabled(),
        onTap: () {
          if (!IsEnabled()) {
            return;
          }
          _controller.value = 1;
          this.widget.press();
          _reverseAnimation();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: Container(
            alignment: Alignment.center,
            child:
              null != widget.icon ?

                Row(
                  children: <Widget>[
                    Icon(
                      widget.icon,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        widget.text,
                        style: _textStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ):
                Text(
                  widget.text,
                  style: _textStyle,
                  textAlign: TextAlign.center,
                )
          ),
        ),
      ),
    );
  }

  bool IsEnabled() {
    if (widget.canItBeDisabledViaLoading && MyApp.tellMeIfUIIsDisabled()) {
      return false;
    }
    if (!widget.enabled) {
      return false;
    }
    return true;
  }
}
