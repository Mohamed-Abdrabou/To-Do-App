import 'package:flutter/material.dart';
typedef validatorType  = String? Function(String?);
class Customformfield extends StatefulWidget {
  bool isPassword;
  String label;
  TextInputType keybord;
  validatorType validate;
  TextEditingController controller;
  int? maxLength;
  Customformfield(
      {required this.label, required this.keybord, this.isPassword = false,required this.validate,required this.controller,this.maxLength});

  @override
  State<Customformfield> createState() => _CustomformfieldState();
}

class _CustomformfieldState extends State<Customformfield> {
  bool isObscured =true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      controller: widget.controller,
      validator: widget.validate,
      obscureText: widget.isPassword
          ? isObscured
          : false
      ,
      keyboardType: widget.keybord,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 18),
      decoration: InputDecoration(
         counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.white
            )
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscured =!isObscured;
                    });
                  },
                  icon: Icon(
                    isObscured
                        ? Icons.visibility_off_outlined
                    :Icons.visibility_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ))
              : null,
          labelText: widget.label,
          labelStyle: Theme.of(context).textTheme.labelSmall),
    );
  }
}
