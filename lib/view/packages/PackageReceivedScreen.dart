import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/utils/CardData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/respose/Status.dart';
import '../../utils/Popup.dart';
import '../../utils/Utils.dart';
import '../../view/packages/ResidentViewFormScreen.dart';
import '../../model/packages/PackageReceived.dart';
import '../../view/packages/PackageReceivedFormScreen.dart';
import '../../model/SignInModel.dart';
import '../../utils/MyTextfield.dart';
import '../../viewmodel/packages/PackageReceivedScreenViewModel.dart';

class PackageReceivedScreen extends StatefulWidget {
  var permisssions;

  PackageReceivedScreen({Key? key, required this.permisssions})
      : super(key: key);

  @override
  State<PackageReceivedScreen> createState() => _PackageReceivedScreenState();
}

class _PackageReceivedScreenState extends State<PackageReceivedScreen> {
  final _searchController = TextEditingController();
  UserDetails userDetails = UserDetails();
  var token;
  var viewModel = PackageReceivedScreenViewModel();
  List<Items>? _items = [];
  List<Items>? _searchResults = [];
  List<Permissions> permissions = [];
  bool isManagement = false;
  bool isResident = false;
  bool isGuard = false;
  bool createExp = false;
  bool updateExp = false;
  bool deleteExp = false;
  bool viewExp = false;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    permissions = widget.permisssions;
    actionPermissions();
  }

  void actionPermissions() async {
    setState(() {
      for (var item in permissions) {
        if ((item.moduleDisplayNameMobile == "Package Receipts") &&
            (item.action != null && item.action!.isNotEmpty)) {
          var actions = item.action ?? [];
          for (var act in actions) {
            if (act.actionName == "Add" || act.actionId == 1) {
              createExp = true;
              print("addbutton = $createExp");
            } else if (act.actionName == "Edit" || act.actionId == 2) {
              updateExp = true;
              print("edit = $createExp");
            } else if (act.actionName == "Delete" || act.actionId == 3) {
              deleteExp = true;
              print("delete = $deleteExp");
            } else if (act.actionName == "View" || act.actionId == 4) {
              viewExp = true;
              print("view = $viewExp");
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

    setState(() {
      if (userDetails.appUsageTypeName.toString().trim() ==
              'VMS Management modules' ||
          userDetails.appUsageTypeName.toString().trim() == 'Guard House') {
        isManagement = true;
        isGuard = true;
        Provider.of<PackageReceivedScreenViewModel>(context, listen: false)
            .fetchPackageReceiptsList(userDetails.propertyId, '');
      } else {
        isResident = true;
        Provider.of<PackageReceivedScreenViewModel>(context, listen: false)
            .fetchPackageReceiptsList(
                userDetails.propertyId, userDetails.unitNumber);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
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
                  if (isManagement)
                    if (createExp)
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
                                      PackageReceivedFormScreen(
                                        data: null,
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
              Consumer<PackageReceivedScreenViewModel>(
                  builder: (context, model, child) {
                if (model.packageReceipt.data != null) {
                  //var data = model.packageReceipt.data!.result!.items;

                  /*if (isResident) {
                    for (int i = 0; i < data!.length; i++) {
                      if (data[i].packageReceiptsStatusName == 'Received') {
                        _items!.add(data[i]);
                      }
                    }
                  } else {
                    _items = data;
                  }
*/
                  _items = model.packageReceipt.data!.result!.items;

                  if (_searchController.text.toString().isEmpty) {
                    _searchResults = model.packageReceipt.data!.result!.items;
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
                                          if(isManagement || isGuard){
                                            Provider.of<PackageReceivedScreenViewModel>(context, listen: false)
                                                .fetchPackageReceiptsList(
                                                userDetails.propertyId, '');
                                          } else {
                                            Provider.of<PackageReceivedScreenViewModel>(context, listen: false)
                                                .fetchPackageReceiptsList(
                                                userDetails.propertyId, userDetails.unitNumber);
                                          }

                                          Navigator.pop(context);
                                        },
                                        positiveButtonText: "Yes",
                                        onPositivePressed: () async {
                                          if (deleteExp) {
                                            final response = await viewModel
                                                .deletetReceivedDetails(
                                                    item.id, context);

                                            if (response.data!.status == 200) {
                                              setState(() {
                                                if(isManagement || isGuard){
                                                  Provider.of<PackageReceivedScreenViewModel>(context, listen: false)
                                                      .fetchPackageReceiptsList(
                                                      userDetails.propertyId, '');
                                                } else {
                                                  Provider.of<PackageReceivedScreenViewModel>(context, listen: false)
                                                      .fetchPackageReceiptsList(
                                                      userDetails.propertyId, userDetails.unitNumber);
                                                }
                                                Utils.toastMessage(response
                                                    .data!.mobMessage
                                                    .toString());

                                                Navigator.pop(context);
                                              });
                                            } else if (response.data!.result ==
                                                Status.error) {
                                              setState(() {
                                                _searchResults!
                                                    .insert(index, item);
                                                Utils.flushBarErrorMessage(
                                                    response.data!.mobMessage
                                                        .toString(),
                                                    context);
                                              });
                                            }
                                          }
                                          else {
                                            Utils.flushBarErrorMessage(
                                                "Do not have access to delete",
                                                context);
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
                  Divider(
                    color: Colors.grey.shade400,
                  ),
                  ContainerValue(
                    text: "Delivery Status",
                    value: ": ${item.packageReceiptsStatusName ?? ""}",
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
                  IconButton(
                      onPressed: () {
                        if (isResident && updateExp || viewExp) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResidentViewFormScreen(
                                      data: item,
                                    )),
                          );
                        } else {
                          if (updateExp || viewExp) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PackageReceivedFormScreen(
                                        data: item,
                                      )),
                            );
                          }
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Color(0xFF036CB2),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (isResident) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResidentViewFormScreen(
                      data: item,
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PackageReceivedFormScreen(
                      data: item,
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
