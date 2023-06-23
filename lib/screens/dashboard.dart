import 'package:code_lab_web/screens/banner_screen.dart';
import 'package:code_lab_web/screens/users_list_screen.dart';
import 'package:code_lab_web/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/side_menu_controller.dart';
import '../widgets/header.dart';
import 'database_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(SideMenuController());
    List<Widget> list = [
      const DatabaseScreen(),
      const UsersListScreen(),
      const BannerScreen(),
      // const ThemeWidget()
    ];
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: Get.width / 6, child: const SideMenu()),
            SizedBox(
              width: Get.width / 6 * 5,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Header(),
                    const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     ElevatedButton(
                    //         onPressed: () async {
                    //           final pres = await SharedPreferences.getInstance();
                    //           pres.clear();
                    //           Get.offAll(AuthScreen());
                    //         },
                    //         child: const Text("Logout")),
                    //     SizedBox(
                    //       width: defaultPadding * 2,
                    //     )
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                    GetX<SideMenuController>(
                        builder: (controller) =>
                            list[controller.currentPage.value]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
