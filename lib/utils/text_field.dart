import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final bool readOnly;
  final void Function(String)? onChanged;

  const MyTextField({
    Key? key,
    this.controller,
    required this.hintText,
    required this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    required this.readOnly,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width < 343 ? 16 : 20;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
            fillColor: Color(0xffE9EFEB),
            filled: true,
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 19, end: 19),
              child: prefixIcon != null ? Icon(prefixIcon?.icon, color: Color(0xff49454F)) : null
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 20.0),
            suffixIcon: Padding(
              padding: EdgeInsetsDirectional.only(end: 19),
              child: suffixIcon != null ? Icon(suffixIcon?.icon, color: Color(0xff49454F)) : null
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: Colors.transparent)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: Colors.transparent)
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16,
                color: Color(0xff49454F),
                fontFamily: "Roboto"
            )
        ),
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}