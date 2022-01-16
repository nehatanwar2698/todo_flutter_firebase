import 'dart:ui' show Color;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UIConstant {
  static const Color blue = Color(0xFFd70360);
  static const Color light = Color(0XFF7c92f5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFD12626);
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

  static void showSnackBar(BuildContext context, String text) =>
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text(
          text,
          style: TextStyle(fontSize: 16),
        )));
}
