import 'package:code_lab_web/controllers/banner_controller.dart';
import 'package:code_lab_web/controllers/carousel_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constant/constant.dart';
import '../controllers/database_controller.dart';
import '../models/carousel_list.dart';
import '../models/country_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_fields.dart';

class SliderScreen extends StatelessWidget {
  const SliderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DatabaseController());
    final c = Get.put(CarouselController());
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<CarouselController>(builder: (_) {
                return Row(children: [
                  BackButton(
                    onPressed: () => _.backPage(),
                  ),
                  Text(controller.currentCuntry ?? ""),
                  const Text(" / "),
                  Text(controller.currentStore ?? ""),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: controller.pageNo.value > 4
                          ? const SizedBox()
                          : ElevatedButton(
                              onPressed: () {
                                c.addCarouselPage();
                              },
                              child: const Text("Add Carousel"),
                            )),
                  const SizedBox(
                    width: defaultPadding * 2,
                  ),
                ]);
              }),
              GetBuilder<CarouselController>(
                init: CarouselController(),
                initState: (_) {},
                builder: (_) {
                  if (c.currentPage == 1) {
                    return const UpdateCarousel();
                  }
                  if (c.currentPage == 100) {
                    return const AddCarouselScreen();
                  }
                  return FutureBuilder(
                      future: controller.fatchcarousel(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Error");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          const Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                CircularProgressIndicator()
                              ],
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data!.carousel == null) {
                            return const Text("No Deals Found");
                          }
                          return Row(
                            children: [
                              sliderTableWidget(snapshot.data!.carousel!),
                              const Spacer()
                            ],
                          );
                        }
                        return const Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        );
                      });
                },
              ),
            ]));
  }
}

Widget sliderTableWidget(List<Carousel?> carouselList) => SizedBox(
      width: Get.width * 0.8,
      // height: Get.height,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DataTable(
            border: TableBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.grey.shade200),
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            // dataRowColor: MaterialStateColor.resolveWith(
            //     (states) => Colors.grey.shade100),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 0.2, spreadRadius: 0.5, color: Colors.grey)
                ]),
            columns: const [
              DataColumn(label: Text("Country")),
              DataColumn(label: Text("")),
            ],
            rows: List.generate(
                carouselList.length,
                (index) => DataRow(
                        // onLongPress: () {
                        //   Get.find<DatabaseController>()
                        //       .nextPage(countryList[index]);
                        // },
                        onSelectChanged: (v) {
                          Get.find<CarouselController>()
                              .nextPage(carouselList[index]);
                        },
                        cells: [
                          DataCell(
                            Text(carouselList[index]!.header.toString()),
                          ),
                          DataCell(Row(
                            children: [
                              const Spacer(),
                              // IconButton(
                              //   icon: const Icon(
                              //     CupertinoIcons.delete,
                              //     size: 16,
                              //   ),
                              //   onPressed: () async {
                              // Get.dialog(const Center(
                              //     child: CircularProgressIndicator()));
                              // String? res =
                              //     await Get.find<DatabaseController>()
                              //         .removeCountry({
                              //   "name": countryList[index].countryName
                              // });
                              // if (res == 'Success') {
                              //   Get.back();
                              // } else {
                              //   Get.defaultDialog(title: "Error");
                              // }
                              // },
                              // ),
                              PopupMenuButton(itemBuilder: (itemBuilder) {
                                return [
                                  // PopupMenuItem(
                                  //     child: ListTile(
                                  //         onTap: () {
                                  //           Get.find<CarouselController>()
                                  //               .nextPage(carouselList[index]);
                                  //           Get.back();
                                  //         },
                                  //         title: const Text(
                                  //           "Update",
                                  //         ))),
                                  PopupMenuItem(
                                      onTap: () async {
                                        Get.dialog(const Center(
                                            child:
                                                CircularProgressIndicator()));
                                        String? res =
                                            await Get.find<CarouselController>()
                                                .deleteCarousel({
                                          "carousel_id":
                                              carouselList[index]?.sId
                                        });

                                        if (res == 'Success') {
                                          Get.back();
                                        } else {
                                          Get.defaultDialog(title: "Error");
                                        }
                                      },
                                      child: const ListTile(
                                          title: Text(
                                        "Delete",
                                      )))
                                ];
                              })
                            ],
                          ))
                        ]))),
      ),
      // ),
    );

