import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/clockinclockout/ClockInClockOutByEmployeeId.dart';
import '../../model/SignInModel.dart';
import '../../model/clockinclockout/ClockInClockOutRequest.dart';
import '../../utils/MyTextField.dart';
import 'dart:io';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/clockinclockout/ClockInClockOutScreenViewModel.dart';
import '../../utils/Utils.dart';

class CommonClockInClockOutScreen extends StatefulWidget {
  const CommonClockInClockOutScreen({Key? key}) : super(key: key);

  @override
  State<CommonClockInClockOutScreen> createState() => _CommonClockInClockOutScreenState();
}

class _CommonClockInClockOutScreenState extends State<CommonClockInClockOutScreen> {
  TextEditingController employeeIdController = TextEditingController();
  File? _image;
  XFile? pickedFile;
  String? clockInLatitude;
  String? clockInLongitude;
  String? clockInLocationName;
  String? clockInDateTime;
  int? activityId;
  String? deviceId;
  UserDetails userDetails = UserDetails();
  ClockInClockOutScreenViewModel viewModel = ClockInClockOutScreenViewModel();
  bool clockIn = false;
  bool clockOut = false;
  bool timeOff = false;

  Map<String, String>? qrData;
  String name = '';
  String employeeId = '';
  String userId = '';
  late LocationPermission permission;

  String locationNameLine1 = '';
  String locationNameLine2 = '';
  String currentTime = '';
  String? latitude;
  String? longitude;
  List<LatLng> pathPoints = [];
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  QRViewController? qrViewController;
  late String qrCode;
  GlobalKey qrKey = GlobalKey();

  late String _timeString;
  String? date;
  bool isLoading = false;

