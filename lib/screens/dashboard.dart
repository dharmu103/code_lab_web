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
    final controller = Get.put(SideMenuController());
    List<Widget> list = [
      const DatabaseScreen()
      // const StoreWidget(),
      // const DealWidget(),
      // const ThemeWidget()
    ];
    return SafeArea(
      child: Container(
        width: Get.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(flex: 1, child: SideMenu()),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Header(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  GetX<SideMenuController>(
                      builder: (controller) =>
                          list[controller.currentPage.value])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
