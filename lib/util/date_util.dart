
class DateUtil {
  static const int DATA_INICIAL = 0, DATA_FINAL = 1;

  static List<String> meses = [
    "FORMATS.MES.1",
    "FORMATS.MES.2",
    "FORMATS.MES.3",
    "FORMATS.MES.4",
    "FORMATS.MES.5",
    "FORMATS.MES.6",
    "FORMATS.MES.7",
    "FORMATS.MES.8",
    "FORMATS.MES.9",
    "FORMATS.MES.10",
    "FORMATS.MES.11",
    "FORMATS.MES.12"
  ];

  static String? timezoneName;

  static List<int> anos = _returnYears();

  static initDataTimezone({String? timezone}) {
    timezoneName = timezone;
  }

  static List<int> getAnos() {
    return anos;
  }

  static int getIndexAno(int ano) {
    return anos.indexOf(ano);
  }

  static List<String> getMeses() {
    return meses;
  }

  static int getAno(int key) {
    return anos.elementAt(key);
  }

  static String getMes(int key) {
    return meses.elementAt(key);
  }

  static int getDateInMilliSeconds(int key, int index) {
    DateTime newDate = new DateTime(
      anos.elementAt(index),
      key + 1,
      1,
      0,
      0,
    );
    return newDate.millisecondsSinceEpoch;
  }

  static List<int> _returnYears() {
    List<int> list = [];
    for (int i = 0; i <= 50; i++) {
      list.add(DateTime.now().year - i);
    }
    return list;
  }

  static int getHourInMilliseconds(DateTime data) {
    var dataAux = new DateTime(data.year, data.month, data.day, 0, 0);
    return data.difference(dataAux).inMilliseconds;
  }

  static String getWeekName(int day) {
    switch (day) {
      case 0:
        return 'FORMATS.DIA.7';
      case 1:
        return 'FORMATS.DIA.1';
      case 2:
        return 'FORMATS.DIA.2';
      case 3:
        return 'FORMATS.DIA.3';
      case 4:
        return 'FORMATS.DIA.4';
      case 5:
        return 'FORMATS.DIA.5';
      default:
        return 'FORMATS.DIA.6';
    }
  }

  static String getWeekShortName(int day) {
    switch (day) {
      case 0:
        return 'FORMATS.DIA_RESUMIDO.7';
      case 1:
        return 'FORMATS.DIA_RESUMIDO.1';
      case 2:
        return 'FORMATS.DIA_RESUMIDO.2';
      case 3:
        return 'FORMATS.DIA_RESUMIDO.3';
      case 4:
        return 'FORMATS.DIA_RESUMIDO.4';
      case 5:
        return 'FORMATS.DIA_RESUMIDO.5';
      default:
        return 'FORMATS.DIA_RESUMIDO.6';
    }
  }

  static DateTime getDataInicial(DateTime date) {
    return new DateTime(date.year, date.month, date.day, 0, 0, 0);
  }

  static DateTime getDataFinal(DateTime date) {
    return new DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static bool isIntervaloValido(int? tDataInicial, int? tDataFinal) {
    return tDataInicial == null || tDataFinal == null || tDataInicial < tDataFinal;
  }

  static bool checkCampoDataInicial(int? tDataInicial, int? tDataFinal) {
    if (tDataFinal == null || tDataFinal == 0) {
      return true;
    } else if (tDataFinal >= tDataInicial!) {
      return true;
    } else {
      return false;
    }
  }

  static bool checkCampoDataFinal(int? tDataInicial, int? tDataFinal) {
    if (tDataInicial == null || tDataInicial == 0) {
      return true;
    } else if (tDataInicial <= tDataFinal!) {
      return true;
    } else {
      return false;
    }
  }

  static DateTime getCurrentDateMinute() {
    DateTime dtAtual = DateTime.now();
    return new DateTime(dtAtual.year, dtAtual.month, dtAtual.day, dtAtual.hour, dtAtual.minute);
  }
}
