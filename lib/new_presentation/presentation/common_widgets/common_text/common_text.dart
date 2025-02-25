import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';

Text buildText(String text, Color color, double fontSize, FontWeight fontWeight,
    TextAlign textAlign, TextOverflow overflow) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    style: SmartTaskFonts.medium().copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}
