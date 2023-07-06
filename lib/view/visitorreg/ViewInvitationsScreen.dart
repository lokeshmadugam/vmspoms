import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/model/visitorreg/VisitorsStatusModel.dart';
import 'package:poms_app/utils/CardData.dart';
import 'package:poms_app/view/visitorreg/GreyListingScreen.dart';
import 'package:provider/provider.dart';

import '../../model/SignInModel.dart';
import '../../model/visitorreg/VisitorTypeModel.dart';
import '../../model/visitorreg/VisitorsListModel.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/Popup.dart';
import '../../utils/utils.dart';
import '../../viewmodel/visitorregistration/InviteVisitorViewModel.dart';
import 'ShareVistorDetailsScreen.dart';
import 'VisitorsDetailsScreen.dart';

import '../../data/respose/Status.dart';

import '../../viewmodel/UserViewModel.dart';

class ViewInvistationsScreen extends StatefulWidget {
 var permission;
  ViewInvistationsScreen({Key? key,required this.permission}) : super(key: key);

  @override
  State<ViewInvistationsScreen> createState() => _ViewInvistationsScreenState();
}

class _ViewInvistationsScreenState extends State<ViewInvistationsScreen> {
  var viewModel = InviteVisitorViewModel();
  var userVM = UserViewModel();
  int userId = 0;
  int propertyId = 0;

  bool _isVisitTypeVisible = false;
  bool _isVisitStatusSelected = false;

  var finalvalue;
  var finalvalue1;

