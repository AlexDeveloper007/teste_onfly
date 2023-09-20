
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';

class TapCardWidget extends StatefulWidget {

  final String? label;
  final Color? labelColor;
  final String? placeholder;
  final double? fontSizePlaceholder;
  final String? text;
  final String? errorMessage;
  final EdgeInsets? margin;
  final Widget? suffixWidget;
  final double? height;
  final double? fontSizeLabel;
  final dynamic onTap;
  final bool? disabled;

  const TapCardWidget({
    Key? key,
    this.label,
    this.labelColor,
    this.placeholder,
    this.fontSizePlaceholder,
    this.margin,
    this.suffixWidget,
    this.height,
    this.fontSizeLabel,
    this.text,
    this.onTap,
    this.errorMessage,
    this.disabled
  }) : super(key: key);

  @override
  _TapCardWidgetState createState() => _TapCardWidgetState();
}

class _TapCardWidgetState extends State<TapCardWidget> {
  @override
  Widget build(BuildContext context) {
    return ContainerPlus(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalTextWidget(
            '${widget.label}',
            fontWeight: FontWeight.w400,
            fontSize: widget.fontSizeLabel ?? 14,
            color: widget.labelColor ?? ColorsUtil.DARK_COLOR,
          ),
          SizedBox(
            height: 4,
          ),
          ContainerPlus(
            onTap: widget.onTap,
            border: BorderPlus(width: 1, color: widget.errorMessage == null || widget.errorMessage!.isEmpty ? ColorsUtil.GREY_COLOR : Colors.red),
            padding: EdgeInsets.only(top: 4, bottom: 4, right: 16, left: 8),
            height: widget.height ?? 48,
            color: widget.disabled == null || !widget.disabled! ? Colors.white : Colors.grey[100],
            radius: RadiusPlus.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: GlobalTextWidget(
                   widget.text!.isEmpty ? widget.placeholder : widget.text,
                    color: Colors.grey[600],
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    fontSize: widget.fontSizePlaceholder ?? 17,
                  ),
                ),
                widget.suffixWidget ?? ContainerPlus()
              ],
            )
          ),
          if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) GlobalTextWidget(
            widget.errorMessage ?? '',
            padding: EdgeInsets.only(top: 4),
            color: Colors.red,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}