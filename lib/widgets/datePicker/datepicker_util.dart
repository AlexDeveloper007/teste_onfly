import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

int calcDateCount(int year, int month) {
  if (_leapYearMonths.contains(month)) {
    return 31;
  } else if (month == 2) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return 29;
    }
    return 28;
  }
  return 30;
}

class CustomDatePicker extends CommonPickerModel {

  late DateTime maxTime;
  late DateTime minTime;

  static const int US_PICKER = 2, BR_PICKER = 1, SI_PICKER = 0;

  int datepickerType = BR_PICKER;

  String? localeName;

  // A lista tem 3 elementos que podem ser 'D', 'M' e 'Y', 
  // a posição deste elemento define a ordem dos seletores do picker
  List<String> iPositionSelector = [];

  // Lista com os elementos 'D', 'M' e 'Y' com suas respectivas posições no picker
  Map<String, int> iSelectorPosition = {};

  // Utilizado para definir a opção (valor) associada ao seletor do picker no construtor
  Map<String, dynamic> iSelectorValues = {};

  CustomDatePicker({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    LocaleType? locale,
    this.localeName,
  }) : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);
    this.currentTime = currentTime ?? DateTime.now();

    currentTime = currentTime ?? DateTime.now();
    if (currentTime.compareTo(this.maxTime) > 0) {
      currentTime = this.maxTime;
    } else if (currentTime.compareTo(this.minTime) < 0) {
      currentTime = this.minTime;
    }

    this.currentTime = currentTime;

    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();

    datepickerType = getDatepickerType();

    if (datepickerType == BR_PICKER) {
      iPositionSelector = ['D', 'M', 'Y'];
      iSelectorPosition = { 'D': 0, 'M': 1, 'Y': 2 };
      leftList = getDays();
      middleList = getMonths();
      rightList = getYears();
    } else if (datepickerType == US_PICKER) {
      iPositionSelector = ['M', 'D', 'Y'];
      iSelectorPosition = { 'D': 1, 'M': 0, 'Y': 2 };
      leftList = getMonths();
      middleList = getDays();
      rightList = getYears();
    } else {
      iPositionSelector = ['Y', 'M', 'D'];
      iSelectorPosition = { 'D': 2, 'M': 1, 'Y': 0 };
      leftList = getYears();
      middleList = getMonths();
      rightList = getDays();
    }

    iSelectorValues['D'] = this.currentTime.day - minDay;
    iSelectorValues['M'] = this.currentTime.month - minMonth;
    iSelectorValues['Y'] = this.currentTime.year - this.minTime.year;

    super.setLeftIndex(iSelectorValues[iPositionSelector[0]] ?? 0);
    super.setMiddleIndex(iSelectorValues[iPositionSelector[1]] ?? 0);
    super.setRightIndex(iSelectorValues[iPositionSelector[2]] ?? 0);
  }
  
  int getDatepickerType() {
    if (localeName == 'pt_BR') {
      return BR_PICKER;
    } else if (localeName == 'en_US') {
      return US_PICKER;
    } else {
      return SI_PICKER;
    }
  }

  setIndex(int index, String dataProp) {
    if (iSelectorPosition[dataProp] == 0) {
      super.setLeftIndex(index);
    } else if (iSelectorPosition[dataProp] == 1) {
      super.setMiddleIndex(index);
    } else {
      super.setRightIndex(index);
    }
  }

  setYear(int index) {
    setIndex(index, 'Y');
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            )
          : DateTime(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              currentTime.day,
            )
          : DateTime(
              destYear,
              currentTime.month,
              currentTime.day,
            );
    }

    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    if (datepickerType == BR_PICKER) {
      middleList = getMonths();
      leftList = getDays();
    } else if (datepickerType == US_PICKER) {
      leftList = getMonths();
      middleList = getDays();
    } else {
      middleList = getMonths();
      rightList = getDays();
    }

    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    setMonth(currentTime.month - minMonth);
    setDay(currentTime.day - minDay);
  }

  setMonth(int index) {
    setIndex(index, 'M');
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    if (datepickerType == BR_PICKER) {
      leftList = getDays();
    } else if (datepickerType == US_PICKER) {
      middleList = getDays();
    } else {
      rightList = getDays();
    }

    int minDay = _minDayOfCurrentMonth();
    setDay(currentTime.day - minDay);
  }

  setDay(int index) {
    setIndex(index, 'D');
    int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            minDay + index,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            minDay + index,
          );
  }

  setSelection(int index, int iWidget) {
    if (iSelectorPosition['Y'] == iWidget) {
      setYear(index);
    } else if (iSelectorPosition['M'] == iWidget) {
      setMonth(index);
    } else {
      setDay(index);
    }
  }

  @override
  setLeftIndex(int index) {
    setSelection(index, 0);
    super.setLeftIndex(index);
  }

  @override
  setMiddleIndex(int index) {
    setSelection(index, 1);
    super.setMiddleIndex(index);
  }

  @override
  setRightIndex(int index) {
    setSelection(index, 2);
    super.setRightIndex(index);
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime.year &&
            currentTime.month == minTime.month
        ? minTime.day
        : 1;
  }

  List<String> getYears() {
    return List.generate(maxTime.year - minTime.year + 1, (int index) {
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  List<String> getMonths() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    return List.generate(maxMonth - minMonth + 1, (int index) {
      return '${_localeMonth(minMonth + index)}';
    });
  }

  List<String> getDays() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    return List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    return currentTime;
  }

  String _localeYear() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '年';
    } else if (locale == LocaleType.ko) {
      return '년';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List monthStrings = i18nObjInLocale(locale)['monthLong'] as List<String>;
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '日';
    } else if (locale == LocaleType.ko) {
      return '일';
    } else {
      return '';
    }
  }
}