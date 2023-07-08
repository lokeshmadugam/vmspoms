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
import '../../utils/MyDropdown.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/MyTextfield.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/SignInModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/damagescomplaints/ComplaintsViewModel.dart';

class CreateComplaintFormScreen extends StatefulWidget {
  bool upload;

  CreateComplaintFormScreen({super.key, required this.upload});

  @override
  State<CreateComplaintFormScreen> createState() =>
      _CreateComplaintFormScreenState();
}

class _CreateComplaintFormScreenState extends State<CreateComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complaintFromController = TextEditingController();
  final _complaintDescriptionController = TextEditingController();

  List<File> _images = [];
  var viewmodel = ComplaintsViewModel();
  var fileStorageViewmodel = FileStorageViewModel();
  List<ServiceItems> _complaintTypeList = [];
  List<ServiceItems> _informToList = [];

  List<String> convertedImagesPath = [];
  String? deviceId;

  UserDetails userDetails = UserDetails();
  DateTime? _selectedDateTime;

  int complaintAppUserTypeId = 0;
  int complaintTypeId = 0;
  int complaintStatusId = 0;

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
      _complaintFromController.text = userDetails.blockName.toString() +
          " " +
          userDetails.unitNumber.toString() +
          " | " +
          userDetails.firstName.toString();

      fetchComplaintTypeItems('Complaints');
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
              fetchComplaintStatusItems('complaintstatus');
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
              for (int i = 0; i < data.length; i++) {
                if (data[i].keyValue == 'Open') {
                  complaintStatusId = data[i].id!;
                  break;
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
        title: Text('Create Complaint',
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
                MyTextField(
                    preffixIcon: Icons.edit_note_outlined,
                    controller: _complaintFromController,
                    labelText: 'Complaint From',
                    enabled: false,
                    textInputType: TextInputType.text),
                MyDropDown(
                    hintText: 'Complaint Type', // package from
                    value: null,
                    items: _complaintTypeList
                        .map((item) => item.keyValue)
                        .map((complaintType) => DropdownMenuItem<String>(
                              value: complaintType,
                              child: Text(complaintType!),
                            ))
                        .toList(),
                    onchanged: (value) {
                      for (int i = 0; i < _complaintTypeList.length; i++) {
                        if (value == _complaintTypeList[i].keyValue) {
                          complaintTypeId = _complaintTypeList[i].id!;
                          break;
                        }
                      }
                    }),
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
                MyTextField(
                    preffixIcon: Icons.note_alt_sharp,
                    controller: _complaintDescriptionController,
                    labelText: 'Complaint Description',
                    maxLines: 3,
                    textInputType: TextInputType.multiline),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                if (widget.upload)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Upload Image :',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal),
                              )),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
                          decoration: BoxDecoration(
                              color: Color(0xFF036CB2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    'Photo',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 2, 10, 0),
                          decoration: BoxDecoration(
                              color: Color(0xFF036CB2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.photo,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: Text(
                                    'Gallery',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                      )
                    ],
                  ),
                if (_images.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      //height: MediaQuery.of(context).size.height * 0.162,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(8),
                        children: List.generate(_images.length, (index) {
                          return Image.file(_images[index]);
                        }),
                      ),
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: PositiveButton(
                      text: 'Submit',
                      onPressed: () {
                        uploadImages();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _images.add(File(pickedImage.path));
      });
    }
  }

  void uploadImages() {
    List<String> imagesPath = [];
    convertedImagesPath.clear();

    if (_images.isNotEmpty) {
      for (int i = 0; i < _images.length; i++) {
        imagesPath.add(_images[i].path.toString());
      }
      fileStorageViewmodel.getMediaUpload(imagesPath, context).then((response) {
        if (response!.isNotEmpty) {
          for (int i = 0; i < response.length; i++) {
            if (i.isOdd) {
              convertedImagesPath
                  .add(jsonEncode(response[i].toString().trim()));
            }
          }
          print(convertedImagesPath.toString());
          submitData();
        }
      });
    } else {
      submitData();
    }
  }

  Future<void> getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      print('Device ID: $deviceId');
    } catch (e) {
      print('Error getting device ID: $e');
    }
  }

  void submitData() {
    String formattedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());

    Map<String, dynamic> data = {
      "complaint_assigned_to_user_id": null,
      "complaint_description": _complaintDescriptionController.text.toString(),
      "complaint_from_date": formattedDateTime,
      "complaint_from_user_id": userDetails.id,
      "complaint_pics": convertedImagesPath.toString(),
      "complaint_resolution": "",
      "complaint_status": complaintStatusId,
      "complaint_to_app_usertype_id": complaintAppUserTypeId,
      "complaint_type_id": complaintTypeId,
      "created_by": userDetails.id,
      "ip_address": deviceId,
      "notify_user_comm_mode_id": null,
      "property_id": userDetails.propertyId,
      "rec_status": userDetails.recStatus,
      "resolution_datetime": null,
      "resolution_given_by_usrid": null
    };

    viewmodel.submitComplaint(data, context).then((value) {
      if (value.data!.status == 201) {
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
