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
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/ll.png"),
          ),
          DrawerListTile(
            title: "Database",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              controller.changeIndex(0);
              print(controller.currentPage.value);
            },
          ),
          // DrawerListTile(
          //   title: "Store",
          //   svgSrc: "assets/icons/menu_setting.svg",
          //   press: () {
          //     controller.changeIndex(1);
          //   },
          // ),
          // DrawerListTile(
          //   title: "Deals",
          //   svgSrc: "assets/icons/country-5.svg",
          //   press: () {
          //     controller.changeIndex(2);
          //     print(controller.currentPage.value);
          //   },
          // ),
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
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
