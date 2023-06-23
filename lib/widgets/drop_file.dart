import 'package:code_lab_web/constant/constant.dart';
import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:code_lab_web/widgets/custom_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import 'package:get/get.dart';
import 'package:universal_io/io.dart';

class DropFile extends StatefulWidget {
  const DropFile({super.key});

  @override
  State<DropFile> createState() => _BannerScreenState();
}

String? filePath;
// var str = 'file  nhi hh';

class _BannerScreenState extends State<DropFile> {
  @override
  Widget build(BuildContext context) {
    late DropzoneViewController controller;
    final dbcontroller = Get.put(DatabaseController());
    return Container(
      width: Get.width,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: defaultPadding * 2,
            ),
            // Text(str),

            Container(
              width: 500,
              height: 200,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  DropzoneView(
                    operation: DragOperation.copy,
                    cursor: CursorType.grab,
                    onCreated: (DropzoneViewController ctrl) {
                      controller = ctrl;
                    },
                    onLoaded: () => print('Zone loaded'),
                    onError: (String? ev) => print('Error: $ev'),
                    onHover: () => print('Zone hovered'),
                    onDrop: (dynamic ev) async {
                      filePath = await controller.createFileUrl(ev);
                      setState(() {});
                    },
                    // onDropMultiple: (List<dynamic> ev) => print('Drop multiple: $ev'),
                    onLeave: () => print('Zone left'),
                  ),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: SizedBox(
                      width: 500,
                      height: 200,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          filePath != null
                              ? Text(filePath.toString())
                              : const Text("No Image"),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                var files = await controller.pickFiles();
                                var l = await controller.getFileData(files[0]);
                                // print(l);
                                filePath =
                                    await controller.createFileUrl(files[0]);
                                setState(() {});
                              },
                              child: const Text("Upload")),
                        ],
                      )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 500,
              child: GetBuilder<DatabaseController>(builder: (_) {
                return PrimaryButton(
                  text: "Upload Banner",
                  state: _.btnState,
                  onpress: () {
                    if (filePath != null) {
                      _.uploadBanner({"image": File(filePath!)});
                    }
                  },
                );
              }),
            ) // FlutterDropzoneView(viewId)
          ],
        ),
      ),
    );
  }
}
