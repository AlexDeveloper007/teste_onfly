
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';

class SnackbarUtil {
  static showText(
    String text, {
    FontWeight? fontWeight,
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
    double? fontSize,
  }) {
    snackBarPlus.showText('$text',
        backgroundColor: backgroundColor ?? ColorsUtil.PRIMARY_COLOR, textColor: textColor ?? Colors.white, fontWeight: fontWeight ?? FontWeight.w500, fontSize: fontSize ?? 16, duration: duration);
  }

  static snackPadrao(String text, {Duration? duration}) {
    snackBarPlus.showText('$text', backgroundColor: ColorsUtil.PRIMARY_COLOR, textColor: Colors.white, fontWeight: FontWeight.w500, fontSize: 16, duration: duration);
  }

  static snackSucesso(String text) {
    snackBarPlus.show(
        backgroundColor: ColorsUtil.SUCESS_COLOR,
        child: GlobalTextWidget(
          text,
          color: Colors.white,
          textAlign: TextAlign.center,
        ));
  }

  static snackError(String text) {
    int iLastBreakLine = text.lastIndexOf('\n');
    text = iLastBreakLine > -1 && iLastBreakLine == (text.length - 1) ? text.substring(0, iLastBreakLine) : text;
    snackBarPlus.show(
        backgroundColor: Colors.red,
        child: GlobalTextWidget(
          text,
          color: Colors.white,
          textAlign: TextAlign.center,
        ));
  }
}
