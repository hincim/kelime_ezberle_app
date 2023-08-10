import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kelimeezberle/utils/practical_method.dart';


void showToast(String message){

  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(PracticalMethod.HexaColorConvertColor("#abdfe0")),
      textColor: Color(PracticalMethod.HexaColorConvertColor("#0C33B2")),
      fontSize: 16.0
  );
}