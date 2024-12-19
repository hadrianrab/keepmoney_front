import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField({
  required String labelText,
  required Icon prefixIcon,
  TextEditingController? controller,
  bool isPassword = false,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    inputFormatters: inputFormatters,
    validator: validator,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: labelText,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
    ),
  );
}
