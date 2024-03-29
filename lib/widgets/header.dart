// import 'package:admin/controllers/MenuAppController.dart';
// import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import '../constant/constant.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          // if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu), onPressed: () {},
            // onPressed: context.read<MenuAppController>().controlMenu,
          ),

          Text(
            "CODE LAB ADMIN PANEL",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          // if (!Responsive.isMobile(context))
          //   Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          // // const Expanded(child: SearchField()),
          const ProfileCard()
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        children: [
          // Image.asset(
          //   "assets/images/profile_pic.png",
          //   height: 38,
          // ),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile_pic.png"),
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Text("Admin"),
          // if (!Responsive.isMobile(context))
          //   const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          //     child: Text("Admin"),
          //   ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

// class SearchField extends StatelessWidget {
//   const SearchField({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: "Search",
//         fillColor: secondaryColor,
//         filled: true,
//         border: const OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         suffixIcon: InkWell(
//           onTap: () {},
//           child: Container(
//             padding: const EdgeInsets.all(defaultPadding * 0.75),
//             margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
//             decoration: const BoxDecoration(
//               color: primaryColor,
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             child: SvgPicture.asset("assets/icons/Search.svg"),
//           ),
//         ),
//       ),
//     );
//   }
// }
