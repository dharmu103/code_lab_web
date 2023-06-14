import 'package:code_lab_web/constant/constant.dart';
import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DatabaseController());
    return Material(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(30),
          width: 300,
          // height: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                  hintText: "Email",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            TextFormField(
              controller: controller.password,
              decoration: const InputDecoration(
                  hintText: "Password",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            GetBuilder<DatabaseController>(
              initState: (_) {},
              builder: (_) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        controller.error.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
                width: Get.width,
                height: kTextTabBarHeight,
                child: ElevatedButton(
                    onPressed: () {
                      controller.login({});
                    },
                    child: const Text("Login")))
          ]),
        ),
      ),
    );
  }
}
