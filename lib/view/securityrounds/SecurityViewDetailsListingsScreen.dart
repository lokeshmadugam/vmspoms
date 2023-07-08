import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/respose/Status.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';
import '../../utils/CardData.dart';
import '../../utils/Popup.dart';
import '../../utils/Utils.dart';
import '../../view/securityrounds/SecurityDetailsMapScreen.dart';
import '../../model/SignInModel.dart';
import '../../utils/MyTextfield.dart';
import '../../viewmodel/securityrounds/SecurityViewDetailsScreenViewModel.dart';

class SecurityViewDetailsListingsScreen extends StatefulWidget {
  var permisssions;

  SecurityViewDetailsListingsScreen({Key? key, required this.permisssions})
      : super(key: key);

  @override
  State<SecurityViewDetailsListingsScreen> createState() =>
      _SecurityViewDetailsListingsScreenState();
}

class _SecurityViewDetailsListingsScreenState
    extends State<SecurityViewDetailsListingsScreen> {
  UserDetails userDetails = UserDetails();
  var token;

  List<Items>? _items = [];
  List<Items>? _searchResults = [];
  final _searchController = TextEditingController();
  List<Permissions> permissions = [];
  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;

  var viewmodel = SecurityViewDetailsScreenViewModel();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    permissions = widget.permisssions;
    actionPermissions();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    token = SignInModel.fromJson(jsonData).accessToken!;

    Provider.of<SecurityViewDetailsScreenViewModel>(context, listen: false)
        .fetchSecurityDetails(userDetails.id, userDetails.propertyId);
  }

  void actionPermissions() async {
    setState(() {
      for (var item in permissions) {
        if ((item.moduleDisplayNameMobile == "Attendance") &&
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
            } else if (act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  child: MyTextField(
                hintText: 'Search',
                controller: _searchController,
                onChanged: (value) {
                  _runSearch(value);
                },
                textInputType: TextInputType.text,
                suffixIcon: Icons.search,
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Consumer<SecurityViewDetailsScreenViewModel>(
                  builder: (context, model, child) {
                if (model.securityDetails.data != null) {
                  //var data = model.packageReceipt.data!.result!.items;

                  _items = model.securityDetails.data!.result!.items;

                  if (_searchController.text.toString().isEmpty) {
                    _searchResults = model.securityDetails.data!.result!.items;
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
                                          title: 'Rounds',
                                          message:
                                          ' Are you sure you want to delete this id?',
                                          negativeButtonText: "No",
                                          onNegativePressed: () {
                                            Provider.of<SecurityViewDetailsScreenViewModel>(context, listen: false)
                                                .fetchSecurityDetails(userDetails.id, userDetails.propertyId);
                                            Navigator.pop(context);
                                          },
                                          positiveButtonText: "Yes",
                                          onPositivePressed: () async {
                                            if(isdelete){
                                              final response = await viewmodel
                                                  .deleteSecurityRounds(
                                                  item.id, context);

                                              if (response.data!.status == 200) {

                                                setState(() {
                                                  Provider.of<SecurityViewDetailsScreenViewModel>(context, listen: false)
                                                      .fetchSecurityDetails(userDetails.id, userDetails.propertyId);
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
                                            } else {
                                              Utils.flushBarErrorMessage(
                                                  "Do not have access to delete",
                                                  context);
                                            }

                                          },
                                        ));
                                  });
                            },
                            child: InkWell(
                              child: Card(
                                color: Colors.grey.shade100,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    ContainerValue(
                                      text: "Created On",
                                      value:
                                          ": ${item.checkinTime != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(item.checkinTime ?? '')) : ''}",
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                    ),
                                    ContainerValue(
                                      text: "Security Name",
                                      value:
                                          ": ${item.securityFirstName ?? ''}",
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                    ),
                                    ContainerValue(
                                      text: "Rounds Group Id",
                                      value: ": ${item.roundsGroupid ?? ''}",
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SecurityDetailsMapScreen(data: item)),
                                );
                              },
                            ));
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

  void _runSearch(String searchTerm) {
    List<Items> results = [];
    for (var item in _items!) {
      if (item.securityFirstName!.toLowerCase().contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _searchResults = results;
    });
  }
}
