import 'package:code_lab_web/constant/constant.dart';
import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:code_lab_web/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

bool hidePassword = true;

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DatabaseController());
    final _formKey = GlobalKey<FormState>();
    return Material(
      child: Center(
        child: Container(
          width: 300,
          // height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo-main.png"),
              const SizedBox(
                height: defaultPadding * 2,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextFormField(
                      controller: controller.email,
                      validator: (v) {
                        if (!GetUtils.isEmail(v!)) {
                          return "Enter valid Email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: "Email",
                          fillColor: Colors.white,
                          filled: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    TextFormField(
                      controller: controller.password,
                      obscureText: hidePassword,
                      validator: (v) {
                        if (v == "") {
                          return "Enter valid Password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          suffixIconColor: primaryColor,
                          suffixIcon: IconButton(
                            icon: hidePassword
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),
                          hintText: "Password",
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    GetBuilder<DatabaseController>(
                      initState: (_) {},
                      builder: (_) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            controller.error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                        width: Get.width,
                        height: kTextTabBarHeight,
                        child: GetBuilder<DatabaseController>(
                          initState: (_) {},
                          builder: (_) {
                            return PrimaryButton(
                                text: "Login",
                                onpress: () {
                                  if (_formKey.currentState!.validate()) {
                                    _.login({
                                      "email": controller.email.text.trim(),
                                      "password": controller.password.text
                                    });
                                  }
                                },
                                state: _.btnState);
                          },
                        ))
                  ]),
                ),
              ),
              // Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
