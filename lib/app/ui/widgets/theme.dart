import 'package:flutter/material.dart';

var themes = ThemeData(
  fontFamily: 'IRANSansX',
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(8, 212, 76, 0.5),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.greenAccent),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Color.fromRGBO(8, 212, 76, 0.5),
      unselectedIconTheme: IconThemeData(color: Colors.black),
      selectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.9)),
      selectedItemColor: Colors.white.withOpacity(0.9)),
);

var alamutPrimaryColor = Color.fromRGBO(8, 212, 76, 0.5);
var persianNumber = 'IRANSansXFaNum';

InputDecoration inputDecoration(String labelText, IconData iconData,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
    helperText: helperText,
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.grey,
    ),
    prefixText: prefix,
    prefixIcon: Icon(
      iconData,
      size: 20,
    ),
    counterText: '',
    prefixIconConstraints: BoxConstraints(minWidth: 60),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: Color.fromRGBO(69, 230, 123, 1), width: 0.9)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: Color.fromRGBO(69, 230, 123, 1), width: 2)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red)),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white)),
  );
}
