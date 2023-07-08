import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/respose/Status.dart';
import '../../utils/Popup.dart';
import '../../view/e-document/EditEPollScreen.dart';
import '../../utils/PositiveButton.dart';
import '../../view/e-document/EPollDynamicListScreen.dart';
import '../../viewmodel/eforms/EFormsViewModel.dart';
import '../../model/SignInModel.dart';
import '../../model/eforms/EFormUserData.dart';
import '../../model/eforms/EPollUserData.dart';
import '../../utils/Utils.dart';

class EPollsListingScreen extends StatefulWidget {
  var permisssions;

  EPollsListingScreen({Key? key, required this.permisssions}) : super(key: key);

  @override
  State<EPollsListingScreen> createState() => _EPollsListingScreenState();
}

class _EPollsListingScreenState extends State<EPollsListingScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = EFormsViewModel();
  List<PollItems> _userDataList = [];
  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  List<ParentSubMenu> subMenuPermissions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
    subMenuPermissions = widget.permisssions;
    actionPermissions();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    fetchEPollsUserDataList(userDetails.id, userDetails.propertyId);
  }

  void actionPermissions() async {
    setState(() {
      for (var item in subMenuPermissions) {
        if ((item.moduleDisplayNameMobile == "EForms") &&
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

  Future<void> fetchEPollsUserDataList(var userId, var propertyId) async {
    viewmodel.fetchEPollsUserDataList(userId, propertyId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _userDataList = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: PositiveButton(
                      text: 'Add New E-Polling',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EPollDynamicListScreen()),
                        );
                      }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _userDataList.length,
                    itemBuilder: (context, index) {
                      var item = _userDataList[index];
                      if (item == null) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            bottom: 5,
                          ),
                          child: Text(
                            "No data found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

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
                              _userDataList.removeAt(index);
                            });
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 16,
                                      child: Popup(
                                        title: 'E Poll',
                                        message:
                                            ' Are you sure you want to delete this id?',
                                        negativeButtonText: "No",
                                        onNegativePressed: () {
                                          fetchEPollsUserDataList(userDetails.id, userDetails.propertyId);
                                          Navigator.pop(context);
                                        },
                                        positiveButtonText: "Yes",
                                        onPositivePressed: () async {
                                          if (isdelete) {
                                            final response = await viewmodel
                                                .deleteEPoll(item.id, context);

                                            if (response.data!.status == 200) {
                                              setState(() {
                                                fetchEPollsUserDataList(userDetails.id, userDetails.propertyId);
                                                Utils.toastMessage(response
                                                    .data!.mobMessage
                                                    .toString());

                                                Navigator.pop(context);
                                              });
                                            } else if (response.data!.result ==
                                                Status.error) {
                                              setState(() {
                                                _userDataList.insert(
                                                    index, item);
                                                Utils.flushBarErrorMessage(
                                                    response.data!.mobMessage
                                                        .toString(),
                                                    context);
                                              });
                                            }
                                          } else {
                                            fetchEPollsUserDataList(userDetails.id, userDetails.propertyId);
                                            Navigator.pop(context);
                                            Utils.toastMessage(
                                                'Do not have access to delete');
                                          }
                                        },
                                      ));
                                });
                          },
                          child: InkWell(
                            child: Card(
                              color: Colors.grey.shade100,
                              elevation: 4.0,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  containerValue(
                                      icon: Icons.calendar_month_sharp,
                                      value: DateFormat('yyyy-MM-dd hh:mm a')
                                          .format(DateTime.parse(
                                              _userDataList[index]
                                                  .createdOn
                                                  .toString()))),
                                  if (userDetails.appUsageTypeName?.trim() ==
                                      'VMS Management modules')
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                  if (userDetails.appUsageTypeName?.trim() ==
                                      'VMS Management modules')
                                    containerValue(
                                      icon: Icons.person,
                                      value: userDetails.unitNumber.toString() +
                                          " | " +
                                          userDetails.firstName.toString() +
                                          " " +
                                          userDetails.lastName.toString(),
                                    ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  containerValue(
                                      icon: Icons.nest_cam_wired_stand,
                                      value: _userDataList[index]
                                          .epollingName
                                          .toString()),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  containerValue(
                                      icon: Icons.query_stats,
                                      value: _userDataList[index]
                                          .epollingStatusName
                                          .toString()),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditEPollScreen(
                                          data: _userDataList[index],
                                        )),
                              );
                            },
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container containerValue({
    required var icon,
    required String value,
  }) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xFF036CB2),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
