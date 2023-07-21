import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:code_lab_web/models/deals_list.dart';
import 'package:code_lab_web/models/deals_model.dart';
import 'package:code_lab_web/models/store_list.dart';
import 'package:code_lab_web/screens/banner_screen.dart';
import 'package:code_lab_web/widgets/custom_button.dart';
import 'package:code_lab_web/widgets/text_fields.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../constant/constant.dart';
import '../models/country_model.dart';
import '../models/store_model.dart';

class DatabaseScreen extends StatelessWidget {
  const DatabaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DatabaseController());

    // const List<DataColumn> controller.storeList = [
    //   DataColumn(label: Text("Store")),
    //   DataColumn(label: Text("Id")),
    //   DataColumn(label: Text("Store")),
    //   DataColumn(label: Text("Id"))
    // ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text("Country"),

            // controller.storeList.stores?.length == 0
            //     ? Container()
            //     :
            // Container(child: storeTableWidget(controller.storeList))
            // controller.storeList.stores?.length == null
            //     ? Container()
            //     : storeTableWidget(controller.storeList)
            GetBuilder<DatabaseController>(builder: (_) {
              return Row(
                children: [
                  BackButton(
                    onPressed: () => _.backPage(),
                  ),
                  Text(controller.currentCuntry ?? ""),
                  const Text(" / "),
                  Text(controller.currentStoreTitle ?? ""),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: controller.pageNo.value > 4
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              _.addDataFormPage(controller.pageNo.value == 0
                                  ? CountryModel().obs
                                  : controller.pageNo.value == 1
                                      ? StoreModel().obs
                                      : DealsModel().obs);
                            },
                            child: controller.pageNo.value == 0
                                ? const Text("Add Country")
                                : controller.pageNo.value == 1
                                    ? const Text("Add Store")
                                    : controller.pageNo.value == 2
                                        ? const Text("Add Deals")
                                        : SizedBox(
                                            child: Text(controller.pageNo.value
                                                .toString()),
                                          )),
                  ),
                  const SizedBox(
                    width: defaultPadding * 2,
                  )
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),

            GetBuilder<DatabaseController>(builder: (_) {
              if (_.pageNo.value == 11) {
                return const AddStoreForm();
              }
              if (_.pageNo.value == 12) {
                return AddDealForm();
              }
              if (_.pageNo.value == 10) {
                return const AddCountryForm();
              }
              if (_.pageNo.value == 2) {
                return SizedBox(
                  width: Get.width * 0.8,
                  child: FutureBuilder<DealsList?>(
                      future: controller.fatchDeals(),
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
                          if (snapshot.data?.dealsList == []) {
                            return const Text("No Deals Found");
                          }
                          return Scrollbar(
                            thumbVisibility: true,
                            controller: ScrollController(),
                            child: SingleChildScrollView(
                              controller: ScrollController(),
                              scrollDirection: Axis.horizontal,
                              child: dealsTableWidget(snapshot.data!),
                            ),
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
              if (_.pageNo.value == 1) {
                return FutureBuilder<StoreList?>(
                    future: controller.fatchStore(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        const Center(
                          child: Text("Waiting"),
                        );
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data?.stores == []) {
                          return const Text("No Store Found");
                        }
                        return Row(
                          children: [
                            storeTableWidget(snapshot.data!),
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
              }
              return FutureBuilder(
                  future: controller.fatchCountry(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      const Center(
                        child: Text("Waiting"),
                      );
                    }
                    if (snapshot.hasData) {
                      return Container(
                          child: countryTableWidget(snapshot.data!));
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
            })
          ],
        ),
      ),
    );
  }
}

class AddCountryForm extends StatefulWidget {
  const AddCountryForm({super.key});

  @override
  State<AddCountryForm> createState() => _AddCountryFormState();
}

final _formKey = GlobalKey<FormState>();

class _AddCountryFormState extends State<AddCountryForm> {
  TextEditingController countryController = TextEditingController();
  final c = Get.find<DatabaseController>();
  @override
  void initState() {
    countryController.text = c.updateFormCountryData.value.countryName ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
            width: 500,
            child: textFields(countryController, "country name"),
          ),
          const SizedBox(
            height: 30,
          ),
          // BannerScreen(),
          SizedBox(
              width: 500,
              height: 40,
              child: GetBuilder<DatabaseController>(
                init: DatabaseController(),
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
                        if (_.updateFormCountryData.value.countryName != null) {
                          res = await _.addCountry({
                            "name": _.updateFormCountryData.value.countryName,
                            "new_name": countryController.text
                          });
                        } else {
                          res = await _
                              .addCountry({"name": countryController.text});
                        }

                        Get.back();
                        if (res == "Success") {
                          await Future.delayed(const Duration(seconds: 2));
                          _.backPage();
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
        ],
      ),
    );
  }
}

class AddStoreForm extends StatefulWidget {
  const AddStoreForm({super.key});

  @override
  State<AddStoreForm> createState() => _AddStoreFormState();
}

class _AddStoreFormState extends State<AddStoreForm> {
  PlatformFile? pickedFile;
  String? imageLink;
  TextEditingController storenameController = TextEditingController();
  TextEditingController nameArabicController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  final controller = Get.find<DatabaseController>();
  @override
  void initState() {
    storenameController.text = controller.uploadFormStoreData.value?.name ?? "";
    nameArabicController.text =
        controller.uploadFormStoreData.value?.arabicName ?? "";
    nameArabicController.text =
        controller.uploadFormStoreData.value?.arabicName ?? "";
    linkController.text = controller.uploadFormStoreData.value?.link ?? "";
    imageLink = controller.uploadFormStoreData.value?.logo ?? "";
    print(imageLink);
    print(controller.uploadFormStoreData.value?.logo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey2 = GlobalKey<FormState>();
    return Form(
      key: formKey2,
      child: Column(
        children: [
          const SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
            width: 500,
            child: textFields(storenameController, "name"),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 500,
            child: textFields(nameArabicController, "name arabic"),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 500,
            child: textFields(linkController, "link"),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 500,
            height: 200,
            decoration: BoxDecoration(color: Colors.grey.shade200),
            alignment: Alignment.center,
            child: DottedBorder(
              radius: const Radius.circular(8),
              borderType: BorderType.RRect,
              dashPattern: const [5, 5],
              child: SizedBox(
                width: 500,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    GetBuilder<DatabaseController>(builder: (_) {
                      if (pickedFile?.name != null) {
                        return Text(pickedFile!.name);
                      }
                      if (_.uploadFormStoreData != StoreModel().obs) {
                        return Text(
                            _.uploadFormStoreData.value?.logo ?? "No Image");
                      }
                      return pickedFile?.name != null
                          ? Text(pickedFile!.name)
                          : const Text("No Image");
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var obj = await FilePicker.platform.pickFiles(
                            withReadStream: true,
                          );
                          if (obj != null) {
                            setState(() {
                              pickedFile = obj.files.single;
                            });
                            print(pickedFile!.name);
                          }
                        },
                        child: const Text("Upload")),
                  ],
                )),
              ),
            ),
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          SizedBox(
              width: 500,
              height: 40,
              child: GetBuilder<DatabaseController>(
                init: DatabaseController(),
                initState: (_) {},
                builder: (_) {
                  return PrimaryButton(
                      state: _.btnState,
                      onpress: () async {
                        var res;
                        if (formKey2.currentState!.validate()) {
                          Get.dialog(const Center(
                            child: CircularProgressIndicator(),
                          ));
                          if (controller.uploadFormStoreData.value?.name ==
                              null) {
                            res = await _.addStore({
                              "country": _.currentCuntry,
                              "name": storenameController.text,
                              "name_arabic": nameArabicController.text,
                              "link": linkController.text,
                              "tags": []
                            }, pickedFile);
                          } else {
                            res = await _.addStore({
                              "store_id":
                                  controller.uploadFormStoreData.value?.id,
                              "country": _.currentCuntry,
                              "name": storenameController.text,
                              "name_arabic": nameArabicController.text,
                              "link": linkController.text,
                              "tags": [],
                              "logo": controller.uploadFormStoreData.value?.logo
                            }, pickedFile);
                          }
                          Get.back();
                          if (res == "Success") {
                            await Future.delayed(const Duration(seconds: 2));
                            _.backPage();
                            _.btnState = ButtonState.idle;
                          }
                        } else {
                          Get.defaultDialog(
                              title: "Error",
                              titleStyle: const TextStyle(color: Colors.red),
                              content: const Text("Not added in Database"));
                        }
                      },
                      text: _.uploadFormStoreData.value?.logo == null
                          ? "Add to DB"
                          : "Update");
                },
              )),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class AddDealForm extends StatefulWidget {
  AddDealForm({
    super.key,
  });

  @override
  State<AddDealForm> createState() => _AddDealFormState();
}

class _AddDealFormState extends State<AddDealForm> {
  PlatformFile? pickedFile;
  TextEditingController dealnameController = TextEditingController();
  TextEditingController dealLinkController = TextEditingController();
  TextEditingController dealnamArabiceController = TextEditingController();
  TextEditingController storeDealController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController desArabicController = TextEditingController();
  TextEditingController lastUsedController = TextEditingController();
  TextEditingController usedController = TextEditingController();
  final controller = Get.find<DatabaseController>();
  List<String?>? tags = [];

  @override
  void initState() {
    dealnameController.text = controller.updateFormDealData.value?.name ?? "";
    dealLinkController.text = controller.updateFormDealData.value?.link ?? "";
    dealnamArabiceController.text =
        controller.updateFormDealData.value?.arabicName ?? "";
    //  storeDealController.text = controller.updateFormDealData.value?.storeId ?? "";
    couponController.text = controller.updateFormDealData.value?.coupon ?? "";
    desController.text = controller.updateFormDealData.value?.description ?? "";
    desArabicController.text =
        controller.updateFormDealData.value?.arabicDescription ?? "";
    lastUsedController.text =
        controller.updateFormDealData.value?.lastused.toString() ?? "";
    usedController.text =
        controller.updateFormDealData.value?.usedtimes.toString() ?? "";
    tags = controller.updateFormDealData.value?.tags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKeyDeal = GlobalKey<FormState>();
    final _items = controller.categories?.categories!
        .map((e) => MultiSelectItem(e.name.toString(), e.name.toString()))
        .toList();
    return Material(
      child: Form(
        key: formKeyDeal,
        child: Column(
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            SizedBox(
              width: 500,
              child: textFields(dealnameController, "name"),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 500,
              child: textFields(dealnamArabiceController, "name arabic"),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 500,
              child: textFields(desController, "description"),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 500,
              child: textFields(desArabicController, "description arabic"),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 500,
              child: textFields(dealLinkController, "link"),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 500,
              child: textFields(couponController, "coupon"),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 500,
              child: textFields(lastUsedController, "Last used"),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 500,
              child: textFields(usedController, "used times"),
            ),
            const SizedBox(
              height: 30,
            ),
            // SizedBox(
            //   width: 500,
            //   child: DropDownTextField.multiSelection(
            //     controller: _cntMulti,
            //     checkBoxProperty: CheckBoxProperty(tristate: true),
            //     displayCompleteItem: true,
            //     initialValue: tags,
            //     dropDownList: List.generate(
            //         controller.categories?.categories?.length ?? 0,
            //         (index) => DropDownValueModel(
            //             name: controller.categories!.categories![index],
            //             value: controller.categories!.categories![index])),
            //     clearOption: true,
            //     onChanged: (val) {
            //       setState(() {});
            //     },
            //   ),
            // // ),
            // SizedBox(
            //   child: textFields(null, "Tags"),
            // ),
            SizedBox(
              width: 500,
              child: MultiSelectChipField<String?>(
                items: _items!,
                initialValue: tags ?? [],
                title: const Text("Tags"),
                headerColor: Colors.grey.withOpacity(0.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.8),
                ),
                selectedChipColor: Colors.blue.withOpacity(0.5),
                selectedTextStyle: TextStyle(color: Colors.blue[800]),
                onTap: (values) {
                  tags = values;
                  print(tags);
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 500,
              height: 200,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              alignment: Alignment.center,
              child: DottedBorder(
                radius: const Radius.circular(8),
                borderType: BorderType.RRect,
                dashPattern: const [5, 5],
                child: SizedBox(
                  width: 500,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetBuilder<DatabaseController>(builder: (_) {
                        if (pickedFile?.name != null) {
                          return Text(pickedFile!.name);
                        }
                        if (controller.updateFormDealData != DealsModel().obs) {
                          return Text(
                              _.updateFormDealData.value?.image ?? "No Image");
                        }
                        return pickedFile?.name != null
                            ? Text(pickedFile!.name)
                            : const Text("No Image");
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var obj = await FilePicker.platform.pickFiles(
                              withReadStream: true,
                            );
                            if (obj != null) {
                              setState(() {
                                pickedFile = obj.files.single;
                              });
                              print(pickedFile!.bytes);
                            }
                          },
                          child: const Text("Upload")),
                    ],
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            SizedBox(
                width: 500,
                height: 40,
                child: GetBuilder<DatabaseController>(builder: (_) {
                  // return ElevatedButton(
                  // onPressed: () async {
                  //   if (_formKeyDeal.currentState!.validate()) {
                  //     var res = await RemoteService.addDeals({
                  //       "store": _.currentStore,
                  //       "name": dealnameController.text,
                  //       "name_arabic": dealnamArabiceController.text,
                  //       "link": dealLinkController.text,
                  //       "tags": [],
                  //       "coupon": couponController.text,
                  //       "description": desController.text,
                  //       "description_arabic": desArabicController.text
                  //     });
                  //     if (res == "Success") {
                  //       Get.defaultDialog(
                  //           title: "Successfully Added",
                  //           content: Text(
                  //               "${dealnameController.text} added in Database"));
                  //     }
                  //   }
                  // },
                  //     child: const Text("Add to DB"));

                  return PrimaryButton(
                    text: "Add to DB",
                    state: _.btnState,
                    onpress: () async {
                      if (formKeyDeal.currentState!.validate()) {
                        var res;
                        Get.dialog(const Center(
                          child: CircularProgressIndicator(),
                        ));
                        if (controller.updateFormDealData.value?.name == null) {
                          res = await _.addDeals({
                            "store": _.currentStore,
                            "name": dealnameController.text,
                            "name_arabic": dealnamArabiceController.text,
                            "link": dealLinkController.text,
                            "tags": tags,
                            "coupon": couponController.text,
                            "description": desController.text,
                            "description_arabic": desArabicController.text,
                            "used_times": usedController.text,
                            "last_used": lastUsedController.text,
                          }, pickedFile);
                        } else {
                          res = await _.addDeals({
                            "deal_id": controller.updateFormDealData.value?.id,
                            "image": controller.updateFormDealData.value?.image,
                            "store": _.currentStore,
                            "name": dealnameController.text,
                            "name_arabic": dealnamArabiceController.text,
                            "link": dealLinkController.text,
                            "tags": tags,
                            "coupon": couponController.text,
                            "description": desController.text,
                            "description_arabic": desArabicController.text,
                            "used_times": usedController.text,
                            "last_used": lastUsedController.text,
                          }, pickedFile);
                        }

                        Get.back();
                        if (res == "Success") {
                          // await Future.delayed(const Duration(seconds: 2));
                          _.backPage();
                          _.btnState = ButtonState.idle;

                          formKeyDeal.currentState!.reset();
                        }
                      }
                    },
                  );
                })),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

Widget storeTableWidget(StoreList storeList) => SizedBox(
      width: Get.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DataTable(

            // columnSpacing: defaultPadding,
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
              DataColumn(label: Text("Store-Logo")),
              DataColumn(label: Text("Store")),
              DataColumn(label: Text("Arabic Name")),
              DataColumn(label: Text("Country")),
              DataColumn(label: Text("Link")),
              DataColumn(label: Text("")),
            ],
            rows: List.generate(
                storeList.stores!.length,
                (index) => DataRow(
                        onSelectChanged: (v) {
                          Get.find<DatabaseController>()
                              .nextDealsPage(storeList.stores![index]);
                        },
                        cells: [
                          DataCell(
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                width: 100,
                                height: 50,
                                child: Image.network(
                                  storeList.stores![index].logo.toString(),
                                  width: 70,
                                  height: 50,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              storeList.stores![index].name.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              storeList.stores![index].arabicName.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              storeList.stores![index].country.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              storeList.stores![index].link.toString(),
                            ),
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
                              //     Get.dialog(const Center(
                              //         child: CircularProgressIndicator()));
                              //     String? res =
                              //         await Get.find<DatabaseController>()
                              //             .removeStore({
                              //       "store": storeList.stores![index].id
                              //     });
                              //     if (res == 'Success') {
                              //       Get.back();
                              //     } else {
                              //       Get.defaultDialog(title: "Error");
                              //     }
                              //   },
                              // ),
                              PopupMenuButton(
                                  onSelected: (v) {},
                                  itemBuilder: (itemBuilder) {
                                    return [
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                              onTap: () {
                                                Get.find<DatabaseController>()
                                                    .addDataFormPage(storeList
                                                        .stores![index].obs);
                                                Get.back();
                                              },
                                              title: const Text(
                                                "Update",
                                              ))),
                                      PopupMenuItem(
                                          value: 2,
                                          onTap: () async {
                                            Get.dialog(const Center(
                                                child:
                                                    CircularProgressIndicator()));
                                            String? res = await Get.find<
                                                    DatabaseController>()
                                                .removeStore({
                                              "store":
                                                  storeList.stores![index].id
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
    );
Widget countryTableWidget(List<CountryModel> countryList) => SizedBox(
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
                countryList.length,
                (index) => DataRow(
                        // onLongPress: () {
                        //   Get.find<DatabaseController>()
                        //       .nextPage(countryList[index]);
                        // },
                        onSelectChanged: (v) {
                          Get.find<DatabaseController>()
                              .nextPage(countryList[index]);
                        },
                        cells: [
                          DataCell(
                            Text(countryList[index].countryName.toString()),
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
                                  PopupMenuItem(
                                      child: ListTile(
                                          onTap: () {
                                            Get.find<DatabaseController>()
                                                .addDataFormPage(
                                                    countryList[index].obs);
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
                                            await Get.find<DatabaseController>()
                                                .removeCountry({
                                          "name": countryList[index].countryName
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

Widget dealsTableWidget(DealsList dealsList) => SizedBox(
      child: SingleChildScrollView(
        child: DataTable(

            // columnSpacing: defaultPadding,
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
              DataColumn(label: Text("Image")),
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Name Arabic")),
              DataColumn(label: Text("Description")),
              DataColumn(label: Text("Description Arabic")),
              DataColumn(label: Text("Coupon")),
              DataColumn(label: Text("Link")),
              DataColumn(label: Text("Last Used")),
              DataColumn(label: Text("Used Times")),
              DataColumn(label: Text("Tags")),
              DataColumn(label: Text("")),
            ],
            rows: List.generate(
                dealsList.dealsList!.length,
                (index) => DataRow(

                        // onLongPress: () {

                        //   Get.find<DatabaseController>()

                        //       .nextDealsPage(dealsList.dealsList![index]);

                        // },

                        cells: [
                          DataCell(
                            Image.network(
                              dealsList.dealsList![index].image.toString(),
                              width: 70,
                              height: 50,
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].name.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].arabicName.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].description
                                  .toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].arabicDescription
                                  .toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].coupon.toString(),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: Tooltip(
                                message:
                                    dealsList.dealsList![index].link.toString(),
                                child: Text(
                                  dealsList.dealsList![index].link.toString(),
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].lastused ?? "-",
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].usedtimes ?? "-",
                            ),
                          ),
                          DataCell(
                            Text(
                              dealsList.dealsList![index].tags.toString(),
                            ),
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
                              //     Get.dialog(const Center(
                              //         child: CircularProgressIndicator()));
                              //     String? res =
                              //         await Get.find<DatabaseController>()
                              //             .removeDeal({
                              //       "deal": dealsList.dealsList![index].id
                              //     });
                              //     if (res == 'Success') {
                              //       Get.back();
                              //     } else {
                              //       Get.defaultDialog(title: "Error");
                              //     }
                              //   },
                              // ),
                              PopupMenuButton(itemBuilder: (itemBuilder) {
                                return [
                                  PopupMenuItem(
                                      child: ListTile(
                                          onTap: () {
                                            Get.find<DatabaseController>()
                                                .addDataFormPage(dealsList
                                                    .dealsList![index].obs);
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
                                            await Get.find<DatabaseController>()
                                                .removeDeal({
                                          "deal": dealsList.dealsList![index].id
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
    );
