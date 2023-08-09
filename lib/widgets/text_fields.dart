import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textFields(controller, hint) {
  return TextFormField(
    validator: (v) {
      if (hint == 'index') {
        if (!GetUtils.isNum(v.toString())) {
          // print(GetUtils.isNumericOnly(v.toString()));
          return "Only Integer Value Supported";
        }
      }
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

Widget textFieldReadOnly(hint) {
  return TextFormField(
    readOnly: true,
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
