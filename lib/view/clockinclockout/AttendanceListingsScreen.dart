import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/utils/CardData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/respose/Status.dart';
import '../../utils/Popup.dart';
import '../../view/greylist/GreyListingsScreen.dart';
// import 'package:vms_poms/utils/Utils.dart';

import '../../model/SignInModel.dart';
import '../../model/clockinclockout/AttendanceListings.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyTextfield.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/clockinclockout/AttendanceListingsScreenViewModel.dart';

class AttendanceListingsScreen extends StatefulWidget {
  var permissions;
  AttendanceListingsScreen({Key? key,required this.permissions}) : super(key: key);

  @override
  State<AttendanceListingsScreen> createState() =>
      _AttendanceListingsScreenState();
}

class _AttendanceListingsScreenState extends State<AttendanceListingsScreen> {
  UserDetails userDetails = UserDetails();
  var token;
  var attendenceVM = AttendanceListingsScreenViewModel();
  List<Items>? _items = [];
  List<Items>? _searchResults = [];
  DateTime? _selectedDateTime;
  final _searchController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  Map<int, String> calculatedDurations = {};
  Map<int, int> outingTimes = {};
  List<Permissions> permissions = [];
  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  @override
  void initState() {
    super.initState();
    _getUserDetails();
    permissions = widget.permissions;
    actionPermissions();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    token = SignInModel.fromJson(jsonData).accessToken!;
    fetchAttendenceList("", "");

    // Provider.of<AttendanceListingsScreenViewModel>(context, listen: false)
    //     .fetchAttendanceListings("", "", "", userDetails.propertyId);
  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "Attendance") && (item.action != null && item.action!.isNotEmpty)){
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
            else if ( act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");

            }
          }
        }
      }
    });
  }
  Future<void> fetchAttendenceList(var startDate, var endDate) async {
    attendenceVM
        .fetchAttendanceListings1(
        "", startDate, endDate, userDetails.propertyId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _items = data;
              print('cou = ${_items?.length}');
              _searchResults = _items;
              _calculateDuration();
            });
          }
        }
      }
    }).catchError((error) {
      // Utils.flushBarErrorMessage("failed", context);
    });
  }

  void _calculateDuration() {
    for (var item in _items!) {
      if (item.clockInTime != null && item.clockOutTime != null) {
        final startTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(item.clockInTime!);
        final endTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(item.clockOutTime!);

        int duration = endTime.difference(startTime).inMinutes;
        int workingTime = duration;
        int outingTime = 0; // Initialize outingTime

        if (item.reqTimeOff != null) {
          for (var outtime in item.reqTimeOff!) {
            final permissionOutTime = DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(outtime.permmissionOutTime ?? '');
            final permissionInTime = DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(outtime.permmissionInTime ?? '');
            outingTime += permissionOutTime
                .difference(permissionInTime)
                .inMinutes; // Add outing time for each request
          }
          workingTime -= outingTime; // Subtract outing time from working time
        }

        final hours = workingTime ~/ 60; // calculate hours
        final minutes = workingTime % 60; // calculate minutes
        final formattedDuration =
            '$hours:${minutes.toString().padLeft(2, '0')}';

        setState(() {
          calculatedDurations[item.id ?? 0] =
              formattedDuration; // Update calculated duration in the map
          if (item.reqTimeOff != null) {
            outingTimes[item.id ?? 0] =
                outingTime; // Update outing time in the map
          }
        });
      } else {
        setState(() {
          final calculatedDuration =
              'Error: Some values are missing'; // Set error message for calculatedDuration property of the item
          print(calculatedDuration);
        });
      }
    }
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: MyDateField(
                        preffixIcon: Icons.calendar_today,
                        labelText: 'Start Date',
                        controller: _startDateController,
                        onPressed: () {
                          _pickDateTime(_startDateController);
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: MyDateField(
                      preffixIcon: Icons.calendar_today,
                      labelText: 'End Date',
                      controller: _endDateController,
                      onPressed: () {
                        if (_startDateController.text.isNotEmpty) {
                          _pickDateTime(_endDateController);
                        } else {
                          Utils.toastMessage('Select start date');
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
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
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.01,
              // ),
              // if(isview)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.separated(
                  itemCount: _searchResults!.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var item = _searchResults![index];
                    var clockInOut;

                    if (item.clockInTime != null &&
                        item.clockOutTime != null) {
                      var format = DateFormat("HH:mm");
                      var clockIn =
                      format.parse(item.clockInTime!.substring(11, 16));
                      var clockOut =
                      format.parse(item.clockOutTime!.substring(11, 16));
                      clockInOut = clockOut.difference(clockIn).inHours;
                    }
                    if (item == null) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 5,
                          right: 5,
                          bottom: 5,
                        ),
                        child: Text(
                          "No data found",
                          style: GoogleFonts.roboto(textStyle:TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
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
                          return  showDialog(
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
                                    child: Popup(title: 'Attendance',
                                      message: ' Are you sure you want to delete this id?',
                                      negativeButtonText: "No",
                                      onNegativePressed: () {
                                        Navigator.pop(context);
                                      },
                                      positiveButtonText: "Yes",
                                      onPositivePressed: () async {
                                        final response = await attendenceVM
                                            .deletetAttendanceDetails(
                                            item.id, context);

                                        if (response.data!.status ==
                                            200) {
                                          // Update local state of widget
                                          setState(() {
                                            // _items?.removeAt(index);
                                            Navigator.pop(context);
                                            fetchAttendenceList("", "");
                                          });
                                          Utils.flushBarErrorMessage(
                                              response.data!.mobMessage.toString(), context);

                                        } else
                                        if (response.data!.result ==
                                            Status.error) {
                                          // Show error message to user
                                          Utils.flushBarErrorMessage(
                                              response.data!.mobMessage.toString(), context);
                                        }
                                      },)
                                );
                              }
                          );
                        },
                        child: buildCard(context, item));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildCard(BuildContext context, Items item) {
    return Card(
                          color: Colors.grey.shade100,
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),
                              ContainerValue(
                                text: "Name",
                                value: ": ${item.employeeFirstName ?? ""}",
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              ContainerValue(
                                text: "EmployeeId",
                                value: ": ${item.employeeId.toString()}",
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              ContainerValue(
                                text: "Clock In Time",
                                value: ": ${item.clockInTime != null ? DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(item.clockInTime ?? '')) : ''}",
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              ContainerValue(
                                text: "Clock Out Time",
                                value: ": ${item.clockOutTime != null ? DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(item.clockOutTime ?? '')) : ''}",
                              ),
                              if (calculatedDurations
                                  .containsKey(item.id))
                                Divider(
                                  color: Colors.grey.shade400,
                                ),
                              ContainerValue(
                                text: 'Working Hours',
                                value: ": ${calculatedDurations[item.id] ?? 'N/A'}",
                              ),
                              if (item.reqTimeOff == null)
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.01,
                                ),
                              if (item.reqTimeOff != null)
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              if (item.reqTimeOff != null)
                                ContainerValue(
                                  text: "Outing Time",
                                  value: ": ${outingTimes[item.id] ?? 'N/A'}", ),
                              if (item.reqTimeOff != null)
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.01,
                                ),
                            ],
                          ),
                        );
  }


  void _runSearch(String searchTerm) {
    List<Items> results = [];
    for (var item in _items!) {
      if (item.employeeId!.toLowerCase().contains(searchTerm.toLowerCase()) ||
          item.employeeFirstName!
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _searchResults = results;
    });
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        _selectedDateTime =
            DateTime(selected.year, selected.month, selected.day);
        controller.text = DateFormat('yyyy-MM-dd').format(_selectedDateTime!);

        if (_startDateController.text.isNotEmpty &&
            _endDateController.text.toString().isNotEmpty) {
          fetchAttendenceList(_startDateController.text, _endDateController.text);
        }
      });
    }
  }
}
