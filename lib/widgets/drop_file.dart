// import 'package:code_lab_web/constant/constant.dart';
// import 'package:code_lab_web/controllers/database_controller.dart';
// import 'package:code_lab_web/widgets/custom_button.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// class DropFile extends StatefulWidget {
//   const DropFile({super.key});

//   @override
//   State<DropFile> createState() => _BannerScreenState();
// }

// String? filePath;
// // var str = 'file  nhi hh';
// FilePickerResult? pickedFile;

// class _BannerScreenState extends State<DropFile> {
//   @override
//   Widget build(BuildContext context) {
//     final dbcontroller = Get.put(DatabaseController());
//     return Container(
//       width: Get.width,
//       child: Center(
//         child: Container(
//           width: 500,
//           height: 200,
//           decoration: BoxDecoration(color: Colors.grey.shade200),
//           alignment: Alignment.center,
//           child: DottedBorder(
//             radius: const Radius.circular(8),
//             borderType: BorderType.RRect,
//             dashPattern: const [5, 5],
//             child: SizedBox(
//               width: 500,
//               child: Center(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   filePath != null
//                       ? Text(filePath.toString())
//                       : const Text("No Image"),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                       onPressed: () async {
//                         pickedFile = await FilePicker.platform.pickFiles();

//                         if (pickedFile != null) {
//                           setState(() {
//                             filePath = pickedFile?.files[0].name;
//                           });
//                         }
//                       },
//                       child: const Text("Upload")),
//                 ],
//               )),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
