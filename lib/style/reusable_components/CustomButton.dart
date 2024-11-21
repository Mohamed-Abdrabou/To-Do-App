import 'package:flutter/material.dart';

typedef onBtnClick = void Function();

class Custombutton extends StatelessWidget {
  String lable;
  onBtnClick btnClick;
  Custombutton({required this.lable, required this.btnClick});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: btnClick,
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lable,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_outlined,
              color: Colors.white,
              size: 20,
            )
          ],
        ));
  }
}
