
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';

class GlobalButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final Color? textColor;
  final Color? backgroundColor;
  final BorderPlus? border;
  final bool? enabled;
  final EdgeInsets? margin;
  final double? radius;
  final IconData? icon;
  final ShadowPlus? shadow;
  final EdgeInsets? padding;
  final bool loading;
  final bool isCircle;

  GlobalButtonWidget({Key? key, this.onPressed, this.text, this.textColor, this.backgroundColor, this.border, this.enabled, this.margin, this.radius, this.loading = false, this.icon, this.shadow, this.padding, this.isCircle = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonPlus(
      padding: this.padding != null ? this.padding! : EdgeInsets.zero,
      margin: margin ?? EdgeInsets.all(0),
      shadows: [
        if (this.shadow != null) this.shadow!
      ],
      width: double.maxFinite,
      onPressed: this.onPressed,
      enabled: enabled ?? true,
      radius: RadiusPlus.all(radius ?? 8),
      border: border ?? BorderPlus(width: 0, color: Colors.transparent),
      color: this.enabled == null || this.enabled! ? (backgroundColor ?? ColorsUtil.PRIMARY_COLOR) : Colors.grey[300],
      isCircle: this.isCircle,
      child: loading ? CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.white
      ): Row(
          mainAxisAlignment: this.icon == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GlobalTextWidget(
                text != null ? '$text' : 'Entendi',
                color: textColor ?? ColorsUtil.DARK_COLOR,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textOverflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
            if (this.icon != null) Icon(
              this.icon!,
              color: textColor,
            )
          ]
      )
    );
  }
}
