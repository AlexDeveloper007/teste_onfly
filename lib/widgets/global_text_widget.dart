import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';

class GlobalTextWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final String? fontFamily;
  final TextDecoration? textDecoration;
  final TextDirection? textDirection;

  const GlobalTextWidget(this.text,
      {Key? key,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.padding,
      this.onPressed,
      this.width,
      this.height,
      this.margin,
      this.maxLines,
      this.textOverflow,
      this.fontFamily,
      this.textDecoration,
      this.textDirection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextPlus(
      '$text',
      width: width,
      height: height,
      fontWeight: fontWeight ?? FontWeight.normal,
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      textAlign: textAlign ?? TextAlign.left,
      fontSize: 14,
      color: color ?? ColorsUtil.DARK_COLOR,
      //fontFamily: fontFamily,
      maxLines: maxLines,
      textOverflow: textOverflow,
      onTap: onPressed,
      textDirection: textDirection ?? TextDirection.ltr,
      textDecorationPlus: TextDecorationPlus(textDecoration: textDecoration ?? TextDecoration.none, color: ColorsUtil.PRIMARY_COLOR),
    );
  }
}
