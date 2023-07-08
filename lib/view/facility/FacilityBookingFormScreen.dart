import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/MyTextfield.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/facility/FacilityBookingViewModel.dart';

class FacilityBookingFormScreen extends StatefulWidget {
  final String facilityName;
  final int facilityId;
  final String image;

  const FacilityBookingFormScreen(
      {Key? key,
      required this.facilityName,
      required this.image,
      required this.facilityId})
      : super(key: key);

  @override
  State<FacilityBookingFormScreen> createState() =>
      _FacilityBookingFormScreenState();
}

class _FacilityBookingFormScreenState extends State<FacilityBookingFormScreen> {
  String finalValue = "";

  TextEditingController bookedOnControlller = TextEditingController();
  TextEditingController numberofUsersControlller = TextEditingController();
  TextEditingController feeStatusControlller = TextEditingController();
  TextEditingController bookingHoursControlller = TextEditingController();
  TextEditingController remarksControlller = TextEditingController();
  TextEditingController usageDateControlller = TextEditingController();
  TextEditingController usageStartTimeControlller = TextEditingController();
  TextEditingController usageEndTimeControlller = TextEditingController();
  TextEditingController keyCodeCollectionTimeControlller =
      TextEditingController();
  TextEditingController keyCodeHandoverTimeControlller =
      TextEditingController();
  TextEditingController keyCodeHandoverbyControlller = TextEditingController();
  TextEditingController facilityNameController = TextEditingController();
  var userVM = UserViewModel();
  var viewModel = FacilityBookingViewModel();

  void initState() {
    super.initState();
    getUserDetails();
    facilityNameController.text = widget.facilityName ?? '';
    fetchFeePaidStatus();
  }

  String firstName = "";
  String lastName = "";
  String blackName = '';
  String unitNumber = '';
  int userId = 0;
  int propertyId = 0;
  int unitdevicecnt = 0;
  int userTypeId = 0;

  bool _showBiggerImage = false;
  bool isFeeStatus = false;
  String? iso8603DateTime;
  String? iso8602DateTime;
  String? iso8604DateTime;
  String? startTime;
  String? endTime;
  int feepaidId = 0;
  List<VisitorStatusItems> visitorStatusItems = [];

  void dispose() {
    bookedOnControlller.dispose();
    bookingHoursControlller.dispose();
    usageDateControlller.dispose();

    usageStartTimeControlller.dispose();
    usageEndTimeControlller.dispose();
    numberofUsersControlller.dispose();
    feeStatusControlller.dispose();
    remarksControlller.dispose();
    keyCodeCollectionTimeControlller.dispose();
    keyCodeHandoverTimeControlller.dispose();
    keyCodeHandoverbyControlller.dispose();
    super.dispose();
  }

