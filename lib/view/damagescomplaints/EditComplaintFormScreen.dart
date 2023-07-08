import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../viewmodel/FileStorage.dart';
import '../../model/ServiceType.dart';
import '../../model/damagescomplaints/Complaints.dart';
import '../../model/damagescomplaints/ManagementOffice.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../utils/NewDropDown.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/MyTextfield.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/SignInModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/damagescomplaints/ComplaintsViewModel.dart';

class EditComplaintFormScreen extends StatefulWidget {
  var data;
  bool update;

  EditComplaintFormScreen(
      {super.key, required this.data, required this.update});

  @override
  State<EditComplaintFormScreen> createState() =>
      _EditComplaintFormScreenState();
}

class _EditComplaintFormScreenState extends State<EditComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complaintFromController = TextEditingController();
  final _complaintDescriptionController = TextEditingController();
  final _solutionDateController = TextEditingController();
  final _solutionByController = TextEditingController();
  final _complaintResolutionController = TextEditingController();

  var viewmodel = ComplaintsViewModel();
  var fileStorageViewmodel = FileStorageViewModel();
  List<ServiceItems> _complaintTypeList = [];
  List<ServiceItems> _informToList = [];
  List<ServiceItems> _complaintStatusItems = [];
  List<ManagementOfficeItems> managementOfficeItems = [];

  List<String> convertedImagesPath = [];
  String? deviceId;

  UserDetails userDetails = UserDetails();
  DateTime? _selectedDateTime;

  int complaintAppUserTypeId = 0;
  int complaintTypeId = 0;
  int complaintStatusId = 0;
  int complaintAssignedToId = 0;

  ComplaintItems items = ComplaintItems();

  bool _isComplaintDetailsExpanded = false;
  bool _isSolutionDetailsExpanded = true;

  final List<String> ddlist = [
    'Developer',
    'Designer',
    'Consultant',
    'Student'
  ];
  final _ddController = TextEditingController();
  List<dynamic> complaintPicsArray = [];

  @override
  void initState() {
    super.initState();
    getDeviceId();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    setState(() {
      items = widget.data;
      complaintPicsArray = jsonDecode(items.complaintPics.toString());

      _complaintFromController.text =
          "${userDetails.blockName} ${userDetails.unitNumber} | ${userDetails.firstName}";
      _complaintDescriptionController.text =
          items.complaintDescription.toString();

      if (items.resolutionGivenByUsrid != null &&
          items.resolutionGivenByUsrid != 0) {
        _solutionDateController.text = items.resolutionDatetime != null
            ? DateFormat('yyyy-MM-dd hh:mm a')
                .format(DateTime.parse(items.resolutionDatetime.toString()))
            : '';
        items.resolutionDatetime.toString();
        _solutionByController.text = items.resolutionGivenByUsrid.toString();
        _complaintResolutionController.text =
            items.complaintResolution.toString();
      }

      fetchComplaintStatusItems('complaintstatus');
      fetchComplaintTypeItems('Complaints');
      fetchComplaintAssignedToItems(
          userDetails.appUserTypeId, userDetails.propertyId);
    });
  }

  Future<void> fetchComplaintTypeItems(var configKey) async {
    viewmodel.fetchComplaintType(configKey).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _complaintTypeList = data;
              fetchInformToItems('appUserType');
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchInformToItems(var configKey) async {
    viewmodel.fetchComplaintType(configKey).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              for (int i = 0; i < data.length; i++) {
                if (data[i].displayName == 'Property Management office' ||
                    data[i].displayName == 'Guard House') {
                  ServiceItems item = data[i];
                  _informToList.add(item);
                }
              }
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchComplaintStatusItems(var configKey) async {
    viewmodel.fetchComplaintType(configKey).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _complaintStatusItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchComplaintAssignedToItems(
      var appUserTypeId, var propertyId) async {
    viewmodel
        .fetchComplaintAssignedToItems(appUserTypeId, propertyId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              managementOfficeItems = data;
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
        title: Text('Edit Complaint',
            style: Theme.of(context).textTheme.headlineLarge
            // TextStyle(
            //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
            ),
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
                InkWell(
                  onTap: () {
                    setState(() {
                      _isComplaintDetailsExpanded =
                          !_isComplaintDetailsExpanded;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF3F9AE5)),
                    //color: Colors.indigo[300],
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          child: Text("Complaint Details",
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                        Spacer(),
                        Icon(
                          _isComplaintDetailsExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isComplaintDetailsExpanded,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        MyDropDown(
                            hintText: 'Complaint Type', // package from
                            value: null,
                            items: _complaintTypeList
                                .map((item) => item.keyValue)
                                .map(
                                    (complaintType) => DropdownMenuItem<String>(
                                          value: complaintType,
                                          child: Text(complaintType!),
                                        ))
                                .toList(),
                            onchanged: (value) {
                              for (int i = 0;
                                  i < _complaintTypeList.length;
                                  i++) {
                                if (value == _complaintTypeList[i].keyValue) {
                                  complaintTypeId = _complaintTypeList[i].id!;
                                  break;
                                }
                              }
                            }),
                        MyTextField(
                            preffixIcon: Icons.edit_note_outlined,
                            controller: _complaintFromController,
                            labelText: 'Complaint From',
                            enabled: false,
                            textInputType: TextInputType.text),
                        MyDropDown(
                            hintText: 'Inform To', // package from
                            value: null,
                            items: _informToList
                                .map((item) => item.displayName)
                                .map((informTo) => DropdownMenuItem<String>(
                                      value: informTo,
                                      child: Text(informTo!),
                                    ))
                                .toList(),
                            onchanged: (value) {
                              for (int i = 0; i < _informToList.length; i++) {
                                if (value == _informToList[i].displayName) {
                                  complaintAppUserTypeId = _informToList[i].id!;
                                  break;
                                }
                              }
                            }),
                        /*NewDropDown(
                            controller: _ddController,
                            hintText: 'Jobs',
                            items: ddlist,
                            onchanged: (value) {

                            }
                        ),*/
                        MyTextField(
                            preffixIcon: Icons.note_alt_sharp,
                            controller: _complaintDescriptionController,
                            labelText: 'Complaint Description',
                            enabled: false,
                            maxLines: 3,
                            textInputType: TextInputType.multiline),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Complaint Image :',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            //height: MediaQuery.of(context).size.height * 0.162,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.all(8),
                              children: List.generate(complaintPicsArray.length,
                                  (index) {
                                return Image.network(complaintPicsArray[index]);
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSolutionDetailsExpanded = !_isSolutionDetailsExpanded;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF386DB6)),
                    //color: Colors.indigo[300],
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          child: Text("Solution Details",
                              style: Theme.of(context).textTheme.headlineMedium
                              // TextStyle(fontSize: 18, color: Colors.white
                              //     // fontWeight: FontWeight.bold,
                              //     ),
                              ),
                        ),
                        Spacer(),
                        Icon(
                          _isSolutionDetailsExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isSolutionDetailsExpanded,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        MyDropDown(
                            hintText: 'Complaint Assigned To', // package from
                            value: null,
                            items: managementOfficeItems
                                .map((item) => item.firstName)
                                .map((managementOffice) =>
                                    DropdownMenuItem<String>(
                                      value: managementOffice,
                                      child: Text(managementOffice!),
                                    ))
                                .toList(),
                            onchanged: (value) {
                              for (int i = 0;
                                  i < managementOfficeItems.length;
                                  i++) {
                                if (value ==
                                    managementOfficeItems[i].firstName) {
                                  complaintAssignedToId =
                                      managementOfficeItems[i].id!;
                                  break;
                                }
                              }
                            }),
                        MyDropDown(
                            hintText: 'Complaint Status', // package from
                            value: null,
                            items: _complaintStatusItems
                                .map((item) => item.keyValue)
                                .map((complaintStatus) =>
                                    DropdownMenuItem<String>(
                                      value: complaintStatus,
                                      child: Text(complaintStatus!),
                                    ))
                                .toList(),
                            onchanged: (value) {
                              for (int i = 0;
                                  i < _complaintStatusItems.length;
                                  i++) {
                                if (value ==
                                    _complaintStatusItems[i].keyValue) {
                                  complaintStatusId =
                                      _complaintStatusItems[i].id!;
                                  break;
                                }
                              }
                            }),
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          labelText: 'Solution Date',
                          controller: _solutionDateController,
                          onPressed: () {
                            _pickDateTime(_solutionDateController);
                          },
                        ),
                        MyTextField(
                            preffixIcon: Icons.person,
                            controller: _solutionByController,
                            labelText: 'Solution By',
                            textInputType: TextInputType.text),
                        MyTextField(
                            preffixIcon: Icons.recommend_sharp,
                            controller: _complaintResolutionController,
                            labelText: 'Complaint Resolution',
                            textInputType: TextInputType.text),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                if (widget.update)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: PositiveButton(
                        text: 'Submit',
                        onPressed: () {
                          submitData();
                        }),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      print('Device ID: $deviceId');
    } catch (e) {
      print('Error getting device ID: $e');
    }
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

  void submitData() {
    DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a')
        .parse(_solutionDateController.text.toString());
    String formattedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);

    Map<String, dynamic> data = {
      "complaint_assigned_to_user_id": complaintAssignedToId,
      "complaint_description": _complaintDescriptionController.text.toString(),
      "complaint_from_date": items.complaintFromDate,
      "complaint_from_user_id": userDetails.id,
      "complaint_pics": items.complaintPics,
      "complaint_resolution": _complaintResolutionController.text.toString(),
      "complaint_status": complaintStatusId,
      "complaint_to_app_usertype_id": items.complaintToAppUsertypeId,
      "complaint_type_id": items.complaintTypeId,
      "ip_address": deviceId,
      "notify_user_comm_mode_id": null,
      "property_id": userDetails.propertyId,
      "rec_status": userDetails.recStatus,
      "resolution_datetime": formattedDateTime,
      "resolution_given_by_usrid": complaintAssignedToId,
      "updated_by": userDetails.id
    };

    viewmodel.updateComplaint(data, items.id, context).then((value) {
      if (value.data!.status == 200) {
        print('msg = ${value.data!.mobMessage}');
        Navigator.pop(context);
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
      } else {
        Utils.flushBarErrorMessage(" Update failed".toString(), context);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    });
  }
}
