import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/Popup.dart';
import '../../utils/PositiveButton.dart';
import '../../view/e-document/EFormDynamicListScreen.dart';
import '../../view/e-document/EditEFormScreen.dart';
import '../../viewmodel/eforms/EFormsViewModel.dart';
import '../../model/SignInModel.dart';
import '../../model/eforms/EFormUserData.dart';
import '../../utils/Utils.dart';

class EFormsListingScreen extends StatefulWidget {
  var permisssions;
 EFormsListingScreen({Key? key,required this.permisssions}) : super(key: key);

  @override
  State<EFormsListingScreen> createState() => _EFormsListingScreenState();
}

class _EFormsListingScreenState extends State<EFormsListingScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = EFormsViewModel();
  List<UserDataItems> _userDataList = [];
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
    actionPermissions ();
  }
  void actionPermissions () async {

    setState(() {


        for (var item in subMenuPermissions) {
          if ((item.moduleDisplayNameMobile == "EForms") &&
              (item.action != null && item.action!.isNotEmpty)) {
            var actions = item.action ?? [];
            for (var act in actions) {
              if (act.actionName == "Add" || act.actionId == 1) {
                iscreate = true;
                print("addbutton = $iscreate");
              }
              else if (act.actionName == "Edit" || act.actionId == 2) {
                isupdate = true;
                print("edit = $isupdate");
              }
              else if (act.actionName == "Delete" || act.actionId == 3) {
                isdelete = true;
                print("delete = $isdelete");
              }
              else if (act.actionName == "View" || act.actionId == 4) {
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

    fetchEFormsUserDataList(userDetails.id, userDetails.propertyId);
  }

  Future<void> fetchEFormsUserDataList(var userId, var propertyId) async {
    viewmodel.fetchEFormUserDataList(userId, propertyId).then((response) {
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
                if(iscreate)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: PositiveButton(
                      text: 'Add New E-Form Request',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EFormDynamicListScreen()),
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
                      return  Dismissible(key: Key(1.toString()),
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
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return Dialog(
                                      shape:
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .circular(
                                              10)),
                                      elevation: 16,
                                      child: Popup(title: 'EForm',
                                        message: ' Are you sure you want to delete this id?',
                                        negativeButtonText: "No",
                                        onNegativePressed: () {
                                          Navigator.pop(context);
                                        },
                                        positiveButtonText: "Yes",
                                        onPositivePressed: () async {
                                          // final response = await viewModel
                                          //     .deletetVisitorDetails(
                                          //     item.id, context);
                                          //
                                          // if (response.data!.status ==
                                          //     200) {
                                          //   // Update local state of widget
                                          //   setState(() {
                                          //     items.removeAt(index);
                                          //   });
                                          // } else
                                          // if (response.data!.result ==
                                          //     Status.error) {
                                          //   // Show error message to user
                                          //   Utils.flushBarErrorMessage(
                                          //       response.message!, context);
                                          // }
                                        },)
                                  );
                                }
                            );
                          },
                          child: InkWell(
                            child: Card(
                              color: Colors.grey.shade100,
                              elevation: 4.0,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  containerValue(
                                      icon: Icons.calendar_month_sharp,
                                      value: DateFormat('yyyy-MM-dd hh:mm a').format(
                                          DateTime.parse(_userDataList[index]
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
                                      value:
                                      _userDataList[index].eformName.toString()),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  containerValue(
                                      icon: Icons.query_stats,
                                      value: _userDataList[index]
                                          .eformsStatus
                                          .toString()),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if(isupdate == true || isview == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditEFormScreen(
                                            data: _userDataList[index],)),
                                );
                              }
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