  ClockInClockOutByEmployeeId clockInClockOutByEmployeeId =
  ClockInClockOutByEmployeeId();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    isLoading = true;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    date = dateFormat.format(DateTime.now());

    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    getCurrentLocation();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    //fetchById();
    viewModel.fetchAttendanceConfigItems();
    getDeviceId();
  }

  /*fetchById() {
    viewModel
        .fetchClockInClockOutByEmployeeId1(
        date, userDetails.employeeId, userDetails.propertyId)
        .then((value) {
      if (value.data != null) {
        clockInClockOutByEmployeeId = value.data!;
        setState(() {
          if (clockInClockOutByEmployeeId.result!.clockIn == false) {
            clockIn = true;
          } else if (clockInClockOutByEmployeeId.result!.clockOut == false) {
            clockOut = true;
            timeOff = true;
          }
        });
      }
    });
  }*/

  Future<void> getCurrentLocation() async {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Utils.toastMessage('Enable location');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      locationNameLine1 = placemarks[0].street.toString();
      locationNameLine2 = placemarks[0].locality.toString() +
          ", " +
          placemarks[0].country.toString();
      latitude = '${position.latitude}';
      longitude = '${position.longitude}';

      pathPoints.add(LatLng(double.parse(latitude.toString()),
          double.parse(longitude.toString())));

      isLoading = false;
    });

    _getUserDetails();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide the keyboard when the screen is tapped
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              'Clock-In/Clock-Out',
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF036CB2)
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        //width: MediaQuery.of(context).size.width / 2,
                        child: MyTextField(
                            labelText: 'Enter Staff ID',
                            controller: employeeIdController,
                            suffixIcon: Icons.qr_code,
                            onPressed: _scanQRCode,
                            textInputType: TextInputType.number),
                      ),
                    ),
                    Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date.toString() + "  "+ _timeString,
                            style:
                            TextStyle(fontSize: 14, color: Color(0xFF036CB2)),
                          ),
                        )),
                  ],
                ),
                //if (pathPoints.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: pathPoints.first,
                        zoom: 15.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        setState(() {
                          _markers.add(
                            Marker(
                              markerId: MarkerId('start'),
                              position: pathPoints.first,
                            ),
                          );
                        });
                      },
                      markers: _markers,
                    ),
                  ),
                ),
                if (locationNameLine1.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locationNameLine1.toString(),
                          ),
                          Text(
                            locationNameLine2.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                /*CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _image == null ? null : FileImage(_image!),
                ),*/
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.4, // Adjust the width and height as desired
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      /*border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),*/
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _image == null
                          ? null
                          : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                if (name.isNotEmpty)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          'Welcome ' + name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (employeeId.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('Employee/User ID : ' + employeeId),
                        ),
                      if (employeeId.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('Employee/User ID : ' + userId),
                        ),
                    ],
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      //width: MediaQuery.of(context).size.width * 0.70,
                      child: PositiveButton(
                          text: 'Clock-In',
                          onPressed: () {
                            if (employeeIdController.text.isNotEmpty) {
                              var data = viewModel
                                  .configItem.data!.result!.items;

                              for (int i = 0; i < data!.length; i++) {
                                if (data[i].keyValue == 'Attendance') {
                                  activityId = data[i].id;
                                  break;
                                }
                              }

                              setState(() {
                                getImage("clockin");
                              });
                            } else {
                              Utils.toastMessage('Enter staff ID');
                            }
                          }),
                    ),
                    SizedBox(
                      //width: MediaQuery.of(context).size.width * 0.70,
                      child: PositiveButton(
                          text: 'Clock Out',
                          onPressed: () {
                            if (employeeIdController.text.isNotEmpty) {
                              var data =
                                  viewModel.configItem.data!.result!.items;

                              for (int i = 0; i < data!.length; i++) {
                                if (data[i].keyValue == 'Attendance') {
                                  activityId = data[i].id;
                                  break;
                                }
                              }

                              setState(() {
                                getImage("clockout");
                              });
                            } else {
                              Utils.toastMessage('Enter staff ID');
                            }
                          }),
                    ),
                    SizedBox(
                      //width: MediaQuery.of(context).size.width * 0.70,
                      child: PositiveButton(
                          text: 'Time Off',
                          onPressed: () {
                            if (employeeIdController.text.isNotEmpty) {
                              var data =
                                  viewModel.configItem.data!.result!.items;

                              for (int i = 0; i < data!.length; i++) {
                                if (data[i].keyValue == 'TimeOff') {
                                  activityId = data[i].id;
                                  break;
                                }
                              }

                              setState(() {
                                getImage("timeoff");
                              });
                            } else {
                              Utils.toastMessage('Enter staff ID');
                            }
                          }),
                    ),
                  ],
                ),
                Consumer<ClockInClockOutScreenViewModel>(
                    builder: (context, model, child) {
                      if (model.clockInClockOutByEmployeeId.data != null) {
                        var data = model.clockInClockOutByEmployeeId.data!.result!;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            // _image = null;
                            // employeeIdController.text = '';
                            // name = '';
                            /*if (data.clockIn == false) {
                              clockIn = true;
                              clockOut = false;
                              timeOff = false;
                            } else if (data.clockOut == false &&
                                data.reqTime == false) {
                              clockIn = false;
                              clockOut = true;
                              timeOff = true;
                            } else if (data.clockOut == false ||
                                data.reqTime == false) {
                              clockIn = true;
                              clockOut = false;
                              timeOff = false;
                            }*/
                          });
                        });
                      }
                      return Container();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*Future<void> _scanQRCode() async {
    try {
      final String qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Scanner color
        'Cancel', // Cancel button text
        true, // Show flash icon
        ScanMode.QR, // Scan mode
      );

      qrData = _parseQRCodeData(qrCode);
      setState(() {
        employeeIdController.text = qrData!['Employee Id'] ?? '';
        name = qrData!['First Name']! + " " + qrData!['Last Name']!;
        employeeId = qrData!['Employee Id'] ?? '';
        userId = qrData!['User Id'] ?? '';
      });
    } on Exception catch (e) {
      print('Error: $e');
    }
  }*/

  Map<String, String> _parseQRCodeData(String qrCode) {
    Map<String, String> data = {};

    // Split the QR code data by newlines to separate the lines
    List<String> lines = qrCode.split('\n');

    // Extract the key-value pairs from each line
    for (String line in lines) {
      List<String> keyValue = line.split(':');
      if (keyValue.length == 2) {
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        data[key] = value;
      }
    }

    return data;
  }

  Future<void> _scanQRCode() async {
    try {
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
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code!;
        qrData = _parseQRCodeData(qrCode);
        qrViewController?.pauseCamera();

        Navigator.pop(context);

        employeeIdController.text = qrData!['Employee Id']!;
        name = qrData!['First Name']! + " " + qrData!['Last Name']!;
        employeeId = qrData!['Employee Id'] ?? '';
        userId = qrData!['User Id'] ?? '';
      });
    });
  }

  Future<void> getImage(String clockInOrClockOut) async {
    pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    setState(() {
      _image = File(pickedFile!.path);
      DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
      clockInDateTime = dateFormat.format(DateTime.now());
      getLocation(clockInOrClockOut);
    });
  }

  Future<void> getLocation(String clockInOrClockOut) async {
    if (permission == LocationPermission.denied) {
      Utils.toastMessage('Enable location');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      clockInLocationName = placemarks[0].name ?? '';
      clockInLatitude = '${position.latitude}';
      clockInLongitude = '${position.longitude}';

      if (clockInOrClockOut == "clockin") {
        uploadImage(activityId!);
      } else if (clockInOrClockOut == "clockout") {
        uploadImageClockOut(activityId!);
      } else if (clockInOrClockOut == "timeoff") {
        uploadImageRequestTimeOff(activityId!);
      }
    });
  }

  Future<void> getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      print('Device ID: $deviceId');
    } catch (e) {
      print('Error getting device ID: $e');
    }
  }

  void uploadImage(int activityId) async {
    ClockInClockOutRequest request = ClockInClockOutRequest();
    request.activity = activityId;
    request.clockInIp = deviceId;
    request.clockInLocation = clockInLocationName;
    request.clockInLongitude = double.parse(clockInLongitude.toString());
    request.clockInLatitude = double.parse(clockInLatitude.toString());
    request.clockInTime = clockInDateTime;
    request.createdBy = userDetails.id;
    request.employeeId = employeeIdController.text.toString();
    request.imgUrlClockin = "";
    request.propertyId = userDetails.propertyId;
    request.userId = userDetails.id;

    request.checkOutLatitude = 0;
    request.checkOutLongitude = 0;
    request.clockOutIp = "";
    request.clockOutLocation = "";
    request.clockOutTime = null;
    request.clockinoutDate = clockInDateTime!.substring(0, 10);
    request.emailFlag = 0;
    request.imgUrlClockout = "";
    request.imgUrlRequestTimeOffIntime = null;
    request.remarks = "";

    Provider.of<ClockInClockOutScreenViewModel>(context, listen: false)
        .getMediaUpload(_image!.path, request, 0, context);
  }

  void uploadImageClockOut(int activityId) {
    ClockInClockOutRequest request = ClockInClockOutRequest();
    request.activity = activityId;
    request.createdBy = userDetails.id;
    request.employeeId = employeeIdController.text.toString();
    request.checkOutLatitude = double.parse(clockInLatitude.toString());
    request.checkOutLongitude = double.parse(clockInLongitude.toString());
    request.clockOutIp = deviceId;
    request.clockOutLocation = clockInLocationName;
    request.clockOutTime = clockInDateTime;
    request.imgUrlClockout = "";
    request.propertyId = userDetails.propertyId;
    request.userId = userDetails.id;

    request.clockInIp = "";
    request.clockInLocation = "";
    request.clockInLongitude = 0;
    request.clockInLatitude = 0;
    request.clockInTime = "";
    request.imgUrlClockin = "";
    request.clockinoutDate = clockInDateTime!.substring(0, 10);
    request.emailFlag = 0;
    request.imgUrlRequestTimeOffIntime = null;
    request.remarks = "Good";

    Provider.of<ClockInClockOutScreenViewModel>(context, listen: false)
        .getMediaUpload(_image!.path, request, 1, context);
  }

  void uploadImageRequestTimeOff(int activityId) {
    ClockInClockOutRequest request = ClockInClockOutRequest();
    request.activity = activityId;
    request.createdBy = userDetails.id;
    request.employeeId = employeeIdController.text.toString();
    request.checkOutLatitude = double.parse(clockInLatitude.toString());
    request.checkOutLongitude = double.parse(clockInLongitude.toString());
    request.clockOutIp = deviceId;
    request.clockOutLocation = clockInLocationName;
    request.clockOutTime = clockInDateTime;
    request.imgUrlClockout = "";
    request.propertyId = userDetails.propertyId;
    request.userId = userDetails.id;

    request.clockInIp = "";
    request.clockInLocation = "";
    request.clockInLongitude = 0;
    request.clockInLatitude = 0;
    request.clockInTime = null;
    request.imgUrlClockin = "";
    request.clockinoutDate = clockInDateTime!.substring(0, 10);
    request.emailFlag = 0;
    request.imgUrlRequestTimeOffIntime = "";
    request.remarks = "Good";

    Provider.of<ClockInClockOutScreenViewModel>(context, listen: false)
        .getMediaUpload(_image!.path, request, 2, context);
  }
}
