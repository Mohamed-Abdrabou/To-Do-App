import 'package:flutter/material.dart';

class CustomErrorDialog extends StatelessWidget {
  final String message;
  final String postiveBtnTitle;
  final void Function() postiveBtnPress;
  String? negativeBtnTitle;
  void Function()? negativeBtnPress;
  CustomErrorDialog(
      {required this.message,
      this.postiveBtnTitle = "OK",
      required this.postiveBtnPress,
      this.negativeBtnTitle,
      this.negativeBtnPress});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Text(message),
      actions: [
        TextButton(onPressed: postiveBtnPress, child: Text(postiveBtnTitle)),
        if(negativeBtnTitle!=null)
          TextButton(onPressed: negativeBtnPress, child: Text(negativeBtnTitle!)),
      ],
    );
  }
}
