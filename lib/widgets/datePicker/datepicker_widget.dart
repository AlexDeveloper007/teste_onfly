import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:teste_onfly/util/ColorsUtil.dart';
import 'package:teste_onfly/util/date_util.dart';
import 'package:teste_onfly/util/metodos.dart';
import 'package:teste_onfly/widgets/datePicker/datepicker_util.dart';
import 'package:teste_onfly/widgets/tap_card_widget.dart';

class DatepickerWidget extends StatefulWidget {

  final String label;
  final DatepickerController controller;
  final Function()? onSelect;
  final bool isTime;
  final bool disabled;
  final bool required;
  final DateTime? maxTime;
  final DateTime? minTime;
  final String? maxTimeMessage;
  final String? minTimeMessage;
  final String? requiredMessage;
  final String? outErrorMessage;
  final String? placeholder;
  final String? msgErro;
  final EdgeInsets? margin;
  final int? dataType;
  final Key? key;

  const DatepickerWidget({
    this.key,
    required this.controller,
    required this.label,
    this.placeholder,
    this.onSelect,
    this.maxTime,
    this.minTime,
    this.margin,
    this.required = false,
    this.outErrorMessage,
    this.minTimeMessage,
    this.maxTimeMessage,
    this.requiredMessage,
    this.disabled = false,
    this.isTime = false,
    this.dataType,
    this.msgErro
  }) : super(key: key);

  @override
  _DatepickerWidgetState createState() => _DatepickerWidgetState();
}

class _DatepickerWidgetState extends State<DatepickerWidget> {

  dynamic selectedDate, auxSelectedDate;

  bool valueUpdated = false, onceSelected = false;

  String selectDateText = '';

  String? _msgErro;

  @override
  void initState() {
    super.initState();
    _msgErro = widget.msgErro;
  }

  @override
  Widget build(BuildContext context) {
    selectDateText = getSelectedText();
    widget.controller.minDate = getMinToValidation();
    widget.controller.maxDate = getMaxToValidation();
    widget.controller.isRequired = widget.required;
    widget.controller.validateMinDateError();
    widget.controller.validateMaxDateError();
    _msgErro = getMessageError();
    return TapCardWidget(
      key: widget.key ?? null,
      text: selectDateText,
      placeholder: widget.placeholder ?? '',
      label: widget.label + (widget.required ? '*' : ''),
      labelColor: _msgErro != null ? ColorsUtil.ERROR_COLOR : ColorsUtil.DARK_COLOR,
      disabled: widget.disabled,
      suffixWidget: Icon(
        widget.isTime ? Icons.schedule : Icons.date_range,
        color: Colors.grey[400],
      ),
      errorMessage: widget.outErrorMessage != null ? widget.outErrorMessage : _msgErro,
      margin: widget.margin ?? null,
      onTap: () {
        if (widget.disabled) {
          return;
        }
        FocusScope.of(context).unfocus();
        Function() onCancel = () {
          setState(() {
            widget.controller.validateRequired();
            _msgErro = getMessageError();
          });
        };
        Function(DateTime)? onConfirm = (date) {
          setState(() {
            widget.controller.date = getDataWork(date);
            selectDateText = getSelectedText();
            widget.controller.validateMinDateError();
            widget.controller.validateMaxDateError();
            widget.controller.validateRequired();
            _msgErro = getMessageError();
          });
          if (widget.onSelect != null)
            widget.onSelect!();
        };
        if (widget.isTime) {
          if (Platform.localeName == 'en_US') {
            DatePicker.showTime12hPicker(context,
              currentTime: widget.controller.date,
              onConfirm: onConfirm,
              onCancel: onCancel
            );
          } else {
            DatePicker.showTimePicker(context,
              currentTime: widget.controller.date,
              showSecondsColumn: false,
              onConfirm: onConfirm,
              onCancel: onCancel
            );
          }
        } else {
          DatePicker.showPicker(context,
            pickerModel: CustomDatePicker(
              currentTime: widget.controller.date ?? DateTime.now(),
              locale: Platform.localeName == 'pt_BR' ? LocaleType.pt: LocaleType.en,
              minTime: getMinToValidation(),
              maxTime: getMaxToValidation(),
              localeName: Platform.localeName
            ),
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: Platform.localeName == 'pt_BR' ? LocaleType.pt: LocaleType.en,
          );
        }
      },
    );
  }

