import 'package:flutter/material.dart';

class CustomLoadingDialog extends StatelessWidget {
  const CustomLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
