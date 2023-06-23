import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:code_lab_web/models/deals_list.dart';
import 'package:code_lab_web/models/store_list.dart';
import 'package:code_lab_web/screens/banner_screen.dart';
import 'package:code_lab_web/widgets/custom_button.dart';
import 'package:code_lab_web/widgets/text_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constant/constant.dart';
import '../models/country_model.dart';

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
                  Text(controller.currentStore ?? ""),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: controller.pageNo.value > 4
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              _.addDataFormPage();
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
                return const AddDealForm();
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
                          return Row(
                            children: [
                              dealsTableWidget(snapshot.data!),
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
                        Get.dialog(const Center(
                          child: CircularProgressIndicator(),
                        ));
                        var res = await _
                            .addCountry({"name": countryController.text});
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
  TextEditingController storenameController = TextEditingController();
  TextEditingController nameArabicController = TextEditingController();
  TextEditingController linkController = TextEditingController();
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
          BannerScreen(),
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
                        if (formKey2.currentState!.validate()) {
                          Get.dialog(const Center(
                            child: CircularProgressIndicator(),
                          ));
                          var res = await _.addStore({
                            "country": _.currentCuntry,
                            "name": storenameController.text,
                            "name_arabic": nameArabicController.text,
                            "link": linkController.text,
                            "tags": []
                          });
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
                      text: "Add to DB");
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
  const AddDealForm({super.key});

  @override
  State<AddDealForm> createState() => _AddDealFormState();
}

class _AddDealFormState extends State<AddDealForm> {
  TextEditingController dealnameController = TextEditingController();
  TextEditingController dealLinkController = TextEditingController();
  TextEditingController dealnamArabiceController = TextEditingController();
  TextEditingController storeDealController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController desArabicController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _formKeyDeal = GlobalKey<FormState>();
    return Form(
      key: _formKeyDeal,
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
          BannerScreen(),
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
                    if (_formKeyDeal.currentState!.validate()) {
                      Get.dialog(const Center(
                        child: CircularProgressIndicator(),
                      ));
                      var res = await _.addDeals({
                        "store": _.currentStore,
                        "name": dealnameController.text,
                        "name_arabic": dealnamArabiceController.text,
                        "link": dealLinkController.text,
                        "tags": [],
                        "coupon": couponController.text,
                        "description": desController.text,
                        "description_arabic": desArabicController.text
                      });
                      Get.back();
                      if (res == "Success") {
                        await Future.delayed(const Duration(seconds: 2));
                        _.backPage();
                        _.btnState = ButtonState.idle;

                        _formKeyDeal.currentState!.reset();
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
                              IconButton(
                                icon: const Icon(
                                  CupertinoIcons.delete,
                                  size: 16,
                                ),
                                onPressed: () async {
                                  Get.dialog(const Center(
                                      child: CircularProgressIndicator()));
                                  String? res =
                                      await Get.find<DatabaseController>()
                                          .removeStore({
                                    "store": storeList.stores![index].id
                                  });
                                  if (res == 'Success') {
                                    Get.back();
                                  } else {
                                    Get.defaultDialog(title: "Error");
                                  }
                                },
                              ),
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
                              IconButton(
                                icon: const Icon(
                                  CupertinoIcons.delete,
                                  size: 16,
                                ),
                                onPressed: () async {
                                  Get.dialog(const Center(
                                      child: CircularProgressIndicator()));
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
                              ),
                            ],
                          ))
                        ]))),
      ),
      // ),
    );

Widget dealsTableWidget(DealsList dealsList) => SizedBox(
      width: Get.width * 0.8,
      child: DataTable(

          // columnSpacing: defaultPadding,
          border: TableBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
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
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Name Arabic")),
            DataColumn(label: Text("Description")),
            DataColumn(label: Text("Description Arabic")),
            DataColumn(label: Text("Coupon")),
            DataColumn(label: Text("Link")),
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
                            dealsList.dealsList![index].description.toString(),
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
                          Text(
                            dealsList.dealsList![index].link.toString(),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                CupertinoIcons.delete,
                                size: 16,
                              ),
                              onPressed: () async {
                                Get.dialog(const Center(
                                    child: CircularProgressIndicator()));
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
                            ),
                          ],
                        ))
                      ]))),
    );
