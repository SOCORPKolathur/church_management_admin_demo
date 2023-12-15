import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';

class Constants {

  //Color primaryAppColor = const Color(0xffE7B41F);
  Color primaryAppColor = const Color(0xffb80d38);

  static String churchLogo = '';
  static String networkChurchLogo = 'https://firebasestorage.googleapis.com/v0/b/church-management-cbf7d.appspot.com/o/dailyupdates%2Flogo.png?alt=media&token=6c944fcd-500c-4c8d-af7b-a7086e6b956a&_gl=1*1pse0u7*_ga*MTQxNDQ0NTk0Mi4xNjkyMjUyODI4*_ga_CW55HF8NVT*MTY5ODkxMDQ0MS4zMTQuMS4xNjk4OTEzMDA2LjIyLjAuMA..';
  static String MembershipAmount = '1000';

  static String apiKeyForNotification = 'AAAAii4b5Ts:APA91bEvfFnHM14KwgEWmOEr3JB6BqdoTDuAnFvJLD0HccAoc6H7Ej4kL-VSTv1ce3frKTdFGl9N2tlQNMGV7LXJqNAEDMqM38TDAMfEQDFR6BTJThYUieJ8ebTW5gwuJE4HZCnHkmRe';


  datePicker(context) async {
    DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      dateFormat: "dd-MM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );
    return pickedDate;
  }


  futureDatePicker(context) async {
    DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
      dateFormat: "dd-MM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );
    return pickedDate;
  }


  static List<Color> colorsList = [
    Colors.purple,
    Colors.pink,
    Colors.grey,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.brown,
    Colors.lime,
    Colors.deepOrange,
    Colors.yellow,
    Colors.orange,
    Colors.indigo,
    Colors.teal,
    Colors.amber,
    Colors.white,
    Colors.black,
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.deepOrangeAccent,
    Colors.lightBlueAccent,
    Colors.blueGrey,
  ];

}