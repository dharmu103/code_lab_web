import 'package:code_lab_web/constant/constant.dart';
import 'package:code_lab_web/controllers/banner_controller.dart';
import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:code_lab_web/models/banner_list_model.dart';
import 'package:code_lab_web/services/remote_services.dart';
import 'package:code_lab_web/widgets/drop_file.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../widgets/custom_button.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

// var str = 'file  nhi hh';

class _BannerScreenState extends State<BannerScreen> {
  PlatformFile? pickedFile;
  @override
  Widget build(BuildContext context) {
    final dbcontroller = Get.put(DatabaseController());
    final bannercontroller = Get.put(BannerController());
    return SizedBox(
        width: Get.width,
        child: FutureBuilder<BannerList?>(
            future: dbcontroller.fatchBanner(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 3),
                    itemCount: (snapshot.data?.banner?.length ?? 0) + 1,
                    shrinkWrap: true,
                    itemBuilder: (b, index) {
                      if ((snapshot.data?.banner?.length ?? 0) == index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Column(
                              children: [
                                Expanded(
                                  child: DottedBorder(
                                    radius: const Radius.circular(8),
                                    borderType: BorderType.RRect,
                                    dashPattern: const [5, 5],
                                    child: SizedBox(
                                      height: Get.height,
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Text("${controller.uploadFormStoreData.value?.logo} data"),
                                          // imageLink != null
                                          //     ? Image.network(
                                          //         imageLink!,
                                          //         errorBuilder: (context, error, stackTrace) {
                                          //           return Text(imageLink!);
                                          //         },
                                          //       )
                                          //     : pickedFile?.name != null
                                          //         ? Text(pickedFile!.name)
                                          //         : const Text("No Image"),
                                          GetBuilder<DatabaseController>(
                                              builder: (_) {
                                            if (pickedFile?.name != null) {
                                              return Text(pickedFile!.name);
                                            } else {
                                              return const Text("No Image");
                                            }

                                            // return pickedFile?.name != null
                                            //     ? Text(pickedFile!.name)
                                            //     : const Text("No Image");
                                          }),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                var obj = await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                  withReadStream: true,
                                                );
                                                if (obj != null) {
                                                  setState(() {
                                                    pickedFile =
                                                        obj.files.single;
                                                  });
                                                  print(pickedFile!.name);
                                                }
                                              },
                                              child: const Text("Select")),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetBuilder<DatabaseController>(
                                  initState: (_) {},
                                  builder: (_) {
                                    return PrimaryButton(
                                        onpress: () async {
                                          await dbcontroller.uploadBanner(
                                              {"image": pickedFile});
                                          setState(() {
                                            pickedFile = null;
                                          });
                                        },
                                        text: "Upload",
                                        state: dbcontroller.btnState);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Card(
                              child: Container(
                                decoration: const BoxDecoration(),
                                height: 200,
                                width: Get.width,
                                child: Image.network(
                                  '${snapshot.data!.banner?[index]!.image.toString()}',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                                right: 20,
                                top: 20,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      dbcontroller.deleteBanner(
                                          snapshot.data!.banner![index]?.sId);
                                      setState(() {});
                                    },
                                    style: IconButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        backgroundColor: Colors.white),
                                    child: const Icon(
                                      CupertinoIcons.delete,
                                      color: primaryColor,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      );
                    });
              }
              return const Text("data");
            }));
  }
}
