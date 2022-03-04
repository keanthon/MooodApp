import 'package:flutter/material.dart';

class TextInputDecoration {
  final String hintText;

  final backgroundColor;


  TextInputDecoration( this.hintText, this.backgroundColor);


  InputDecoration decorate() {
    final inputBorder = OutlineInputBorder(
      // borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(30),
    );

    return InputDecoration(
      fillColor: backgroundColor,
      hintText: hintText,
      hintStyle: const TextStyle(fontWeight: FontWeight.bold),
      border: inputBorder,
      filled: true,
      contentPadding: const EdgeInsets.all(20),
    );
  }
}