  void _calculateDuration() {
    if (iso8602DateTime != null && iso8603DateTime != null) {
      final startTime = DateTime.parse(iso8602DateTime!);
      final endTime = DateTime.parse(iso8603DateTime!);
      final duration = endTime.difference(startTime).inMinutes;
      final hours = duration ~/ 60; // calculate hours
      final minutes = duration % 60; // calculate minutes
      final formattedDuration = '$hours:${minutes.toString().padLeft(2, '0')}';

      setState(() {
        bookingHoursControlller.text = formattedDuration;
      });
    } else {
      setState(() {
        bookingHoursControlller.text = '';
      });
    }
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id ?? 0;
      userId = userid;
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final devicecnt = value.userDetails?.unitDeviceCnt ?? 0;
      unitdevicecnt = devicecnt;
      final usertypeid = value.userDetails?.userType ?? 0;
      userTypeId = usertypeid;
      final firstname = value.userDetails?.firstName;

      firstName = firstname ?? '';
      print(firstName);
      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      final blkName = value.userDetails?.blockName;
      final unitNum = value.userDetails?.unitNumber;
      print(lastName);
      setState(() {
        firstName = firstname ?? '';
        lastName = lastname ?? '';
        blackName = blkName ?? '';
        unitNumber = unitNum ?? '';
      });
    });
  }

  void fetchFeePaidStatus() async {
    viewModel
        .getFeePaidStatus("ASC", "id", 1, 25, "VMS", "PaymentStatus")
        .then((response) {
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

  void submitFacilityBookingForm() async {
    if (bookedOnControlller.text.isEmpty) {
      Utils.flushBarErrorMessage('booked date can\'t be empty', context);
    } else if (usageStartTimeControlller.text.isEmpty) {
      Utils.flushBarErrorMessage('Start Time can\'t be empty', context);
    } else if (usageEndTimeControlller.text.isEmpty) {
      Utils.flushBarErrorMessage('End time can\'t be empty', context);
    } else if (bookingHoursControlller.text.isEmpty) {
      Utils.flushBarErrorMessage('Booking Hours can\'t be empty', context);
    } else if (numberofUsersControlller.text.isEmpty) {
      Utils.flushBarErrorMessage('date can\'t be empty', context);
    } else {
      // int numberofvistors =
      // int.parse(numberofvistorsController.text.toString());
      // int duration = int.parse(durationController.text.toString());

      DateTime date = DateFormat.yMd().parse(bookedOnControlller.text);
      DateFormat formatter = DateFormat('yyyy-MM-dd');

      String formattedDate = formatter.format(date);

      Map<String, dynamic> data = {
        "booking_hrs_day": bookingHoursControlller.text,
        "booking_id": "string",
        "created_by": userId,
        "facility_id": widget.facilityId,
        "facility_key_code_collection_time": "2023-04-21T05:14:49.260Z",
        "facility_key_code_handover_by": keyCodeHandoverbyControlller.text,
        "facility_key_code_handover_time": "2023-04-21T05:14:49.260Z",
        "fee_paid_status": feepaidId,
        "key_collected_by": 0,
        "no_of_usr_guests": numberofUsersControlller.text,
        "property_id": propertyId,
        "rec_status": 8,
        "remarks": remarksControlller.text,
        "requested_date":
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now()),
        "unit_device_cnt": unitdevicecnt,
        "unit_number": unitNumber,
        "usage_date": formattedDate,
        "usage_endtime": endTime,
        "usage_starttime": startTime,
        "user_id": userId,
        "user_type_id": userTypeId
      };

      viewModel.createFacilityBookings(data, context).then((value) {
        if (value.data!.status == 201) {
          print('msg = ${value.data!.mobMessage}');
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        } else {
          Utils.flushBarErrorMessage("${value.data!.result}", context);
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          Utils.flushBarErrorMessage(error.toString(), context);
          print(error.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 90,
        leading: Row(
          children: [
            SizedBox(
              width: 20,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                iconSize: 20, // reduce the size of the icon
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: SizedBox(
                width: 60, // set a wider width for the text
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Back',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Facility Bookings Form',
          style: Theme.of(context).textTheme.headlineLarge,
          // TextStyle(
          //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    blackName ?? '',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF002449)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    unitNumber ?? '',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF002449)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "|",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF002449)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    firstName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF002449)),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  // Te
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              MyTextField(
                controller: facilityNameController,
                textInputType: TextInputType.text,
                enabled: false,
                labelText: "Facility Name",
              ),

              MyDateField(
                preffixIcon: Icons.calendar_today,
                controller: bookedOnControlller,
                labelText: 'Booking Date',
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    iso8604DateTime = picked.toUtc().toIso8601String();
                    setState(() {
                      bookedOnControlller.text =
                          DateFormat.yMd().format(picked);
                    });
                  }
                },
              ),
              MyDateField(
                preffixIcon: Icons.access_time,
                controller: usageStartTimeControlller,
                labelText: 'from Time',
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final pickedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    iso8602DateTime = pickedDateTime.toUtc().toIso8601String();
                    DateTime dateTime = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                        .parse(pickedDateTime.toString());
                    startTime =
                        DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);

                    setState(() {
                      usageStartTimeControlller.text =
                          DateFormat("HH:mm a").format(pickedDateTime);
                    });
                    _calculateDuration(); // call the method here
                  }
                },
                onChanged: (value) {
                  _calculateDuration(); // call this method here
                },
              ),
              MyDateField(
                preffixIcon: Icons.access_time,
                controller: usageEndTimeControlller,
                labelText: 'To Time',
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final pickedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    iso8603DateTime = pickedDateTime.toUtc().toIso8601String();
                    DateTime dateTime1 = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                        .parse(pickedDateTime.toString());
                    endTime =
                        DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime1);
                    setState(() {
                      usageEndTimeControlller.text =
                          DateFormat("HH:mm a").format(pickedDateTime);
                    });
                    _calculateDuration(); // call the method here
                  }
                },
                onChanged: (value) {
                  _calculateDuration(); // call this method here
                },
              ),
              MyTextField(
                preffixIcon: Icons.timer_sharp,
                controller: bookingHoursControlller,
                textInputType: TextInputType.number,
                hintText: 'Booking Hours',
              ),
              MyTextField(
                preffixIcon: Icons.person_add,
                controller: numberofUsersControlller,
                textInputType: TextInputType.number,
                hintText: " No.of Users",
              ),
              MyDropDown(
                  value: null,
                  hintText: 'Fee Status',
                  items: visitorStatusItems
                      .map((item) => item.keyValue)
                      .map((feestatus) => DropdownMenuItem<String>(
                            value: feestatus,
                            child: Text(feestatus!),
                          ))
                      .toList(),
                  onchanged: (value) {
                    for (int i = 0; i < visitorStatusItems.length; i++) {
                      if (value == visitorStatusItems[i].keyValue) {
                        feepaidId = visitorStatusItems[i].id!;
                        break;
                      }
                    }
                  }),
              // MyTextField(
              //   preffixIcon: Icons.rate_review_sharp,
              //   controller: feeStatusControlller,
              //   textInputType: TextInputType.text,
              //   hintText: 'Fee Status',
              // ),
              MyDateField(
                preffixIcon: Icons.access_time,
                controller: keyCodeCollectionTimeControlller,
                labelText: 'Key Colletion Time',
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      keyCodeCollectionTimeControlller.text =
                          picked.format(context);
                    });
                  }
                },
              ),
              MyDateField(
                preffixIcon: Icons.timer_off_rounded,
                controller: keyCodeHandoverTimeControlller,
                labelText: 'Key Handover Time',
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      keyCodeHandoverTimeControlller.text =
                          picked.format(context);
                    });
                  }
                },
              ),
              MyTextField(
                preffixIcon: Icons.person,
                controller: keyCodeHandoverbyControlller,
                textInputType: TextInputType.text,
                hintText: 'Key Handover By',
              ),
              MyTextField(
                preffixIcon: Icons.sticky_note_2_sharp,
                controller: remarksControlller,
                textInputType: TextInputType.text,
                hintText: 'Remarks',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.70,
                child: PositiveButton(
                  text: 'Submit',
                  onPressed: () {
                    setState(() {
                      submitFacilityBookingForm();
                    });
                    bookedOnControlller.clear();
                    usageStartTimeControlller.clear();
                    usageEndTimeControlller.clear();
                    usageDateControlller.clear();
                    numberofUsersControlller.clear();
                    keyCodeHandoverbyControlller.clear();
                    bookingHoursControlller.clear();
                    setState(() {
                      //widget.facilityName = "";
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
