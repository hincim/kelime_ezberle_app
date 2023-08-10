
import 'package:flutter/material.dart';

Container textFieldBuilder({
  int height = 40,
  @required TextEditingController? textEditingController,
  Icon? icon,
  IconButton? suffixIcon,
  String? hintText,
  TextAlign textAlign = TextAlign.center,
  TextInputType? textInputType,
  bool? obscureText
}) {
  return Container(
    height: height.toDouble(),
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.25),
        borderRadius: BorderRadius.circular(4)),
    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 4),
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: TextField(
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        maxLines: 1,
        textAlign: textAlign,
        controller: textEditingController,
        style: TextStyle(
            color: Colors.black,
            fontFamily: "RobotoMedium",
            decoration: TextDecoration.none,
            fontSize: 18),
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          hintText: hintText,
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: suffixIcon
        ),
      ),
    ),
  );
}

