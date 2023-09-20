import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_plus/flutter_plus.dart';

class Metodos {

  static String getDataString(DateTime? dateTime, {bool numDate = false}) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime ?? DateTime.now());
    return formattedDate;
  }

  static String getHoraString(DateTime? dateTime){
    String formattedDate = DateFormat('HH:mm').format(dateTime ?? DateTime.now());
    return formattedDate;
  }

  static String getDataHoraString(DateTime? dateTime, {bool numDate = false}) {
    return '${getDataString(dateTime, numDate: numDate)} ${getHoraString(dateTime)}';
  }

  static String getNumHoraString(DateTime? dateTime) {
    return DateFormat(DateFormat.HOUR_MINUTE, 'pt_BR').format(dateTime ?? DateTime.fromMillisecondsSinceEpoch(0));
  }

  static int getDataMilleseconds(DateTime dateTime){
    int date = dateTime.millisecondsSinceEpoch;
    //print("date ==> $date");
    return date;
  }

  static String getHourFromMinutesString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;

    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  static String getDayFromMinutesString(int value) {
    final int hour = value ~/ 60;
    final double days = hour / 24;

    return days.toInt().toString();
  }

  static DateTime convertStringDateTime(String data){
    DateTime dateTime = DateFormat(DateFormat.HOUR_MINUTE, Platform.localeName).parse(data);
    return dateTime;
  }

  static bool validarEmail(String email){
    return email.isEmail;
  }

  static String getStringPreco(double value, BuildContext context, {espaco = true}){
    NumberFormat moedaFormat = NumberFormat.currency(symbol: "R\$", locale: "pt_BR");
    return moedaFormat.format(value);
  }

  static Future openModal(BuildContext context, Widget tela,{ expand = true}){
    return showBarModalBottomSheet(
      expand: expand,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Scaffold(
          body: tela
      ) ,
    );
  }

  static Future<void>? openModalBaixo(BuildContext context, Widget tela,{ expand = false}) {
    showCupertinoModalBottomSheet(
      barrierColor: Colors.black87.withOpacity(0.5),
      expand: expand,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => tela,
    );
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  }