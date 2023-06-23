import 'package:code_lab_web/models/users_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/constant.dart';
import '../controllers/database_controller.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Users List"),
            const SizedBox(
              height: 20,
            ),
            GetBuilder<DatabaseController>(builder: (_) {
              // if (_.pageNo.value == 11) {
              //   return const AddStoreForm();
              // }

              if (_.pageNo.value == 0) {
                return Container(
                  width: Get.width * 0.8,
                  child: FutureBuilder<UsersList?>(
                      future: _.fatchUsers(),
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
                          if (snapshot.data?.users == []) {
                            return const Text("No Users Found");
                          }
                          return Row(
                            children: [
                              usersTableWidget(snapshot.data!),
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

Widget usersTableWidget(UsersList users) => SizedBox(
      width: Get.width * 0.8,
      child: DataTable(

          // columnSpacing: defaultPadding,

          columns: const [
            DataColumn(label: Text("Image")),
            DataColumn(label: Text("First Name")),
            DataColumn(label: Text("Last Name")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Country")),
          ],
          rows: List.generate(
              users.users!.length,
              (index) => DataRow(

                      // onLongPress: () {

                      //   Get.find<DatabaseController>()

                      //       .nextDealsPage(users.users![index]);

                      // },

                      cells: [
                        DataCell(users.users![index].profileImage == null
                            ? const CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/profile_pic.png"))
                            : CircleAvatar(
                                backgroundImage: NetworkImage(users
                                    .users![index].profileImage
                                    .toString()),
                              )),
                        DataCell(
                          Text(
                            users.users![index].firstName.toString(),
                          ),
                        ),
                        DataCell(
                          Text(
                            users.users![index].lastName.toString(),
                          ),
                        ),
                        DataCell(
                          Text(
                            users.users![index].email.toString(),
                          ),
                        ),
                        DataCell(
                          Text(
                            users.users![index].countryCode ?? "-",
                          ),
                        ),
                      ]))),
    );
