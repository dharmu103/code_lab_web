import 'package:flutter/material.dart';

Widget textFields(controller, hint) {
  return TextFormField(
    validator: (v) {
      if (hint == 'coupon') {
        return null;
      }
      if (v == null || v == "") {
        return "Please Enter text";
      }
      return null;
    },
    controller: controller,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      isDense: true,
      hintText: hint,
      border: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black45)),
      focusedBorder: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black)),
    ),
  );
}
