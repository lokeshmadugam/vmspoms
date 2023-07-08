import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../model/visitorreg/VisitorsListModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyTextField.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/greylist/GreyListFormScreenViewModel.dart';

class AddVisitorInGreyList extends StatefulWidget {
  VistorsListItems data;

  AddVisitorInGreyList({Key? key, required this.data}) : super(key: key);

  @override
  State<AddVisitorInGreyList> createState() => _AddVisitorInGreyListState();
}

class _AddVisitorInGreyListState extends State<AddVisitorInGreyList> {
  final _formKey = GlobalKey<FormState>();
  var userVM = UserViewModel();
  var greylistVM = GreyListFormScreenViewModel();
  DateTime? _selectedDateTime;
  final _checkInDateController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _licenseController = TextEditingController();
  final _blockReasonController = TextEditingController();
  final _visitTypeController = TextEditingController();
  int? visitTypeId;
  int? transportModeId;

  int? updatedBy;
  var checkIn;
  var checkOut;

  @override
  void initState() {
    super.initState();
    if (widget.data == null) {
      updatedBy = 0;
    } else {
      if (widget.data.visitorCheckInOutDate.toString().isNotEmpty ||
          widget.data.visitorCheckInOutDate != null) {
        var data = widget.data.visitorCheckInOutDate;
        for (var i in data!) {
          if (i.visitorCheckinDate.toString().isNotEmpty ||
              i.visitorCheckinDate != null) {
            checkIn = i.visitorCheckinDate.toString();
          }
          if (i.visitorCheckoutDate.toString().isNotEmpty ||
              i.visitorCheckoutDate != null) {
            checkOut = i.visitorCheckoutDate.toString();
          }
        }
      }
      updatedBy = widget.data.id;
      _nameController.text = widget.data.visitorName.toString();
      _numberController.text = widget.data.visitorMobileNo.toString();
      _checkInDateController.text = checkIn != null
          ? DateFormat('yyyy-MM-dd hh:mm a')
              .format(DateTime.parse(checkIn.toString()))
          : '';
      _vehiclePlateController.text = widget.data.vehiclePlateNo.toString();
      _licenseController.text = widget.data.idDrivingLicenseNo.toString();
      _visitTypeController.text = widget.data.visitTypeName.toString();
    }
    _getUserDetails();
  }

  int userId = 0;
  String firstName = "";
  String lastName = "";
  int propertyId = 0;
  int userTypeId = 0;

  Future<void> _getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final firstname = value.userDetails?.firstName;
      final userid = value.userDetails?.id;
      userId = userid ?? 0;
      firstName = firstname ?? '';
      print(firstName);
      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      print(lastName);
      final propertyname = value.userDetails?.propertyId ?? 0;
      propertyId = propertyname ?? 0;
      setState(() {
        firstName = firstname ?? '';
        print(firstName);
        lastName = lastname ?? '';
        print(lastName);
      });
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      // unitDeviceCnt = unitdevicecnt ?? 0 ;
      final unitnmb = value.userDetails?.unitNumber;
      // unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      // blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      // appusagetypeId = appusagetypeid ?? 0;
    });
  }

  void submitData() async {
    DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a')
        .parse(_checkInDateController.text.toString());
    String formattedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
    Map<String, dynamic> data = {
      "block_reason": _blockReasonController.text.toString(),
      "block_req_date": formattedDateTime,
      "block_request_status": "string",
      "created_by": userId,
      "id_driving_license_no": _licenseController.text.toString(),
      "property_id": propertyId,
      "is_block": 0,
      "rec_status": 8,
      "remarks_by_mgmt_guardhse": "string",
      "user_id_req_greylist": userId,
      "user_type_id_req_block": userTypeId,
      "vehicle_img": "string",
      "vehicle_plate_no": _vehiclePlateController.text.toString(),
      "visit_type_id": visitTypeId,
      "visitor_checkin_date": formattedDateTime,
      "visitor_mobile_no": _numberController.text.toString(),
      "visitor_name": _nameController.text.toString(),
      "visitor_transport_mode": transportModeId
    };
    greylistVM.submitGreyListForm(data, context).then((value) {
      if (value.data!.status == 201) {
        print('msg = ${value.data!.mobMessage}');
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
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
        title: Text('Add to Grey List',
            style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyTextField(
                    preffixIcon: Icons.person,
                    enabled: false,
                    controller: _nameController,
                    labelText: 'Visitor Name',
                    textInputType: TextInputType.text),
                MyTextField(
                    preffixIcon: Icons.phone_android,
                    enabled: false,
                    controller: _numberController,
                    labelText: 'Mobile Number',
                    textInputType: TextInputType.number),
                MyDateField(
                  preffixIcon: Icons.calendar_today,
                  enabled: false,
                  labelText: 'Check-In Date',
                  controller: _checkInDateController,
                  onPressed: () {
                    _pickDateTime(_checkInDateController);
                  },
                ),
                MyTextField(
                    preffixIcon: Icons.view_carousel_outlined,
                    enabled: false,
                    controller: _visitTypeController,
                    labelText: 'Visit Type',
                    textInputType: TextInputType.text),
                MyTextField(
                    preffixIcon: CupertinoIcons.car,
                    enabled: false,
                    controller: _vehiclePlateController,
                    labelText: 'Vehicle Plate No',
                    textInputType: TextInputType.text),
                MyTextField(
                    preffixIcon: Icons.credit_card_rounded,
                    enabled: false,
                    controller: _licenseController,
                    labelText: 'Driving License No',
                    textInputType: TextInputType.text),
                MyTextField(
                    preffixIcon: Icons.block,
                    controller: _blockReasonController,
                    labelText: 'Block Reason',
                    textInputType: TextInputType.text),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: PositiveButton(
                        text: 'Submit',
                        onPressed: () {
                          submitData();
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(selected.year, selected.month,
              selected.day, selectedTime.hour, selectedTime.minute);
          controller.text =
              DateFormat('yyyy-MM-dd hh:mm a').format(_selectedDateTime!);
        });
      }
    }
  }
}