class UpdateCarousel extends StatefulWidget {
  const UpdateCarousel({super.key});

  @override
  State<UpdateCarousel> createState() => _UpdateCarouselState();
}

final c = Get.find<CarouselController>();
TextEditingController headerController = TextEditingController();

class _UpdateCarouselState extends State<UpdateCarousel> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    headerController.text = c.updatePageCarousel.header ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
            width: Get.width,
            child: textFields(headerController, "country name"),
          ),
          const SizedBox(
            height: 30,
          ),
          GetBuilder<CarouselController>(
            init: CarouselController(),
            initState: (_) {},
            builder: (_) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 3),
                  itemCount: (_.updatePageCarousel.images?.length ?? 0) + 1,
                  shrinkWrap: true,
                  itemBuilder: (b, index) {
                    if ((_.updatePageCarousel.images?.length ?? 0) == index) {
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
                                        GetBuilder<CarouselController>(
                                            builder: (_) {
                                          if (_.pickedFile?.name != null) {
                                            return Text(_.pickedFile!.name);
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
                                                  _.pickedFile =
                                                      obj.files.single;
                                                });
                                                print(_.pickedFile!.name);
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
                              // GetBuilder<DatabaseController>(
                              //   initState: (_) {},
                              //   builder: (_) {
                              //     return PrimaryButton(
                              //         // onpress: () async {
                              //         //   await dbcontroller.uploadBanner(
                              //         //       {"image": pickedFile});
                              //         //   setState(() {
                              //         //     pickedFile = null;
                              //         //   });
                              //         // },
                              //         // text: "Upload",
                              //         // state: dbcontroller.btnState);
                              //   },
                              // )
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
                                '${_.updatePageCarousel.images?[index].toString()}',
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
                          //           // dbcontroller.deleteBanner(
                          //           //     snapshot.data!.banner![index]?.sId);
                          //           // setState(() {});
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
            },
          ),
          SizedBox(
              width: Get.width,
              height: 40,
              child: GetBuilder<CarouselController>(
                initState: (_) {},
                builder: (_) {
                  return PrimaryButton(
                    state: _.btnState,
                    onpress: () async {
                      if (_formKey.currentState!.validate()) {
                        var res;
                        Get.dialog(const Center(
                          child: CircularProgressIndicator(),
                        ));
                        if (_.updatePageCarousel.header != null) {
                          _.updateCarousel(
                            headerController.text,
                          );
                        }

                        Get.back();
                        if (res == "Success") {
                          await Future.delayed(const Duration(seconds: 2));
                          // _.backPage();
                          _.pickedFile = null;
                          print("name ye ${_.pickedFile?.name}");
                          _.btnState = ButtonState.idle;
                        }
                      } else {}
                    },
                    text: "Add to DB",
                  );
                },
              )),
          const SizedBox(
            height: 30,
          ),
        ]));
  }
}

class AddCarouselScreen extends StatefulWidget {
  const AddCarouselScreen({super.key});

  @override
  State<AddCarouselScreen> createState() => _AddCarouselScreenState();
}

TextEditingController hController = TextEditingController();

class _AddCarouselScreenState extends State<AddCarouselScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 500,
          child: textFields(hController, "Header"),
        ),
        const SizedBox(
          height: 30,
        ),
        GetBuilder<CarouselController>(
          init: CarouselController(),
          initState: (_) {},
          builder: (_) {
            return SizedBox(
                width: 500,
                child: PrimaryButton(
                  text: "Add to Db",
                  state: _.btnState,
                  onpress: () async {
                    await _.addCarousel({"header": hController.text});
                    await Future.delayed(const Duration(seconds: 2));
                    _.backPage();
                    _.btnState = ButtonState.idle;
                  },
                ));
          },
        )
      ],
    );
  }
}