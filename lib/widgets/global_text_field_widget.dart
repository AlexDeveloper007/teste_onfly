
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/widgets/global_text_widget.dart';

class GlobalTextFieldWidget extends StatelessWidget {
  final String? label;
  final Color? labelColor;
  final Color? textColor;
  final String? placeholder;
  final TextEditingController? controller;
  final autofocus;
  final bool? obscureText;
  final EdgeInsets? margin;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final double? height;
  final int? maxLength;
  final String? mask;
  final String? errorMessage;
  final TextInputType? textInputType;
  final int? maxLines;
  final double? fontSize;
  final bool enable;
  final Function(String)? onChanged;
  final String? subText;
  final Color? subTextColor;
  final VoidCallback? onClickSubText;
  final bool readOnly;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final double? radius;
  final dynamic onTap;
  final bool required;
  final String? tooltipMessage;

  const GlobalTextFieldWidget({
    Key? key,
    this.label,
    this.placeholder,
    this.labelColor,
    this.controller,
    this.autofocus = false,
    this.obscureText,
    this.prefixWidget,
    this.suffixWidget,
    this.margin,
    this.height,
    this.maxLength,
    this.mask,
    this.onChanged,
    this.subText,
    this.subTextColor,
    this.onClickSubText,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.fontSize = 16,
    this.textColor,
    this.enable = true,
    this.errorMessage,
    this.readOnly = false,
    this.onSubmitted,
    this.required = false,
    this.textInputAction,
    this.onTap,
    this.radius,
    this.tooltipMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? textoSelecionado;
    if (controller != null) {
      textoSelecionado = controller!.text;
      controller!.selection = TextSelection.fromPosition(TextPosition(offset: controller!.text.length));
    }
    return ContainerPlus(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              label != null
                  ? Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: GlobalTextWidget(
                              required ? '$label*' : label,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: this.errorMessage != null && this.errorMessage!.length > 1 ? Colors.red : (labelColor ?? ColorsUtil.DARK_COLOR),
                            ),
                          ),
                          SizedBox(width: 8,),
                          tooltipMessage != null
                              ? Tooltip(
                                  showDuration: Duration(seconds: 2),
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: tooltipMessage,
                                  child: ContainerPlus(
                                    alignment: Alignment.center,
                                    color: ColorsUtil.DARK_COLOR,
                                    padding: EdgeInsets.all(1),
                                    radius: RadiusPlus.all(50),
                                    child: Icon(
                                      Icons.question_mark,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ContainerPlus(),
                        ],
                      ),
                    )
                  : ContainerPlus(),
              subText != null
                  ? GlobalTextWidget(
                      subText,
                      onPressed: onClickSubText ?? () {},
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: subTextColor ?? ColorsUtil.ERROR_COLOR,
                    )
                  : ContainerPlus(),
            ],
          ),
          SizedBox(height: 4,),
          ContainerPlus(
            border: BorderPlus(width: 1, color: errorMessage == null || errorMessage!.isEmpty ? ColorsUtil.GREY_COLOR : Colors.red),
            color: Colors.white,
            radius: RadiusPlus.all(this.radius ?? 4),
            child: TextFieldPlus(
              onTap: this.onTap,
              textInputAction: this.textInputAction ?? (this.textInputType == TextInputType.multiline ? TextInputAction.newline : TextInputAction.done),
              onSubmitted: this.onSubmitted,
              readOnly: this.readOnly,
              onChanged: onChanged != null
                  ? (text) {
                      if (textoSelecionado != text) onChanged!(text);
                    }
                  : null,
              autofocus: autofocus,
              fontSize: fontSize,
              obscureText: obscureText ?? false,
              height: height ?? 48,
              maxLines: maxLines,
              maxLength: maxLength ?? 200,
              prefixWidget: prefixWidget,
              suffixWidget: suffixWidget,
              controller: controller,
              textInputType: textInputType,
              textColor: !enable ? Colors.grey[600] : textColor,
              enabled: enable,
              mask: mask,
              placeholder: TextPlus(
                placeholder == null ? '' : '$placeholder',
                color: ColorsUtil.GREY_COLOR,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          errorMessage != null && errorMessage!.length > 1
              ? GlobalTextWidget(
                  errorMessage,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.red,
                  margin: EdgeInsets.only(top: 4),
                )
              : ContainerPlus(),
        ],
      ),
    );
  }
}
