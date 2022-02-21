import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final backgroundColor;

  const TextFieldInput({Key? key, required this.textEditingController,
    required this.textInputType, required this.hintText, this.isPass=false,
    required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        // borderSide: Divider.createBorderSide(context),
        borderRadius: BorderRadius.circular(30),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        fillColor: backgroundColor,
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.bold),
        border: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(20),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
