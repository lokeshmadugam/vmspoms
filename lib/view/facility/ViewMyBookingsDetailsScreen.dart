import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/utils/MyDropdown.dart';
import 'package:poms_app/view/facility/ViewFullBookingDetails.dart';
import '../../data/respose/Status.dart';

import '../../model/SignInModel.dart';
import '../../model/facility/FacilityBookingModel.dart';
import '../../utils/CardData.dart';
import '../../utils/MyDateField.dart';
import '../../utils/Popup.dart';
import '../../utils/utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/facility/FacilityBookingViewModel.dart';

class ViewMyBookingDetailsScreen extends StatefulWidget {
  var permisssions;
  ViewMyBookingDetailsScreen({Key? key,required this.permisssions}) : super(key: key);

  @override
  State<ViewMyBookingDetailsScreen> createState() =>
      _ViewMyBookingDetailsScreenState();
}

class _ViewMyBookingDetailsScreenState
    extends State<ViewMyBookingDetailsScreen> {
  var userVM = UserViewModel();
  var fBViewModel = FacilityBookingViewModel();
  String firstName = "";
  String lastName = "";
  int propertyId = 0;
  List<FacilityItems> _facilityBookings = [];
  List<FacilityItems>? _searchResults = [];
  List<FacilityItems> _filteredFacilityBookings = [];
  DateTime? _selectedDateTime;
  // DateTime? _selectedFromDate;
  // DateTime? _selectedToDate;
  // DateTime? _fromDate = DateTime.now();
  // DateTime? _toDate = DateTime.now();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  List<Permissions> permissions = [];
  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  bool isprint = false;
  bool isdownload = false;
  void initState() {
    super.initState();
    getUserDetails();
    permissions = widget.permisssions;
    actionPermissions();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.firstName;

      firstName = userid ?? '';

      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';

      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      setState(() {
        firstName = userid ?? '';
        print(firstName);
        lastName = lastname ?? '';
        print(lastName);
      });
      fetchFacilityBookings(" ", " ");
    });
  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "Facility Booking") && (item.action != null && item.action!.isNotEmpty)){
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
            else if ( act.actionName == "Print" || act.actionId == 5) {
              isprint = true;
              print("print = $isprint");

            }
            else if ( act.actionName == "Download files" || act.actionId == 6) {
              isdownload = true;
              print("download = $isdownload");

            }
          }
        }
      }
    });
  }
  Future<void> fetchFacilityBookings(var fromDate, var toDate) async {
    fBViewModel
        .fetchFacilityBookingList( 0,"ASC", "id", 1, 500, propertyId,fromDate, toDate,)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _facilityBookings = data;
              _filteredFacilityBookings = _facilityBookings;
              // _searchResults = _facilityBookings  ;
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
                          labelText: 'From Date',

                          controller: _fromDateController,
                          onPressed: () {
                            _pickDateTime(_fromDateController);
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: MyDateField(
                        preffixIcon: Icons.calendar_today,
                        labelText: 'To Date',
                        controller: _toDateController,
                        onPressed: () {
                          if (_fromDateController.text.isNotEmpty) {
                            _pickDateTime(_toDateController);
                          } else {
                            Utils.toastMessage('Select start date');
                          }
                        },
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                  child: ListView.builder(
                    itemCount: _facilityBookings.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var item = _facilityBookings[index];
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
                child: Popup(title: 'Booking Details',
                  message: ' Are you sure you want to delete this id?',
                  negativeButtonText: "No",
                  onNegativePressed: () {
                    Navigator.pop(context);
                  },
                  positiveButtonText: "Yes",
                  onPositivePressed: () async {
    if(isdelete) {
      final response = await fBViewModel.deleteFacilityBookingsData(
          item.id, context);

      if (response.data!.status == 200) {
        // Update local state of widget
        setState(() {
          _facilityBookings.removeAt(index);
        });
      } else if (response.data!.result == Status.error) {
        // Show error message to user
        Utils.flushBarErrorMessage(response.message.toString(), context);
      }
    }else{
      Utils.flushBarErrorMessage("Unable to delete the Booking Details", context);
    }
                  },)
            );
          }
      );

    },
    child: buildInkWell(context, item),
    // child: InkWell(child: buildCard(context, item),,)

  );

                    },
                  ),
                ),

              ],
            ),
          ),
        ));
  }

  InkWell buildInkWell(BuildContext context, FacilityItems item) {
    return InkWell(
child: Card(
  color: Colors.grey.shade100,
  child: Column(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      ContainerValue(
        text: "Name",
        value: ": ${item.facilityKeyCodeHandoverBy ?? ""}",
      ),
      Divider(
        color: Colors.grey.shade400,
      ),
      ContainerValue(
        text: "No. of User Guests",
        value: ": ${item.noOfUsrGuests.toString()}",
      ),
      Divider(
        color: Colors.grey.shade400,
      ),
      ContainerValue(
        text: "Booking Hours",
        value: ": ${item.bookingHrsDay.toString()}",
      ),
      Divider(
        color: Colors.grey.shade400,
      ),
      ContainerValue(
        text: "Booking Date",
        value: ": ${item.usageDate != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(item.usageDate ?? '')) : ''}",
      ),

      Divider(
        color: Colors.grey.shade400,
      ),
      ContainerValue(
        text: 'End Time',
        value: ": ${item.usageEndtime != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(item.usageEndtime ?? '')) : ''}",

      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
    ],
  ),
),
    onTap: (){
  if(isview) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BookingDetails(
                  data: item,
                )));
  }
  }
);
  }




  // Container containerValue({required var text, required String value,}) {
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
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //           //VerticalDivider(width: 1,),
  //           Expanded(
  //             child: Text(
  //               value,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
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

        if (_fromDateController.text.isNotEmpty ||
            _toDateController.text.toString().isNotEmpty) {
          fetchFacilityBookings(_fromDateController.text, _toDateController.text);
        }
      });
    }
  }
}

