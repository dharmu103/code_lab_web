import 'package:code_lab_web/constant/constant.dart';
import 'package:code_lab_web/models/tags_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../controllers/carousel_controller.dart';
import '../controllers/database_controller.dart';
import '../controllers/tags_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_fields.dart';

class TagScreen extends StatelessWidget {
  const TagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(TagController());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<TagController>(builder: (_) {
              return Row(children: [
                BackButton(
                  onPressed: () => _.backPage(),
                ),
                // Text(c.currentCountry.countryName ?? ""),
                // const Text(" / "),
                // Text(controller.currentStore ?? ""),
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: c.currentPage == 1
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              c.addTagPage();
                            },
                            child: const Text("Add Tag"),
                          )),
                const SizedBox(
                  width: defaultPadding * 2,
                ),
              ]);
            }),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<TagController>(builder: (_) {
              if (_.currentPage == 1) {
                return const AddTagScreen();
              }

              if (_.currentPage == 0) {
                return Container(
                  width: Get.width * 0.8,
                  child: FutureBuilder<TagsList?>(
                      future: _.fatchCategory(),
                      builder: (context, snapshot) {
                        // if (snapshot.data == null) {
                        //   return Text("null");
                        // }
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
                          if (snapshot.data?.categories == []) {
                            return const Text("No Users Found");
                          }
                          return Row(
                            children: [
                              tagTableWidget(snapshot.data!.categories!),
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
                      }),
                );
              }
              return const Text("data");
            })
          ],
        ),
      ),
    );
  }
}

Widget tagTableWidget(List<Categories> tags) => SizedBox(
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
              DataColumn(label: Text("Tag")),
              DataColumn(label: Text("Tag-Arabic")),
              DataColumn(label: Text("")),
            ],
            rows: List.generate(
                tags.length,
                (index) => DataRow(
                        // onLongPress: () {
                        //   Get.find<TagController>()
                        //       .nextPage(countryList[index]);
                        // },
                        onSelectChanged: (v) {
                          // Get.find<TagController>()
                          //     .nextPage(countryList[index]);
                        },
                        cells: [
                          DataCell(
                            Text(tags[index].name.toString()),
                          ),
                          DataCell(
                            Text(tags[index].nameArabic.toString()),
                          ),
                          DataCell(Row(
                            children: [
                              Spacer(),
                              // IconButton(
                              //   icon: const Icon(
                              //     CupertinoIcons.delete,
                              //     size: 16,
                              //   ),
                              //   onPressed: () async {
                              // Get.dialog(const Center(
                              //     child: CircularProgressIndicator()));
                              // String? res =
                              //     await Get.find<TagController>()
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
                                  PopupMenuItem(
                                      child: ListTile(
                                          onTap: () {
                                            Get.find<TagController>()
                                                .addDataFormPage(tags[index]);
                                            Get.back();
                                          },
                                          title: const Text(
                                            "Update",
                                          ))),
                                  PopupMenuItem(
                                      onTap: () async {
                                        Get.dialog(const Center(
                                            child:
                                                CircularProgressIndicator()));
                                        String? res =
                                            await Get.find<TagController>()
                                                .removeTag({
                                          "category_id": tags[index].sId
                                        });
                                        if (res == 'Success') {
                                          Get.back();
                                        } else {
                                          print(res);
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

class AddTagScreen extends StatefulWidget {
  const AddTagScreen({super.key});

  @override
  State<AddTagScreen> createState() => _AddCarouselScreenState();
}

TextEditingController hController = TextEditingController();
TextEditingController harabicController = TextEditingController();
final c = Get.find<TagController>();

class _AddCarouselScreenState extends State<AddTagScreen> {
  @override
  void initState() {
    hController.text = c.updateCatagory?.name ?? "";
    harabicController.text = c.updateCatagory?.nameArabic ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _addCatFormKey = GlobalKey<FormState>();
    return Form(
      key: _addCatFormKey,
      child: Column(
        children: [
          SizedBox(
            width: 500,
            child: textFields(hController, "Tag"),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 500,
            child: textFields(harabicController, "Tag-Arabic"),
          ),
          const SizedBox(
            height: 30,
          ),
          GetBuilder<TagController>(
            init: TagController(),
            initState: (_) {},
            builder: (_) {
              return SizedBox(
                  width: 500,
                  child: PrimaryButton(
                    text: "Add to Db",
                    state: _.btnState,
                    onpress: () async {
                      if (_addCatFormKey.currentState!.validate()) {
                        if (_.updateCatagory?.name != null) {
                          print("update");
                          await _.updateCategery({
                            "name": hController.text,
                            "name_arabic": harabicController.text,
                            "category_id": _.updateCatagory?.sId
                          });
                        } else {
                          print("add");
                          await _.addCategery({
                            "name": hController.text,
                            "name_arabic": harabicController.text
                          });
                        }
                        await Future.delayed(const Duration(seconds: 2));
                        _.backPage();
                        _.btnState = ButtonState.idle;
                      }
                    },
                  ));
            },
          )
        ],
      ),
    );
  }
}
