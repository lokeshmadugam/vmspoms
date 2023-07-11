import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/respose/Status.dart';
import '../../model/packages/PackageExpected.dart';
import '../../model/SignInModel.dart';

import '../../utils/CardData.dart';
import '../../utils/MyTextfield.dart';
import '../../utils/Popup.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/packages/PackageExpectedScreenViewModel.dart';
import '../../viewmodel/packages/PackageReceivedScreenViewModel.dart';
import 'PackageExpectedFormScreen.dart';

class PackageExpectedScreen extends StatefulWidget {
  var permissions;

  PackageExpectedScreen({Key? key, required this.permissions})
      : super(key: key);

  @override
  State<PackageExpectedScreen> createState() => _PackageExpectedScreenState();
}

class _PackageExpectedScreenState extends State<PackageExpectedScreen> {
  final _searchController = TextEditingController();
  UserDetails userDetails = UserDetails();
  var token;
  var viewModel = PackageExpectedScreenViewModel();
  List<Items>? _items = [];
  List<Items>? _searchResults = [];
  List<ParentSubMenu> subMenuPermissions = [];
  bool isManagement = false;
  bool isResident = false;
  bool isGuard = false;
  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    subMenuPermissions = widget.permissions;
    actionPermissions();
  }

  void actionPermissions() async {
    setState(() {
      for (var item in subMenuPermissions) {
        if ((item.moduleDisplayNameMobile?.trim() == "Package") &&
            (item.action != null && item.action!.isNotEmpty)) {
          var actions = item.action ?? [];
          for (var act in actions) {
            if (act.actionName == "Add" || act.actionId == 1) {
              iscreate = true;
              print("addbutton = $iscreate");
            } else if (act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");
            } else if (act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");
            } else if (act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");
            }
          }
        }
      }
    });
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    token = SignInModel.fromJson(jsonData).accessToken!;

    // setState(() {
    //   if (userDetails.appUsageTypeName.toString().trim() ==
    //           'VMS Management modules' ||
    //       userDetails.appUsageTypeName.toString().trim() == 'Unit users') {
    //     isManagement = true;
    //     isResident = true;
    //   } else {
    //     isGuard = true;
    //   }
    // });

    Provider.of<PackageExpectedScreenViewModel>(context, listen: false)
        .fetchPackageExpectedList(userDetails.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        child: MyTextField(
                      hintText: 'Search',
                      controller: _searchController,
                      onChanged: (value) {
                        _runSearch(value);
                      },
                      textInputType: TextInputType.text,
                      suffixIcon: Icons.search,
                    )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  // if (isManagement)
                    if (iscreate)
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF036CB2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PackageExpectedFormScreen(
                                        data: null,
                                        update: false,
                                      )));
                        },
                      ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Consumer<PackageExpectedScreenViewModel>(
                  builder: (context, model, child) {
                if (model.packageExpected.data != null) {
                  //var data = model.packageExpected.data!.result!.items;

                  _items = model.packageExpected.data!.result!.items;

                  if (_searchController.text.toString().isEmpty) {
                    _searchResults = model.packageExpected.data!.result!.items;
                  }

                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _searchResults!.length,
                    itemBuilder: (context, index) {
                      var item = _searchResults![index];

                      return Dismissible(
                          key: Key(item.id.toString()),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (direction) async {
                            setState(() {
                              _searchResults!.removeAt(index);
                            });

                            return showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      elevation: 16,
                                      child: Popup(
                                        title: 'Package',
                                        message:
                                        ' Are you sure you want to delete this id?',
                                        negativeButtonText: "No",
                                        onNegativePressed: () {
                                          Provider.of<PackageExpectedScreenViewModel>(context, listen: false)
                                              .fetchPackageExpectedList(userDetails.propertyId);
                                          Navigator.pop(context);
                                        },
                                        positiveButtonText: "Yes",
                                        onPositivePressed: () async {
    if (isdelete) {
      final response = await viewModel
          .deleteExpectedDetails(
          item.id, context);

      if (response.data!.status == 200) {
        setState(() {
          Provider.of<PackageExpectedScreenViewModel>(context, listen: false)
              .fetchPackageExpectedList(userDetails.propertyId);
          Utils.toastMessage(response
              .data!.mobMessage
              .toString());

          Navigator.pop(context);
        });
      } else if (response.data!.result ==
          Status.error) {
        setState(() {
          _searchResults!.insert(index, item);
          Utils.flushBarErrorMessage(
              response.data!.mobMessage
                  .toString(),
              context);
        });
      }
    }else {

      Navigator.pop(context);
      Utils.toastMessage(
          'Do not have access to delete');
    }
                                        },
                                      ));
                                });
                          },
                          child: buildInkWell(context, item));

                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.01,
                          );
                    },
                  );
                }
                return Container();
              }),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildInkWell(BuildContext context, Items item) {
    return InkWell(
      child: Card(
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  ContainerValue(
                    text: "Unit No.",
                    value: ": ${item.unitNumber ?? ""}",
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                  ),
                  ContainerValue(
                    text: "Date",
                    value:
                        ": ${item.createdOn != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(item.createdOn ?? '')) : ''}",
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                  ),
                  ContainerValue(
                    text: "Package Form",
                    value: ": ${item.packageFrom ?? ""}",
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(onPressed: () {
                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(
                  //   //       builder: (context) =>
                  //   //           PackageExpectedFormScreen(data: item,)),
                  //   // );
                  // },
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Color(0xFF036CB2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (isupdate == true || isview == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PackageExpectedFormScreen(
                      data: item,
                      update: isupdate,
                    )),
          );
        }
      },
    );
  }

  void _runSearch(String searchTerm) {
    List<Items> results = [];
    for (var item in _items!) {
      if (item.packageFrom!.toLowerCase().contains(searchTerm.toLowerCase()) ||
          item.unitNumber!.toLowerCase().contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _searchResults = results;
    });
  }
}
