import 'package:code_lab_web/screens/auth_screen.dart';
import 'package:code_lab_web/screens/dashboard.dart';
import 'package:code_lab_web/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLogin() async {
    // RemoteService.test();
    print("splash run");
    final pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    if (token != null) {
      RemoteService.token = token;
      RemoteService.initiatizeAuthHeader();
      Get.offAll(DashboardScreen());
    } else {
      Get.offAll(const AuthScreen());
    }
  }

  @override
  initState() {
    checkLogin();
    super.initState();
    // Add listeners to this class
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