/*
 Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedFromDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (selectedDate != null) {
                                setState(() {
                                  _selectedFromDate = selectedDate;
                                  _selectedToDate = null;
                                  _updateFilteredItems();
                                });
                             // Call _filteredItems to update the filtered list
                              }
                            },
                            child: Row(
                              children: [
                                Text('From'),
                                Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedToDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (selectedDate != null) {
                                setState(() {
                                  _selectedToDate = selectedDate;
                                  _selectedFromDate = null;
                                  _updateFilteredItems();
                                });
                                 // Call _filteredItems to update the filtered list
                              }
                            },
                            child: Row(
                              children: [
                                Text('To'),
                                Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                     Card buildCard(BuildContext context, FacilityItems item) {
    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.15,

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 0.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.03,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 0.1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0, bottom: 5.0, left: 5.0, right: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.32,
                                        child: Text("Name"),
                                      ),
                                      Text(": "),
                                      Expanded(
                                        child: Text(
                                            "${item.facilityKeyCodeHandoverBy ?? ""}"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.03,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 0.1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.32,
                                          child: Text("No. of User Guests")),
                                      Text(": "),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                            "${item.noOfUsrGuests.toString()}"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.03,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 0.1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.32, child: Text("Booking Hours")),
                                      Text(": "),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                            "${item.bookingHrsDay.toString()}"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.03,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 0.1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.32, child: Text("Booking Date")),
                                      Text(": "),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "${DateFormat('yyyy-MM-dd HH:MM a').format(DateTime.parse(item.usageDate.toString()))}",

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.03,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white,
                                      width: 0.1,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox( width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.32, child: Text('End Time')),
                                      Text(": "),
                                      Expanded(
                                        flex: 1,
                                        child: Text(

                                          "${DateFormat('yyyy-MM-dd HH:MM a').format(DateTime.parse(item.usageEndtime.toString()))}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )


                  );
  }
   // List<FacilityItems> _filteredItems() {
  //   if (_selectedFromDate == null && _selectedToDate == null) {
  //     return _facilityBookings;
  //   } else {
  //     List<FacilityItems> filteredItems = _facilityBookings.where((item) {
  //       DateTime? fromDate = DateTime.tryParse(item.usageStarttime.toString());
  //       DateTime? toDate = DateTime.tryParse(item.usageEndtime.toString());
  //       if (_selectedFromDate == null && _selectedToDate == null) {
  //         return true;
  //       } else if (_selectedFromDate != null && _selectedToDate == null) {
  //         return fromDate != null &&
  //             fromDate.year == _selectedFromDate!.year &&
  //             fromDate.month == _selectedFromDate!.month &&
  //             fromDate.day == _selectedFromDate!.day;
  //       } else if (_selectedFromDate == null && _selectedToDate != null) {
  //         return toDate != null &&
  //             toDate.year == _selectedToDate!.year &&
  //             toDate.month == _selectedToDate!.month &&
  //             toDate.day == _selectedToDate!.day;
  //       } else {
  //         return fromDate != null && toDate != null &&
  //             fromDate.year == _selectedFromDate!.year &&
  //             fromDate.month == _selectedFromDate!.month &&
  //             fromDate.day == _selectedFromDate!.day &&
  //             toDate.year == _selectedToDate!.year &&
  //             toDate.month == _selectedToDate!.month &&
  //             toDate.day == _selectedToDate!.day;
  //       }
  //     }).toList();
  //
  //     return filteredItems;
  //   }
  // }
  //
  //
  // void _updateFilteredItems() {
  //   _filteredFacilityBookings = _filteredItems();
  //   setState(() {});
  // }
 */