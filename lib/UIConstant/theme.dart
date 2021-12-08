import 'dart:ui' show Color;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UIConstant {
  static const Color blue = Color(0xFF3557EF);
  static const Color white = Color(0xFFFFFFFF);
  // static const String fontfamily = 'sen-regular';

  void ToastMassage(String s) {
    Fluttertoast.showToast(
        msg: '$s',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
