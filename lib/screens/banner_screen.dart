import 'package:code_lab_web/constant/constant.dart';
import 'package:code_lab_web/controllers/banner_controller.dart';
import 'package:code_lab_web/controllers/carousel_controller.dart';
import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:code_lab_web/models/banner_list_model.dart';
import 'package:code_lab_web/models/country_model.dart';
import 'package:code_lab_web/models/store_model.dart';
import 'package:code_lab_web/services/remote_services.dart';
import 'package:code_lab_web/widgets/drop_file.dart';
import 'package:code_lab_web/widgets/text_fields.dart';
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
    return Scrollbar(
      trackVisibility: true,
      thickness: 20,
      child: Container(
          width: Get.width,
          padding: EdgeInsets.all(25),
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
                      clipBehavior: Clip.none,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 2),
                      itemCount: (snapshot.data?.banner?.length ?? 0) + 1,
                      shrinkWrap: true,
                      itemBuilder: (b, index) {
                        if ((snapshot.data?.banner?.length ?? 0) == index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  GetBuilder<BannerController>(builder: (_) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField(
                                              onChanged: (v) {
                                                print(v);
                                                _.currentCountry.countryName =
                                                    v;
                                                _.fatchStore(v);
                                              },
                                              // onSaved: (v) {
                                              //   print(v);
                                              // },
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                isDense: true,
                                                hintText: bannercontroller
                                                        .currentCountry
                                                        .countryName ??
                                                    "Select Country",
                                                border:
                                                    const OutlineInputBorder(
                                                        // borderRadius: BorderRadius.circular(12),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black45)),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                        // borderRadius: BorderRadius.circular(12),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                              ),
                                              items: List.generate(
                                                  bannercontroller
                                                          .countryList
                                                          .countryList
                                                          ?.length ??
                                                      0,
                                                  (index) => DropdownMenuItem(
                                                      value: bannercontroller
                                                          .countryList
                                                          .countryList![index]
                                                          .countryName,
                                                      child: Text(
                                                          bannercontroller
                                                              .countryList
                                                              .countryList![
                                                                  index]
                                                              .countryName
                                                              .toString()))),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: DropdownButtonFormField(
                                              onChanged: (v) {
                                                print(v);
                                                // storeName = v!;
                                                _.currentStore.id = v;
                                                _.currentStore.name = _
                                                    .storeList?.stores
                                                    ?.singleWhere((element) =>
                                                        element.id == v)
                                                    .name;
                                              },
                                              // onSaved: (v) {
                                              //   print(v);
                                              // },
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                isDense: true,
                                                hintText: bannercontroller
                                                        .currentStore.name ??
                                                    "Select Store",
                                                border:
                                                    const OutlineInputBorder(
                                                        // borderRadius: BorderRadius.circular(12),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .black45)),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                        // borderRadius: BorderRadius.circular(12),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                              ),
                                              items: List.generate(
                                                  bannercontroller.storeList
                                                          ?.stores?.length ??
                                                      0,
                                                  (index) => DropdownMenuItem(
                                                      value: bannercontroller
                                                          .storeList!
                                                          .stores![index]
                                                          .id,
                                                      child: Text(
                                                          bannercontroller
                                                              .storeList!
                                                              .stores![index]
                                                              .name
                                                              .toString()))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(
                                    height: 20,
                                  ),
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
                                            if (bannercontroller.currentCountry
                                                        .countryName !=
                                                    null &&
                                                bannercontroller
                                                        .currentStore.id !=
                                                    null) {
                                              await dbcontroller.uploadBanner({
                                                "image": pickedFile,
                                                "country": bannercontroller
                                                        .currentCountry
                                                        .countryName ??
                                                    "None",
                                                "store": bannercontroller
                                                        .currentStore.id ??
                                                    "None"
                                              });
                                              setState(() {
                                                pickedFile = null;
                                              });
                                              bannercontroller.currentStore =
                                                  StoreModel();
                                              bannercontroller.currentCountry =
                                                  CountryModel();
                                            }
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
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GetBuilder<BannerController>(
                                  builder: (_) {
                                    return Row(
                                      children: [
                                        Expanded(
                                            child: textFieldReadOnly(
                                          '${snapshot.data!.banner?[index].country}',
                                        )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: textFieldReadOnly(
                                          '${snapshot.data!.banner?[index].storeName}',
                                        )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              dbcontroller.deleteBanner(snapshot
                                                  .data!.banner![index].sId);
                                              dbcontroller.fatchBanner();
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
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Card(
                                child: Container(
                                  decoration: const BoxDecoration(),
                                  height: 200,
                                  width: Get.width,
                                  child: Image.network(
                                    '${snapshot.data!.banner?[index].image.toString()}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //     right: 20,
                              //     top: 20,
                              //     child: Container(
                              //       height: 50,
                              //       width: 50,
                              //       child: ElevatedButton(
                              //         onPressed: () {
                              //           dbcontroller.deleteBanner(
                              //               snapshot.data!.banner![index]?.sId);
                              //           setState(() {});
                              //         },
                              //         style: IconButton.styleFrom(
                              //             foregroundColor: Colors.green,
                              //             backgroundColor: Colors.white),
                              //         child: const Icon(
                              //           CupertinoIcons.delete,
                              //           color: primaryColor,
                              //         ),
                              //       ),
                              //     ))
                            ],
                          ),
                        );
                      });
                }
                return const Text("data");
              })),
    );
  }
}
