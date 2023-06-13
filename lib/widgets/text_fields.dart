import 'package:flutter/material.dart';

Widget textFields(controller, hint) {
  return TextFormField(
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      hintText: hint,
      border: OutlineInputBorder(),
    ),
  );
}
