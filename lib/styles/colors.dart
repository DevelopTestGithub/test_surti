import 'package:flutter/material.dart';

class C {
  static const Color

      // Pallette
      BACKGROUND = Colors.white,
      PRIMARY = Colors.orange,
      DISABLED_BUTTON = Colors.grey,
      ACTIVE = Colors.red,
      
      NONE = Colors.transparent,

      //UI
      //Text
      DARK_COLOR_BG_TXT = Colors.white,
      LIGHT_COLOR_BG_TXT = PRIMARY,
      REGULAR_BUTTON_TEXT = DARK_COLOR_BG_TXT,
      REGULAR_BUTTON_TEXT_PRESS = DARK_COLOR_BG_TXT,
      REGULAR_BUTTON_TEXT_DISABLED = DARK_COLOR_BG_TXT,
      SIMPLE_BUTTON_TEXT = PRIMARY,
      SIMPLE_BUTTON_TEXT_PRESS = ACTIVE,
      SIMPLE_BUTTON_TEXT_DISABLED = DISABLED_BUTTON,


      DEEP_SEA_BLUE = const Color(0xFF005B7F),
      DEEP_SEA_BLUE_T = const Color(0x00005B7F),
      DARK_SKY_BLUE = const Color(0xff4a90e2),

      WHITE = const Color(0xFFD8D8D8);

  static const ButtonStyle
      //
      REGULAR = ButtonStyle(
          normal: ButtonStyleColors(PRIMARY, REGULAR_BUTTON_TEXT),
          press: ButtonStyleColors(ACTIVE, REGULAR_BUTTON_TEXT_PRESS),
          disabled:
              ButtonStyleColors(DISABLED_BUTTON, REGULAR_BUTTON_TEXT_DISABLED)),
      //
      SIMPLE = ButtonStyle(
          normal: ButtonStyleColors(NONE, SIMPLE_BUTTON_TEXT),
          press: ButtonStyleColors(NONE, SIMPLE_BUTTON_TEXT_PRESS),
          disabled: ButtonStyleColors(NONE, SIMPLE_BUTTON_TEXT_DISABLED))
      //
      ;
}

class ButtonStyle {
  final ButtonStyleColors normal, press, disabled;
  const ButtonStyle({this.normal, this.press, this.disabled});
}

class ButtonStyleColors {
  final Color bg, text;
  const ButtonStyleColors(this.bg, this.text);
}
