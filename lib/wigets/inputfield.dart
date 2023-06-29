import 'package:flutter/material.dart';
import 'package:todoappfinal/constants/colors.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      required this.hint,
      required this.labeltext,
      required this.controller});

  final TextEditingController controller;
  final String hint, labeltext;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF848484),
            fontSize: 15,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: grey, width: 0.81),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: black, width: 0.81),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: black, width: 0.81),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: labeltext,
          labelStyle: const TextStyle(
            color: Color(0xFF848484),
            fontSize: 15,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
          )),
    );
  }
}
