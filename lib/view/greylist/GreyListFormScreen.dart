import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/greylist/GreyList.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/MyTextField.dart';
import '../../model/SignInModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/greylist/GreyListFormScreenViewModel.dart';

class GreyListFormScreen extends StatefulWidget {
  var data;

  GreyListFormScreen({super.key, required this.data});

  @override
  State<GreyListFormScreen> createState() => _GreyListFormScreenState();
}

class _GreyListFormScreenState extends State<GreyListFormScreen> {
  final _formKey = GlobalKey<FormState>();
  UserDetails userDetails = UserDetails();
  var greylistVM = GreyListFormScreenViewModel();
  DateTime? _selectedDateTime;
  final _checkInDateController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _licenseController = TextEditingController();
  final _blockReasonController = TextEditingController();

  Items items = Items();

  int? visitTypeId;
  int? transportModeId;

  int? updatedBy;

  @override
  void initState() {
    super.initState();
    if (widget.data == null) {
      updatedBy = 0;
    } else {
      items = widget.data;
      updatedBy = items.id;
      _nameController.text = items.visitorName.toString();
      _numberController.text = items.visitorMobileNo.toString();
      _checkInDateController.text = DateFormat('yyyy-MM-dd hh:mm a')
          .format(DateTime.parse(items.visitorCheckinDate.toString() ?? ''));
      _vehiclePlateController.text = items.vehiclePlateNo.toString();
      _licenseController.text = items.idDrivingLicenseNo.toString();
      _blockReasonController.text = items.blockReason.toString();
    }
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    Provider.of<GreyListFormScreenViewModel>(context, listen: false)
        .fetchVisitTypes();
    Provider.of<GreyListFormScreenViewModel>(context, listen: false)
        .fetchVehiclesTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 90,
          elevation: 0.0,
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
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16, // reduce the font size
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'Grey List Form',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyTextField(
                    preffixIcon: Icons.person,
                    controller: _nameController,
                    labelText: 'Visitor Name',
                    textInputType: TextInputType.text),
                MyTextField(
                    preffixIcon: Icons.phone_android,
                    controller: _numberController,
                    labelText: 'Mobile Number',
                    textInputType: TextInputType.number),
                MyDateField(
                  preffixIcon: Icons.calendar_today,
                  labelText: 'Check-In Date',
                  controller: _checkInDateController,
                  onPressed: () {
                    _pickDateTime(_checkInDateController);
                  },
                ),
                Consumer<GreyListFormScreenViewModel>(
                    builder: (context, model, child) {
                  if (model.visitType.data != null) {
                    var data = model.visitType.data!.result!.items!;

                    return MyDropDown(
                        hintText: 'Visit Type', // package from
                        value: null,
                        items: data
                            .map((item) => item.visitType)
                            .map((visitType) => DropdownMenuItem<String>(
                                  value: visitType,
                                  child: Text(visitType!),
                                ))
                            .toList(),
                        onchanged: (value) {
                          for (int i = 0; i < data.length; i++) {
                            if (data[i].visitType == value) {
                              visitTypeId = data[i].id;
                              break;
                            }
                          }
                        });
                  }
                  return Container();
                }),
                Consumer<GreyListFormScreenViewModel>(
                    builder: (context, model, child) {
                  if (model.vehicleType.data != null) {
                    var data = model.vehicleType.data!.result!.items!;

                    return MyDropDown(
                        hintText: 'Transport Mode', // package from
                        value: null,
                        items: data
                            .map((item) => item.vehicleType)
                            .map((vehicleType) => DropdownMenuItem<String>(
                                  value: vehicleType,
                                  child: Text(vehicleType!),
                                ))
                            .toList(),
                        onchanged: (value) {
                          for (int i = 0; i < data.length; i++) {
                            if (data[i].vehicleType == value) {
                              transportModeId = data[i].id;
                              break;
                            }
                          }
                        });
                  }
                  return Container();
                }),
                MyTextField(
                    preffixIcon: CupertinoIcons.car,
                    controller: _vehiclePlateController,
                    labelText: 'Vehicle Plate No',
                    textInputType: TextInputType.text),
                MyTextField(
                    preffixIcon: Icons.credit_card_outlined,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: PositiveButton(
                      text: 'Submit',
                      onPressed: () {
                        DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a')
                            .parse(_checkInDateController.text.toString());
                        String formattedDateTime =
                            DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);

                        if (widget.data == null) {
                          Map<String, dynamic> data = {
                            "block_reason":
                                _blockReasonController.text.toString(),
                            "block_req_date": formattedDateTime,
                            "block_request_status": "string",
                            "created_by": userDetails.id,
                            "id_driving_license_no":
                                _licenseController.text.toString(),
                            "property_id": userDetails.propertyId,
                            "rec_status": userDetails.recStatus,
                            "remarks_by_mgmt_guardhse": "string",
                            "user_id_req_greylist": userDetails.id,
                            "user_type_id_req_block": userDetails.userType,
                            "vehicle_img": "string",
                            "vehicle_plate_no":
                                _vehiclePlateController.text.toString(),
                            "visit_type_id": visitTypeId,
                            "visitor_checkin_date": formattedDateTime,
                            "visitor_mobile_no":
                                _numberController.text.toString(),
                            "visitor_name": _nameController.text.toString(),
                            "visitor_transport_mode": transportModeId
                          };
                          greylistVM
                              .submitGreyListForm(data, context)
                              .then((value) {
                            if (value.data!.status == 201) {
                              print('msg = ${value.data!.mobMessage}');
                              Utils.flushBarErrorMessage(
                                  "${value.data!.mobMessage}", context);
                            }
                          }).onError((error, stackTrace) {
                            if (kDebugMode) {
                              Utils.flushBarErrorMessage(
                                  error.toString(), context);
                              print(error.toString());
                            }
                          });
                        } else {
                          Map<String, dynamic> data = {
                            "block_reason":
                                _blockReasonController.text.toString(),
                            "block_req_date": formattedDateTime,
                            "block_request_status": "string",
                            "updated_by": userDetails.id,
                            "id_driving_license_no":
                                _licenseController.text.toString(),
                            "property_id": userDetails.propertyId,
                            "rec_status": userDetails.recStatus,
                            "remarks_by_mgmt_guardhse": "string",
                            "user_id_req_greylist": userDetails.id,
                            "user_type_id_req_block": userDetails.userType,
                            "vehicle_img": "string",
                            "vehicle_plate_no":
                                _vehiclePlateController.text.toString(),
                            "visit_type_id": visitTypeId,
                            "visitor_checkin_date": formattedDateTime,
                            "visitor_mobile_no":
                                _numberController.text.toString(),
                            "visitor_name": _nameController.text.toString(),
                            "visitor_transport_mode": transportModeId
                          };
                          greylistVM
                              .updateGreyListForm(items.id!, data, context)
                              .then((value) {
                            if (value.data!.status == 201) {
                              print('msg = ${value.data!.mobMessage}');
                              Utils.flushBarErrorMessage(
                                  "${value.data!.mobMessage}", context);
                            } else {
                              Utils.flushBarErrorMessage(
                                  " Registration Failed".toString(), context);
                            }
                          }).onError((error, stackTrace) {
                            if (kDebugMode) {
                              Utils.flushBarErrorMessage(
                                  error.toString(), context);
                              print(error.toString());
                            }
                          });
                          //   Provider.of<GreyListFormScreenViewModel>(context,
                          //       listen: false)
                          //       .updateGreyListForm(items.id, data, context);
                        }
                      }),
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
