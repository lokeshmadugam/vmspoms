import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';
import '../../model/SignInModel.dart';
import '../../model/securityrounds/SecurityRoundsLogsRequest.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/securityrounds/SecurityChecksScreenViewModel.dart';
import 'package:http/http.dart' as http;
import '../../model/securityrounds/SecurityMediaUpload.dart';
import '../../utils/Utils.dart';

class SecurityChecksScreen extends StatefulWidget {
  var permisssions;
  SecurityChecksScreen({Key? key,required this.permisssions}) : super(key: key);

  @override
  State<SecurityChecksScreen> createState() => _SecurityChecksScreenState();
}

class _SecurityChecksScreenState extends State<SecurityChecksScreen> {
  UserDetails userDetails = UserDetails();
  GlobalKey qrKey = GlobalKey();
  QRViewController? qrViewController;
  late String qrCode;

  List<SecurityMediaUpload> _roundsList = [];
  var viewmodel = SecurityChecksScreenViewModel();

  List<Items> tempLogsItems = [];

  int roundsId = 0;

  File? _imageFile;
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
    permissions = widget.permisssions;
    actionPermissions();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    roundsId = prefs.getInt('roundsId') ?? 0;

    Provider.of<SecurityChecksScreenViewModel>(context, listen: false)
        .fetchSecurityCheckPoints(userDetails.propertyId);
    fetchSecurityTempLogsList(userDetails.id, roundsId);
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
  Future<void> fetchSecurityTempLogsList(var userId, var roundsId) async {
    viewmodel.getSecurityTempLogs(userId, roundsId, context).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              tempLogsItems.clear();
              tempLogsItems = data;
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Consumer<SecurityChecksScreenViewModel>(
                  builder: (context, model, child) {
                if (model.checkPoints.data != null) {
                  var data = model.checkPoints.data!.result!.items;
                  return MyDropDown(
                      hintText: 'Rounds Check Point',
                      value: null,
                      items: data!
                          .map((item) => item.checkpointName)
                          .map((checkpointName) => DropdownMenuItem<String>(
                                value: checkpointName,
                                child: Text(checkpointName!),
                              ))
                          .toList(),
                      onchanged: (value) {
                        setState(() {
                          int c = 0;
                          for (int i = 0; i < tempLogsItems.length; i++) {
                            if (tempLogsItems[i].checkpointName == value) {
                              Utils.toastMessage('Check point already added');
                              c = 1;
                              break;
                            }
                          }

                          if (c == 0) {
                            Items viewDetails = Items();
                            for (int i = 0; i < data.length; i++) {
                              if (data[i].checkpointName == value) {
                                viewDetails.id = data[i].id;
                                break;
                              }
                            }
                            viewDetails.checkpointName = value;

                            tempLogsItems.add(viewDetails);
                          }
                        });
                      });
                }
                return Container();
              }),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: tempLogsItems.length,
                  itemBuilder: (context, index) {
                    var item = tempLogsItems[index];

                    return InkWell(
                      child: Card(
                        color: Colors.grey.shade100,
                        elevation: 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/images/globe.png'),
                                    ),
                                  ),
                                ),
                                Text(
                                  item.checkpointName.toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Spacer(),
                                InkWell(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade500,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      )),
                                  onTap: () {
                                    popUp(index);
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            if (tempLogsItems[index].checkpointLocationImg !=
                                null)
                              Column(
                                children: [
                                  Center(
                                      child: Text(
                                    'Check In Details :',
                                    style:
                   GoogleFonts.roboto(textStyle:TextStyle(fontWeight: FontWeight.bold), )
                                  )),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: Image.network(
                                                tempLogsItems[index]
                                                    .checkpointLocationImg!)),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item.checkpointName
                                                  .toString()),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                              ),
                                              // Text(DateFormat(
                                              //         'yyyy-MM-dd hh:mm a')
                                              //     .format(DateTime.parse(item
                                              //         .checkinTime
                                              //         .toString()))),
                    Text(
                      item
                          .checkinTime!= null
                    ? DateFormat('yyyy-MM-dd hh:mm a')
                        .format(DateTime.parse(item
                          .checkinTime
                        .toString()))
                        : '',),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PositiveButton(
                    text: 'Security Checks Completed',
                    onPressed: () async {
                      submitAllTempLogsList();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void popUp(var index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF036CB2),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    //gradient: blueGreenGradient,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Choose Action',

                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*Column(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 45,
                            color: Colors.indigo.shade900,
                          ),
                          onTap: () {
                            _getLocation(index);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          'Location',
                          style: TextStyle(color: Colors.indigo.shade900),
                        )
                      ],
                    ),*/
                    Column(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            size: 45,
                            color: Colors.indigo.shade500,
                          ),
                          onTap: () {
                            _takePhoto(index);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          'Take Photo',
                          style: GoogleFonts.roboto(textStyle:TextStyle(color: Colors.indigo.shade500) ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.qr_code_2_outlined,
                            size: 45,
                            color: Colors.indigo.shade500,
                          ),
                          onTap: () {
                            _scanQRCode();
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          'QR Code',
                          style: GoogleFonts.roboto(textStyle:TextStyle(color: Colors.indigo.shade500)),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                  child: PositiveButton(
                      text: 'Close',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _scanQRCode() async {
    try {
      Navigator.pop(context);
      qrViewController?.resumeCamera();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 250,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code!;
        qrViewController?.pauseCamera();
        Navigator.pop(context, qrCode);
      });
    });
  }

  Future<void> _takePhoto(var index) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      if (pickedFile != null) {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm a");
        tempLogsItems[index].checkinTime = dateFormat.format(DateTime.now());
        tempLogsItems[index].checkpointLocationImg = pickedFile.path;
        setState(() {
          _getLocation(index);
        });

        //Navigator.pop(context, pickedFile.path);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getLocation(var index) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Utils.toastMessage('Enable location to show details on the map');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      /*DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm a");
      _roundsList[index].dateTime = dateFormat.format(DateTime.now());*/

      /*if(_roundsList[index].imagePath!=null){

      } else {
        _roundsList[index].imagePath = File("");
      }*/

    });
    tempLogsItems[index].checkinLatitude = '${position.latitude}';
    tempLogsItems[index].checkinLongitude = '${position.longitude}';
    Navigator.pop(context);
    uploadImageTemp(index);
  }

  void uploadImageTemp(int index) {
    viewmodel
        .newMediaUpload(
            File(tempLogsItems[index].checkpointLocationImg.toString()).path,
            context)
        .then((response) {
      if (response.data != null) {
        submitSecurityCheckTemp(index, response.data!.refName!.trim());
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

  void submitSecurityCheckTemp(int index, var imagePath) {
    String formattedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());

    Map<String, dynamic> data = {
      "checkin_latitude": tempLogsItems[index].checkinLatitude,
      "checkin_longitude": tempLogsItems[index].checkinLongitude,
      "checkin_officer_userid": userDetails.id,
      "checkin_time": formattedDateTime,
      "checkpoint_id": tempLogsItems[index].id,
      "checkpoint_location_img": imagePath,
      "checkpoint_visit_daily_cnt": 0,
      "created_by": userDetails.id,
      "property_id": userDetails.propertyId,
      "rec_status": userDetails.recStatus,
      "remarks": "",
      "group_id": 0,
      "rounds_id": 0
    };

    viewmodel.submitSecurityRoundsTemp(data, context).then((value) async {
      if (value.data!.status == 201) {
        print('msg = ${value.data!.mobMessage}');
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('roundsId', value.data!.result);
        fetchSecurityTempLogsList(userDetails.id, value.data!.result);
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

  void submitAllTempLogsList() {
    viewmodel.submitSecurityLogs(tempLogsItems, context).then((value) async {
      if (value.data!.status == 201) {
        print('msg = ${value.data!.mobMessage}');
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('roundsId', 0);
        fetchSecurityTempLogsList(userDetails.id, 0);
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
