import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants{
   static bool isValidEmail(String email){
   return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
   static showToast(String message){
     Fluttertoast.showToast(
         msg: message,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.grey.withOpacity(0.3),
         textColor: Colors.black,
         fontSize: 16.0
     );
   }
}