  int visitTypeId = 0;
  int visitorStatusId = 0;
  List<VistorsListItems> items = [];
  List<VistorsListItems> filteredList = [];
  List<VisitTypeItems> visitTypeItems = [];
  List<VisitorStatusItems> visitorStatusItems = [];
  bool showFullListView = false;
String appusagetypeName = "";
  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  bool isprint = false;
  bool isdownload = false;
  @override
  void initState() {
    super.initState();
    getUserDetails();
    fetchVisitorStatus();
    fetchVisitorStatus1();
    permissions = widget.permission;
    actionPermissions();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;

      userId = userid ?? 0;
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      // unitDeviceCnt = unitdevicecnt ?? 0 ;
      final unitnmb = value.userDetails?.unitNumber;
      // unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      // blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      // userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeName;
      appusagetypeName = appusagetypeid ?? " ";
      fetchVisitorList();
      fetchVisitType();
    });
    // setState(() {
    //
    // });
  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "Visitor Registration ") && (item.action != null && item.action!.isNotEmpty)){
          var actions = item.action ?? [];
          for (var act in actions){
            if( act.actionName == "Add" || act.actionId == 1){
              iscreate = true;
              print("addbutton = $iscreate");

            }
            else if ( act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");

            }
            else if ( act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");

            }
            else if ( act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");

            }
            else if ( act.actionName == "Print" || act.actionId == 5) {
              isprint = true;
              print("print = $isprint");

            }
            else if ( act.actionName == "Download files" || act.actionId == 6) {
              isdownload = true;
              print("download = $isdownload");

            }
            else if ( act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");

            }
          }
        }
      }
    });
  }
  void fetchVisitType() async {
    viewModel.getVisitorType().then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              visitTypeItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }
  void fetchVisitorStatus() async {
    viewModel.getVisitorsStatus("ASC", "id", 1, 25, "VMS", "VisitorStatus").then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {





            setState(() {
              visitorStatusItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }
  void fetchVisitorStatus1() async {
    viewModel.getVisitorsStatus1("ASC", "id", 1, 25, "VMS", "VisitorStatus");
  }

  void fetchVisitorList() async {
    viewModel.getVisitorsList("ASC", "id", 1, 500, propertyId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              items = data;
              filteredList = items;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  void sortByDate() {
    List<VistorsListItems> item = items;
    item.sort((a, b) {
      // Compare arrival date first
      int dateComparison =
          b.visitorArrivalDate?.compareTo(a.visitorArrivalDate ?? '') ?? 0;
      if (dateComparison != 0) {
        return dateComparison;
      }
      // If arrival date is the same, compare arrival time
      return b.visitorArrivalTime?.compareTo(a.visitorArrivalTime ?? '') ?? 0;
    });
  }

  List<VistorsListItems> filterListItems1() {
    List<VistorsListItems> filteredList = List<VistorsListItems>.from(items);

    if (visitTypeId != 0) {
      print(visitTypeId);
      List<VistorsListItems> typetemp = [];
      for (int i = 0; i < filteredList.length; i++) {
        if (filteredList[i].visitTypeId == visitTypeId) {
          typetemp.add(filteredList[i]);
        }
      }
      filteredList = typetemp;
    }

    if (visitorStatusId != 0) {
      print(visitorStatusId);
      List<VistorsListItems> statustemp = [];
      for (int i = 0; i < filteredList.length; i++) {
        if (filteredList[i].visitorRegistrstionStatusId == visitorStatusId) {
          statustemp.add(filteredList[i]);
        }
      }
      filteredList = statustemp;
    }

    return filteredList;
  }
  List<VistorsListItems> filterListItems() {
    List<VistorsListItems> filteredList = List<VistorsListItems>.from(items);

    if (visitTypeId != 0) {
      filteredList = filteredList.where((item) => item.visitTypeId == visitTypeId).toList();
    }

    if (visitorStatusId != 0) {
      filteredList = filteredList.where((item) => item.visitorRegistrstionStatusId == visitorStatusId).toList();
    }

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(_isVisitTypeVisible
                            ? Icons.filter_list
                            : Icons.filter_list),
                        color:
                            _isVisitStatusSelected ? Colors.green : Colors.red,
                        // onPressed: () {
                        //   setState(() {
                        //     _isVisitStatusSelected = !_isVisitStatusSelected;
                        //     _isVisitTypeVisible = !_isVisitTypeVisible;
                        //   });
                        // },
                        onPressed: () {
                          setState(() {
                            _isVisitStatusSelected = !_isVisitStatusSelected;
                            _isVisitTypeVisible = !_isVisitTypeVisible;
                            if (_isVisitStatusSelected) {
                              visitTypeId = 0; // Reset visit type filter
                            } else {
                              visitorStatusId = 0; // Reset visitor status filter
                            }
                            filteredList = filterListItems();
                          });
                        },

                      ),
                      if (_isVisitTypeVisible)

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: MyDropDown(
                            value: finalvalue1 ??
                                (visitorStatusItems != null &&
                                    visitorStatusItems.isNotEmpty
                                    ? visitorStatusItems[0].displayName
                                    : null),
                            labelText: 'Visitor Status',
                            hintText: 'Visitor Status',
                            items: visitorStatusItems
                                .map((item) => item.displayName)
                                .map((identityType) => DropdownMenuItem<String>(
                              value: identityType,
                              child: Text(identityType!),
                            ))
                                .toList(),
                            onchanged: (value) {
                              setState(() {
                                finalvalue1 = value.toString();
                                visitorStatusId = 0;
                                for (int i = 0;
                                i < visitorStatusItems.length;
                                i++) {
                                  if (value ==
                                      visitorStatusItems[i].displayName) {
                                    visitorStatusId =
                                    visitorStatusItems[i].id!;
                                    break;
                                  }
                                }
                                filteredList = filterListItems();
                              });
                            },
                          ),
                        ),


                      if (!_isVisitTypeVisible)

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: MyDropDown(
                          value: finalvalue ??
                              (visitTypeItems != null &&
                                  visitTypeItems.isNotEmpty
                                  ? visitTypeItems[0].visitType
                                  : null),
                          labelText: 'Visit Type',
                          hintText: 'Visit Type',
                          items: visitTypeItems
        .map((item) => item.visitType)
        .map((identityType) => DropdownMenuItem<String>(
    value: identityType,
    child: Text(identityType!),
    ))
        .toList(),
                          onchanged: (value) {
                            setState(() {
                              finalvalue = value.toString();
                              visitTypeId = 0;
                              for (int i = 0;
                              i < visitTypeItems.length;
                              i++) {
                                if (value ==
                                    visitTypeItems[i].visitType) {
                                  visitTypeId =
                                  visitTypeItems[i].id!;
                                  break;
                                }
                              }
                              filteredList = filterListItems();
                            });
                          },
                        ),
                      ),


                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: IconButton(
                                  icon: Icon(Icons.sort_by_alpha_rounded,
                                      color: Colors.red.shade400),
                                  onPressed: () {
                                    setState(() {
                                      sortByDate();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                // help.png
                                icon: Image.asset(
                                  'assets/images/ban-user.png',
                                  // color: Colors.red,
                                  // height:MediaQuery.of(context).size.height *0.02 ,
                                ),

                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GreyListingScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 8.0, bottom: 8.0),
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    // itemCount: _isVisitStatusSelected ? items.length : filteredList.length,

                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var item = filteredList[index];
                      // var item = _isVisitStatusSelected ? items[index] : filteredList[index];

                      if (item == null) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
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

                        if (visitTypeId == 0 ||
                            item.visitTypeId == visitTypeId) {

                            return Dismissible(

                              key: Key(item.id.toString()),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Icon(
                                      Icons.delete, color: Colors.white),
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
                                          child: Popup(title: 'Intercom List',
                                            message: ' Are you sure you want to delete this id?',
                                            negativeButtonText: "No",
                                            onNegativePressed: () {
                                              Navigator.pop(context);
                                            },
                                            positiveButtonText: "Yes",
                                            onPositivePressed: () async {
    if (isdelete) {
      final response = await viewModel
          .deletetVisitorDetails(
          item.id, context);

      if (response.data!.status ==
          200) {
        // Update local state of widget
        setState(() {
          items.removeAt(index);
          Navigator.pop(context);
        });
      } else if (response.data!.result ==
          Status.error) {
        // Show error message to user
        Utils.flushBarErrorMessage(
            response.message!, context);
      }
    }

                                            },)
                                      );
                                    }
                                );
                              },
                              child: buildNewCard(context, item),
                            );

                        }
                        if (visitorStatusId == 0 ||
                            item.visitorRegistrstionStatusId ==
                                visitorStatusId) {

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
    if (isdelete) {
      final response = await viewModel
          .deletetVisitorDetails(item.id, context);

      if (response.data!.status == 200) {
        // Update local state of widget
        setState(() {
          items.removeAt(index);
        });
      } else if (response.data!.result == Status.error) {
        // Show error message to user
        Utils.flushBarErrorMessage(
            response.message!, context);
      }
    }
        },
        child: buildNewCard(context, item),
      );

                        } else {
                          return SizedBox.shrink();
                        // }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card buildNewCard(BuildContext context, VistorsListItems item) {
    return Card(
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
                  text: "Name",
                  value: ": ${item.visitorName ?? ''}",
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                ContainerValue(
                  text: "Phone Number",
                  value: ": ${item.visitorMobileNo ?? ''}",
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                ContainerValue(
                  text: "Visit Type",
                  value: ": ${item.visitTypeName ?? ''}",
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                ContainerValue(
                  text: "Arrival Date & Time",
                  value:
                      ": ${item.visitorRegistrDate != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(item.visitorRegistrDate.toString())) : ''} ${item.visitorArrivalTime}",
                ),
                Divider(
                  color: Colors.grey.shade400,
                ),
                ContainerValue(
                  text: "Vehicle Number",
                  value: ": ${item.vehiclePlateNo ?? ''}",
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
                      if(isview) {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VisitorsDetailsScreen(
                                      item: item,
                                    )));
                      }
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Color(0xFF036CB2),
                    )),
                if(appusagetypeName != "Guard House")
                Visibility(
                  visible: true,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShareVisitorDetailsScreen(
                                      item: item,
                                    )));
                      },
                      icon: Icon(
                        Icons.share,
                        color: Color(0xFF036CB2),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Container containerValue({
  //   required var text,
  //   required String value,
  // }) {
  //   return Container(
  //     child: Padding(
  //       padding: const EdgeInsets.all(2.0),
  //       child: Row(
  //         children: [
  //           SizedBox(
  //             width: MediaQuery.of(context).size.width / 3,
  //             child: Text(
  //               text,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 // fontSize: 14,
  //
  //               )
  //             ),
  //           ),
  //           //VerticalDivider(width: 1,),
  //           Expanded(
  //             child: Text(
  //               value,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 // fontSize: 14,
  //
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
/*
Visit TYpe  ChangeNotifierProvider.value(
                            value: viewModel,
                            child: Consumer<InviteVisitorViewModel>(
                                builder: (context, viewModel, _) {
                              if (viewModel.visitTypeResponse.status ==
                                  Status.loading) {
                                return const Center();
                              } else if (viewModel.visitTypeResponse.status ==
                                  Status.error) {
                                return Center(
                                  child: Text(viewModel
                                      .visitTypeResponse.message
                                      .toString()),
                                );
                              } else if (viewModel.visitTypeResponse.status ==
                                  Status.success) {
                                List<DropdownMenuItem<String>>
                                    dataTypedropdownItems = [];

                                if (viewModel.visitTypeResponse.data?.result
                                        ?.items !=
                                    null) {
                                  Set<String> enterprisecategoryNames = Set();
                                  viewModel
                                      .visitTypeResponse.data!.result!.items!
                                      .forEach((item) {
                                    if (item.visitType != null) {
                                      enterprisecategoryNames
                                          .add(item.visitType!);
                                    }
                                  });

                                  dataTypedropdownItems.addAll(
                                    enterprisecategoryNames
                                        .map(
                                          (visitType) =>
                                              DropdownMenuItem<String>(
                                            value: visitType,
                                            child: Text(
                                              visitType,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                }

                                if (dataTypedropdownItems.length == 1) {
                                  dataTypedropdownItems.add(
                                    DropdownMenuItem<String>(
                                      value: 'no_item',
                                      child: Text('No item'),
                                    ),
                                  );
                                }
                                if (viewModel.visitTypeResponse.data!.result!
                                        .items! ==
                                    null) {
                                  finalvalue = null;
                                } else {
                                  finalvalue = viewModel.visitTypeResponse.data!
                                      .result!.items![0].visitType!;
                                }
                                return SizedBox(
                                  // height: MediaQuery.of(context).size.height*0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  child: MyDropDown(
                                    hintText: 'Visit Type',
                                    value: finalvalue,
                                    labelText: 'Visit Type',
                                    items: dataTypedropdownItems,
                                    onchanged: (value) {
                                      setState(() {
                                        finalvalue = value.toString();
                                        visitTypeId = 0;
                                        for (int i = 0;
                                            i <
                                                viewModel
                                                    .visitTypeResponse
                                                    .data!
                                                    .result!
                                                    .items!
                                                    .length;
                                            i++) {
                                          if (value ==
                                              viewModel
                                                  .visitTypeResponse
                                                  .data!
                                                  .result!
                                                  .items![i]
                                                  .visitType) {
                                            visitTypeId = viewModel
                                                .visitTypeResponse
                                                .data!
                                                .result!
                                                .items![i]
                                                .id!;
                                            break;
                                          }
                                        }
                                        filteredList =
                                            filterListItems(); // update filteredList based on selected dropdown values
                                      });
                                    },
                                  ),
                                );
                              }

                              return Text("");
                            })),
                            Visit Staatus

                             ChangeNotifierProvider.value(
                            value: viewModel,
                            child: Consumer<InviteVisitorViewModel>(
                                builder: (context, viewModel, _) {
                              if (viewModel.visitorStatusResponse.status ==
                                  Status.loading) {
                                return const Center();
                              } else if (viewModel
                                      .visitorStatusResponse.status ==
                                  Status.error) {
                                return Center(
                                  child: Text(viewModel
                                      .visitorStatusResponse.message
                                      .toString()),
                                );
                              } else if (viewModel
                                      .visitorStatusResponse.status ==
                                  Status.success) {
                                List<DropdownMenuItem<String>>
                                    dataTypedropdownItems = [];

                                if (viewModel.visitorStatusResponse.data?.result
                                        ?.items !=
                                    null) {
                                  Set<String> VisitorStatusdropdownItems =
                                      Set();
                                  viewModel.visitorStatusResponse.data!.result!
                                      .items!
                                      .forEach((item) {
                                    if (item.displayName != null) {
                                      VisitorStatusdropdownItems.add(
                                          item.displayName!);
                                    }
                                  });

                                  dataTypedropdownItems.addAll(
                                    VisitorStatusdropdownItems.map(
                                      (visitorStatus) =>
                                          DropdownMenuItem<String>(
                                        value: visitorStatus,
                                        child: Text(
                                          visitorStatus,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ).toList(),
                                  );
                                }

                                  if (dataTypedropdownItems.length == 1) {
                                    dataTypedropdownItems.add(
                                      DropdownMenuItem<String>(
                                        value: 'no_item',
                                        child: Text('No item'),
                                      ),
                                    );
                                  }
                                if (viewModel.visitorStatusResponse.data!
                                        .result!.items! ==
                                    null) {
                                  finalvalue1 = null;
                                } else {
                                  finalvalue1 = viewModel.visitorStatusResponse
                                      .data!.result!.items![0].displayName!;
                                }
                                return SizedBox(
                                  // height: MediaQuery.of(context).size.height*0.06,
                                  // width: MediaQuery.of(context).size.width*0.70,
                                  width:
                                  MediaQuery.of(context).size.width * 0.60,
                                  child: MyDropDown(
                                    hintText: 'Visitor Status',
                                    value: finalvalue1,
                                    labelText: 'Visitor Status',
                                    items: dataTypedropdownItems,
                                    onchanged: (value) {
                                      setState(() {
                                        finalvalue1 = value.toString();
                                        visitorStatusId = 0;
                                        for (int i = 0;
                                            i <
                                                viewModel
                                                    .visitorStatusResponse
                                                    .data!
                                                    .result!
                                                    .items!
                                                    .length;
                                            i++) {
                                          if (value ==
                                              viewModel
                                                  .visitorStatusResponse
                                                  .data!
                                                  .result!
                                                  .items![i]
                                                  .displayName) {
                                            visitorStatusId = viewModel
                                                .visitorStatusResponse
                                                .data!
                                                .result!
                                                .items![i]
                                                .id!;
                                            break;
                                          }
                                        }
                                        // print(visitorStatusId);
                                        filteredList =
                                            filterListItems(); // update filteredList based on selected dropdown values
                                      });
                                    },
                                  ),
                                );
                              }

                              return Text("");
                            })),

 */