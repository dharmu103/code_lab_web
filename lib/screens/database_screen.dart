import 'package:code_lab_web/controllers/database_controller.dart';
import 'package:code_lab_web/models/deals_list.dart';
import 'package:code_lab_web/models/store_list.dart';
import 'package:code_lab_web/models/store_model.dart';
import 'package:code_lab_web/models/user_model.dart';
import 'package:code_lab_web/widgets/data_table.dart';
import 'package:code_lab_web/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                        ? SizedBox()
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
                                        : SizedBox()),
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
              if (_.pageNo.value == 10) {
                return const AddCountryForm();
              }
              if (_.pageNo.value == 2) {
                return Container(
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
                      return countryTableWidget(snapshot.data!);
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

class AddCountryForm extends StatelessWidget {
  const AddCountryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          width: 500,
          child: textFields(null, "country name"),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
            width: 500,
            height: 40,
            child: ElevatedButton(
                onPressed: () {}, child: const Text("Add to DB"))),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

Widget storeTableWidget(StoreList storeList) => Container(
      width: Get.width * 0.8,
      child: DataTable(

          // columnSpacing: defaultPadding,

          columns: const [
            DataColumn(label: Text("Store")),
            DataColumn(label: Text("Id")),
            DataColumn(label: Text("Store")),
            DataColumn(label: Text("Id"))
          ],
          rows: List.generate(
              storeList.stores!.length,
              (index) => DataRow(
                      onLongPress: () {
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
                      ]))),
    );
Widget countryTableWidget(List<CountryModel> countryList) => Container(
      width: Get.width * 0.8,
      child: DataTable(
          columnSpacing: defaultPadding,
          columns: const [
            DataColumn(label: Text("Country")),
          ],
          rows: List.generate(
              countryList.length,
              (index) => DataRow(
                      onLongPress: () {
                        Get.find<DatabaseController>()
                            .nextPage(countryList[index]);
                      },
                      cells: [
                        DataCell(
                          Text(countryList[index].countryName.toString()),
                        ),
                      ]))),
    );

Widget dealsTableWidget(DealsList dealsList) => Container(
      width: Get.width * 0.8,
      child: DataTable(

          // columnSpacing: defaultPadding,

          columns: const [
            DataColumn(label: Text("Store")),
            DataColumn(label: Text("Id")),
            DataColumn(label: Text("Store")),
            DataColumn(label: Text("Id"))
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
                            dealsList.dealsList![index].arabicName.toString(),
                          ),
                        ),
                        DataCell(
                          Text(
                            dealsList.dealsList![index].coupon.toString(),
                          ),
                        ),
                      ]))),
    );