  String getSelectedText() {
    if (widget.controller.date != null) {
      return widget.isTime ? Metodos.getHoraString(widget.controller.date) : Metodos.getDataString(widget.controller.date, numDate: true);
    }
    return '';
  }

  DateTime getDataWork(DateTime date) {
    if (widget.isTime) {
      return widget.controller.date == null ? date
        : DateTime(widget.controller.date!.year, widget.controller.date!.month, widget.controller.date!.day, date.hour, date.minute, date.second);
    } else {
      return widget.dataType == null ? date 
        : (widget.dataType == DateUtil.DATA_FINAL 
          ? DateUtil.getDataFinal(date) : DateUtil.getDataInicial(date));
    }
  }

  DateTime? getMinToValidation() {
    if (widget.minTime == null || widget.isTime)
      return widget.minTime;
    return DateUtil.getDataInicial(widget.minTime!);
  }

  DateTime? getMaxToValidation() {
    if (widget.maxTime == null || widget.isTime)
      return widget.maxTime;
    return DateUtil.getDataFinal(widget.maxTime!);
  }

  String? getMessageError() {
    return widget.controller.getMessageError(breakLines: false).isNotEmpty ? widget.controller.getMessageError(breakLines: false) : null;
  }
}

class DatepickerController {

  DateTime? date;
  DateTime? minDate;
  DateTime? maxDate;
  bool isRequired = false;
  bool minDateError;
  bool maxDateError;
  bool requiredError;
  String minDateErrorMessage = '';
  String maxDateErrorMessage = '';
  String requiredErrorMessage = '';

  DatepickerController({
    this.date,
    this.minDateError = false,
    this.maxDateError = false,
    this.requiredError = false
  });

  validateMinDateError() {
    this.minDateError = this.date != null && this.minDate != null && this.date!.isBefore(this.minDate!);
  }

  validateMaxDateError() {
    this.maxDateError = this.date != null && this.maxDate != null && this.date!.isAfter(this.maxDate!);
  }

  validateRequired() {
    this.requiredError = this.isRequired && this.date == null;
  }

  String getMessageError({bool breakLines = true}) {
    String msgError = '', breakCode = breakLines ? '\n' : '';
    if (this.minDateError)
      msgError += '$minDateErrorMessage$breakCode';
    if (this.maxDateError)
      msgError += '$maxDateErrorMessage$breakCode';
    if (this.requiredError)
      msgError += '$requiredErrorMessage$breakCode';
    return msgError;
  }

  bool isValid() {
    validateMaxDateError();
    validateMinDateError();
    validateRequired();
    return !this.minDateError && !this.maxDateError && !this.requiredError;
  }

  clear() {
    this.date = null;
    this.requiredError = false;
    this.minDateError = false;
    this.maxDateError = false;
  }
}


class CustomSelectorPicker extends DatePickerModel {

  CustomSelectorPicker({
    required DateTime currentTime,
    required LocaleType locale,
    DateTime? maxTime,
    DateTime? minTime,
  }) : super(locale: locale, currentTime: currentTime, minTime: minTime, maxTime: maxTime) {
    // this.currentTime = currentTime ?? DateTime.now();
    if (locale == LocaleType.en) {
      this.setLeftIndex(this.currentTime.month);
      this.setMiddleIndex(this.currentTime.day);
      this.setRightIndex(this.currentTime.year);
    } else {
      this.setLeftIndex(this.currentTime.day);
      this.setMiddleIndex(this.currentTime.month);
      this.setRightIndex(this.currentTime.year);
    }
  }
}
