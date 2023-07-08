import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/packages/PackageExpected.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/MyTextfield.dart';
import '../../viewmodel/packages/PackageExpectedFormScreenViewModel.dart';

import '../../model/SignInModel.dart';
import '../../utils/Utils.dart';

class PackageExpectedFormScreen extends StatefulWidget {
  var data;
  bool update;

  PackageExpectedFormScreen(
      {super.key, required this.data, required this.update});

  @override
  State<PackageExpectedFormScreen> createState() =>
      _PackageExpectedFormScreenState();
}

class _PackageExpectedFormScreenState extends State<PackageExpectedFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _packageExpectedDateController = TextEditingController();
  final _remarksController = TextEditingController();
  final _blockNameController = TextEditingController();
  final _unitNoController = TextEditingController();
  var packageFrom;
  var packageTypeId;
  UserDetails userDetails = UserDetails();

  Items items = Items();

  List<String> _blockSuggestions = [];
  List<String> _unitSuggestions = [];
  List<String> blockNames = [];
  List<String> unitNumbers = [];

  DateTime? _selectedDateTime;
  String? _courierName;
  String? blockName;
  String? unitNo;
  String? packageType;
  var value;

  @override
  void initState() {
    super.initState();
    if (widget.data == null) {
    } else {
      items = widget.data;
      _blockNameController.text = items.blockName.toString();
      _unitNoController.text = items.unitNumber.toString();
      _packageExpectedDateController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(items.packageExpectDate.toString() ?? ''));
      _remarksController.text = items.remarks.toString();
      _courierName = items.packageFrom.toString();
      packageType = items.packageTypeId.toString();
    }
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    setState(() {
      blockName = userDetails.blockName.toString();
      unitNo = userDetails.unitNumber.toString();
    });

    Provider.of<PackageExpectedFormScreenViewModel>(context, listen: false)
        .fetchDeliveryServiceList(userDetails.countryCode);
    Provider.of<PackageExpectedFormScreenViewModel>(context, listen: false)
        .fetchPackageTypeList();
    Provider.of<PackageExpectedFormScreenViewModel>(context, listen: false)
        .fetchBlockUnitNoList("", userDetails.propertyId, "");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _packageExpectedDateController.dispose();
    _remarksController.dispose();
    _blockNameController.dispose();
    _unitNoController.dispose();
    super.dispose();
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
                  child: Text('Back',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
            ),
          ],
        ),
        title: Text('Package Expected',
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
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        //width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Block Name :',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    blockName.toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      //width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: Text('Unit No :'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  unitNo.toString(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Consumer<PackageExpectedFormScreenViewModel>(
                    builder: (context, model, child) {
                  if (model.deliveryService.data != null) {
                    var data = model.deliveryService.data!.result!.items!;

                    return MyDropDown(
                        enabled: widget.update,
                        hintText: 'Courier Services',
                        // package from
                        value: _courierName,
                        items: data
                            .map((item) => item.deliveryServName)
                            .map((deliveryServName) => DropdownMenuItem<String>(
                                  value: deliveryServName,
                                  child: Text(deliveryServName!),
                                ))
                            .toList(),
                        onchanged: (value) {
                          packageFrom = value.toString();
                        });
                  }
                  return Container();
                }),
                MyDateField(
                  enabled: widget.update,
                  preffixIcon: Icons.calendar_today,
                  labelText: 'Package Expected Date',
                  controller: _packageExpectedDateController,
                  onPressed: () {
                    _pickDateTime(_packageExpectedDateController);
                  },
                ),
                Consumer<PackageExpectedFormScreenViewModel>(
                    builder: (context, model, child) {
                  if (model.packageType.data != null) {
                    var data = model.packageType.data!.result!.items!;

                    return MyDropDown(
                        enabled: widget.update,
                        hintText: 'Package Type',
                        value: null,
                        items: data
                            .map((item) => item.packageType)
                            .map((packageType) => DropdownMenuItem<String>(
                                  value: packageType,
                                  child: Text(packageType!),
                                ))
                            .toList(),
                        onchanged: (value) {
                          for (int i = 0; i < data.length; i++) {
                            if (value == data[i].packageType) {
                              packageTypeId = data[i].id;
                              break;
                            }
                          }
                        });
                  }
                  return Container();
                }),
                MyTextField(
                    enabled: widget.update,
                    preffixIcon: Icons.sticky_note_2_sharp,
                    controller: _remarksController,
                    labelText: 'Remarks',
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
                          DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a')
                              .parse(_packageExpectedDateController.text
                                  .toString());
                          String formattedDateTime =
                              DateFormat('yyyy-MM-ddTHH:mm:ss')
                                  .format(dateTime);

                          Map<String, dynamic> data = {
                            "block_name": userDetails.blockName,
                            "created_by": userDetails.id,
                            "package_expect_date": formattedDateTime,
                            "package_from": packageFrom,
                            "package_type_id": packageTypeId,
                            "property_id": userDetails.propertyId,
                            "rec_status": userDetails.recStatus,
                            "remarks": _remarksController.text.toString(),
                            "unit_device_cnt": userDetails.unitDeviceCnt,
                            "unit_number": userDetails.unitNumber,
                            "user_id": userDetails.id,
                            "user_type_id": userDetails.appUserTypeId
                          };

                          if (widget.data == null) {
                            Provider.of<PackageExpectedFormScreenViewModel>(
                                    context,
                                    listen: false)
                                .createExpectedPackage(data, context);
                          } else {
                            Provider.of<PackageExpectedFormScreenViewModel>(
                                    context,
                                    listen: false)
                                .updateExpectedPackage(data, items.id, context);
                          }
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
      // final TimeOfDay? selectedTime = await showTimePicker(
      //   context: context,
      //   initialTime: TimeOfDay.now(),
      // );

      // if (selectedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          selected.year,
          selected.month,
          selected.day,
        );
        controller.text = DateFormat('yyyy-MM-dd').format(_selectedDateTime!);
      });
      // }
    }
  }
}
