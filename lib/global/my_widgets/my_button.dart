

import 'package:flutter/material.dart';

import '../../utils/practical_method.dart';


ElevatedButton myButton({@required Function ?onPressed,@required String ?text}){


  return ElevatedButton(onPressed: ()=>onPressed!(),style: ElevatedButton.styleFrom(
    side: BorderSide(color: Color(PracticalMethod.HexaColorConvertColor(
        "#0A588D"))),
    foregroundColor: Color(PracticalMethod.HexaColorConvertColor(
        "#0A588D")),
    backgroundColor: Colors.white60,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),),child: Text(text!));
}