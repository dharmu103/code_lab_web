// import 'package:admin_panel/screens/dashboard/components/country/country.dart';
// import 'package:admin_panel/screens/dashboard/components/country.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/side_menu_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SideMenuController());
    return Drawer(
        child: GetX<SideMenuController>(
      init: SideMenuController(),
      initState: (_) {},
      builder: (_) {
        return ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo.png"),
            ),
            DrawerListTile(
              title: "Database",
              svgSrc: "assets/icons/menu_dashboard.svg",
              selected: controller.currentPage.value == 0,
              press: () {
                controller.changeIndex(0);
                print(controller.currentPage.value);
              },
            ),
            const Divider(),
            DrawerListTile(
              title: "Users",
              svgSrc: "assets/icons/menu_profile.svg",
              selected: controller.currentPage.value == 1,
              press: () {
                controller.changeIndex(1);
              },
            ),
            const Divider(),
            DrawerListTile(
              title: "Banner",
              svgSrc: "assets/icons/country-5.svg",
              press: () {
                controller.changeIndex(2);
                print(controller.currentPage.value);
              },
              selected: controller.currentPage.value == 2,
            ),
            DrawerListTile(
              title: "Carausoul",
              svgSrc: "assets/icons/country-5.svg",
              press: () {
                controller.changeIndex(3);
                print(controller.currentPage.value);
              },
              selected: controller.currentPage.value == 3,
            ),
            // DrawerListTile(
            //   title: "Theme",
            //   svgSrc: "assets/icons/menu_dashboard.svg",
            //   press: () {
            //     controller.changeIndex(3);
            //     print(controller.currentPage.value);
            //   },
            // ),
            // DrawerListTile(
            //   title: "Banner",
            //   svgSrc: "assets/icons/menu_tran.svg",
            //   press: () {
            //     controller.changeIndex(4);
            //   },
            // ),
            // DrawerListTile(
            //   title: "Task",
            //   svgSrc: "assets/icons/menu_task.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Documents",
            //   svgSrc: "assets/icons/menu_doc.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Store",
            //   svgSrc: "assets/icons/menu_store.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Notification",
            //   svgSrc: "assets/icons/menu_notification.svg",
            //   press: () {},
            // ),
          ],
        );
      },
    ));
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.selected,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);
  bool selected;
  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: Colors.grey.shade200,
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
