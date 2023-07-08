import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../utils/MyTextField.dart';
import '../../model/visitorreg/VisitorDetailsModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/positiveButton.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/visitorregistration/InviteVisitorViewModel.dart';

import '../../data/respose/Status.dart';

import '../../utils/utils.dart';

class ScanQrcodeScreen extends StatefulWidget {
  ScanQrcodeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ScanQrcodeScreen> createState() => _ScanQrcodeScreenState();
}

class _ScanQrcodeScreenState extends State<ScanQrcodeScreen> {
  var viewModel = InviteVisitorViewModel();
  var userVM = UserViewModel();

  TextEditingController nameController = TextEditingController();
  TextEditingController carPlateNumberController = TextEditingController();
  TextEditingController drivingLicenceNumberController =
  TextEditingController();
  TextEditingController visitReasonController = TextEditingController();
  TextEditingController numberofvistorsController = TextEditingController();
  TextEditingController arrivalDateController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController checkinDateController = TextEditingController();
  TextEditingController checkoutDateController = TextEditingController();
  List<bool> isSelected = [true, false];
  var finalvalue;
  var finalvalue1;
  var finalvalue2;
  int visitTypeId = 0;
  int visitReasonId = 0;
  int vehicleTypeId = 0;
  bool isParkingRequired = false;
  var name;
  var phoneNumber;
  String blockName = "";
  int userId = 0;
  int propertyId = 0;
  int unitDeviceCnt = 0;
  String unitNumber = " ";
  int userTypeId = 0;
  int appusagetypeId = 0;

// VisitorResult? visitorData;
  String entryType = '';
  int visitorId = 0;
  String firstName = "";
  String lastName = "";
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  int id = 0;
  VisitorResult? visitorData;
  DateTime? arrivalDate;
  bool ischeckindate = false;
  DateTime? preregstartDate;
  DateTime? preregendDate;
  bool ischeckoutDate = false;
  bool checkinoutbutton = false;
  @override
  void initState() {
    super.initState();

    getUserDetails();
    _initializeScanner();

    fetchVisitType();
    fetchVisitReasons();
    fetchVehicleType();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    arrivalDateController.text = formattedDate;
    arrivalTimeController.text = TimeOfDay.now().format(context);


  }

  Future<void> _initializeScanner() async {
    await Future.delayed(Duration
        .zero); // Add a delay to ensure the dialog is displayed correctly
    _scanQRCode(context);
  }

  void updateIsParkingRequired(Map<String, String>? qrData) {
    if (qrData != null) {
      final parkingRequired = qrData['Parking Required'];
      setState(() {
        isParkingRequired = parkingRequired == 'Yes';
      });
    }
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;

      userId = userid ?? 0;
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      unitDeviceCnt = unitdevicecnt ?? 0;
      // final unitnmb = value.userDetails?.unitNumber;
      // unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      appusagetypeId = appusagetypeid ?? 0;
      final name = value.userDetails?.firstName;

      firstName = name ?? '';

      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';

      setState(() {
        firstName = name ?? '';
        print(firstName);
        lastName = lastname ?? '';
        print(lastName);
      });
    });
  }

  void fetchVisitType() async {
    viewModel.getVisitorType1();
  }

  void fetchVisitReasons() async {
    viewModel.getVisitReasons1();
  }

  void fetchVehicleType() async {
    viewModel.getVehicleTypes1();
  }

  QRViewController? qrViewController;

  var qrKey = GlobalKey();
  String? qrCode;
  Map<String, String>? qrData;

  Future<void> _scanQRCode(BuildContext context) async {
    // Navigator.pop(context);
    // qrViewController?.resumeCamera();
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
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
    setState(() {
      qrViewController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code!;
        print('qrcode= $qrCode');
        qrViewController!.pauseCamera();
      });

      // Parse the QR code data and extract the values
      // Map<String, String>
      qrData = _parseQRCodeData(qrCode!);
      print('textfielddata = $qrData');
      // Show the AlertDialog with the scanned QR code
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: Color(0xFFD3D3D3FF),
            title: Text('Scanned QR Code'),
            content: SizedBox(
              width: double.maxFinite,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Color(0xFFD3D3D3FF),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: qrData?.length ?? 0,
                  itemBuilder: (context, index) {
                    final key = qrData?.keys.elementAt(index);
                    final value = qrData?[key];
                    if (key == 'Id') {
                      return SizedBox
                          .shrink(); // Hide the card for the hidden data
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    child: Text(key ?? '')),
                                Text(": "),
                                Expanded(child: Text(value ?? '')),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  qrViewController?.resumeCamera();
                  Navigator.pop(context);
                  Navigator.pop(context);

                  id = int.parse(qrData?['Id'] ?? '0');

                  print('id = $id');
                  if (id != 0) {
                    setState(() {
                      fetchVisitorList();
                    });
                  }
                  // Navigator.pop(context);

                },
                child: Text('OK'),

              ),
            ],
          );
        },
      );
    });
  }

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

  // Visitors
  void fetchVisitorList() async {
    viewModel
      ..getVisitorDetails(id).then((response) {
        if (response.data?.status == 200) {
          if (response.data?.result != null) {
            var data = response.data!.result;
            if (data != null) {
              setState(() {
                visitorData = data;

                if (visitorData != null) {
                  // String? visitType = visitorData?.visitTypeName ?? '';
                  // Get the current date and time
                  String currentDateTimeString = DateFormat("yyyy-MM-dd").format(DateTime.now()); // Format the current date and time as a string

                  DateFormat dateformatter = DateFormat("yyyy-MM-dd");
                  DateTime currentDateTime = dateformatter.parse(currentDateTimeString);
                  String? visitorArrivalDateString = visitorData?.visitorArrivalDate;

                  DateTime? visitorArrivalDate =
                  visitorArrivalDateString != null ? DateFormat('yyyy-MM-dd').parse(visitorArrivalDateString) : null;

                  arrivalDate = visitorArrivalDate;
                  print("arr = $visitorArrivalDate");
                  print("current = $currentDateTime");
                  String? preregStartDate = visitorData?.preregStartDate;
                  String? preregEndDate = visitorData?.preregEndDate;
                  DateTime? date =   preregStartDate != null ? DateFormat('yyyy-MM-dd').parse(preregStartDate) : null;

                  DateTime? date1 =  preregEndDate != null ? DateFormat('yyyy-MM-dd').parse(preregEndDate) : null;

                  // preregstartDate = date1;
                  //
                  // preregendDate = date;
                  // if(visitorData?.visitorCheckInOutDate == null)
                  if ((visitorData?.visitTypeName == "One Time" ||
                      visitorData?.visitTypeId == 1) &&
                      visitorData?.visitorCheckInOutDate == null) {

                    if ((visitorArrivalDate != null) &&
                        (visitorArrivalDate == currentDateTime)) {
                      ischeckindate = true;
                      nameController.text = visitorData?.visitorName ?? " ";
                      mobilenumberController.text =
                          visitorData?.visitorMobileNo ?? "";
                      carPlateNumberController.text =
                          visitorData?.vehiclePlateNo ?? '';
                      drivingLicenceNumberController.text =
                          visitorData?.idDrivingLicenseNo ?? '';
                      numberofvistorsController.text =
                          visitorData?.noOfVisitor.toString() ?? '';
                      unitNumberController.text = visitorData?.unitNumber ?? '';
                      notesController.text = visitorData?.remarks ?? " ";
                      finalvalue = visitorData?.visitTypeName ?? '';
                      finalvalue1 = visitorData?.vistReason ?? "";
                      finalvalue2 = visitorData?.vehicleType ?? '';
                      visitTypeId = visitorData?.visitTypeId ?? 0;
                      visitReasonId = visitorData?.visitReasonId ?? 0 ;
                      vehicleTypeId = visitorData?.visitorTransportMode ??  0 ;
                      if (visitorData?.parkingRequired.toString() == 'Yes' ||
                          visitorData?.isParkingRequired == 1) {
                        isParkingRequired = true;
                      }
                      checkinDateController.text = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
                    } else {
                      // Show error messages
                      if (visitorArrivalDate != null &&
                          currentDateTime.isBefore(visitorArrivalDate)) {
                        Utils.flushBarErrorMessage(
                            "Arrival date is tomorrow. Please come tomorrow.",
                            context);
                      } else if (visitorArrivalDate != null &&
                          currentDateTime.isAfter(visitorArrivalDate)) {
                        Utils.flushBarErrorMessage(
                            "QR code is expired.", context);
                      }
                    }
                  }
                  else if ((visitorData?.visitTypeName == "One Time" ||
                      visitorData?.visitTypeId == 1) &&
                      visitorData?.visitorCheckInOutDate != null) {
                    List<VisitorCheckInOutDate>? visitorCheckInOutDates = visitorData?.visitorCheckInOutDate;
                    String? checkinDate;

                    if (visitorCheckInOutDates != null && visitorCheckInOutDates.isNotEmpty) {
                      checkinDate =
                          visitorCheckInOutDates.last.visitorCheckinDate
                              .toString();
                      if ((visitorArrivalDate != null) &&
                          (visitorArrivalDate == currentDateTime)) {
                        ischeckindate = true;
                        ischeckoutDate = true;
                        nameController.text = visitorData?.visitorName ?? " ";
                        mobilenumberController.text =
                            visitorData?.visitorMobileNo ?? "";
                        carPlateNumberController.text =
                            visitorData?.vehiclePlateNo ?? '';
                        drivingLicenceNumberController.text =
                            visitorData?.idDrivingLicenseNo ?? '';
                        numberofvistorsController.text =
                            visitorData?.noOfVisitor.toString() ?? '';
                        unitNumberController.text = visitorData?.unitNumber ?? '';
                        notesController.text = visitorData?.remarks ?? " ";
                        finalvalue = visitorData?.visitTypeName ?? '';
                        finalvalue1 = visitorData?.vistReason ?? "";
                        finalvalue2 = visitorData?.vehicleType ?? '';
                        visitTypeId = visitorData?.visitTypeId ?? 0;
                        visitReasonId = visitorData?.visitReasonId ?? 0 ;
                        vehicleTypeId = visitorData?.visitorTransportMode ??  0 ;
                        if (visitorData?.parkingRequired.toString() == 'Yes' ||
                            visitorData?.isParkingRequired == 1) {
                          isParkingRequired = true;
                        }
                        checkinDateController.text = checkinDate;
                        checkoutDateController.text =
                            DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
                      } }
                    else {
                      // Show error messages
                      if (visitorArrivalDate != null &&
                          currentDateTime.isBefore(visitorArrivalDate)) {
                        Utils.flushBarErrorMessage(
                            "Arrival date is tomorrow. Please come tomorrow.",
                            context);
                      } else if (visitorArrivalDate != null &&
                          currentDateTime.isAfter(visitorArrivalDate)) {
                        Utils.flushBarErrorMessage(
                            "QR code is expired.", context);
                      }
                    }
                  }

                  else if ((visitorData?.visitTypeName == "Multiple Entry" ||
                      visitorData?.visitTypeId == 2) &&
                      visitorData?.visitorCheckInOutDate == null) {

                    if ((date != null &&
                        date1 != null &&
                        currentDate.isAfter(date) &&
                        currentDate.isBefore(date1))) {
                      ischeckindate = true;
                      nameController.text = visitorData?.visitorName ?? " ";
                      mobilenumberController.text =
                          visitorData?.visitorMobileNo ?? "";
                      carPlateNumberController.text =
                          visitorData?.vehiclePlateNo ?? '';
                      drivingLicenceNumberController.text =
                          visitorData?.idDrivingLicenseNo ?? '';
                      numberofvistorsController.text =
                          visitorData?.noOfVisitor.toString() ?? '';
                      unitNumberController.text = visitorData?.unitNumber ?? '';
                      notesController.text = visitorData?.remarks ?? " ";
                      finalvalue = visitorData?.visitTypeName ?? '';
                      finalvalue1 = visitorData?.vistReason ?? "";
                      finalvalue2 = visitorData?.vehicleType ?? '';
                      visitTypeId = visitorData?.visitTypeId ?? 0;
                      visitReasonId = visitorData?.visitReasonId ?? 0 ;
                      vehicleTypeId = visitorData?.visitorTransportMode ??  0 ;
                      checkinDateController.text = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
                      if (visitorData?.parkingRequired.toString() == 'Yes' ||
                          visitorData?.isParkingRequired == 1) {
                        isParkingRequired = true;
                      }
                    } else {
                      // Show error messages
                      if (date != null && currentDateTime.isBefore(date)) {
                        Utils.flushBarErrorMessage(
                            "Arrival date is tomorrow. Please come tomorrow.",
                            context);
                      } else if (date1 != null && currentDateTime.isAfter(date1)) {
                        Utils.flushBarErrorMessage(
                            "QR code is expired.", context);
                      }
                    }
                  }
                  else if ((visitorData?.visitTypeName == "Multiple Entry" ||
                      visitorData?.visitTypeId == 2) &&
                      visitorData?.visitorCheckInOutDate != null) {
                    List<VisitorCheckInOutDate>? visitorCheckInOutDates = visitorData?.visitorCheckInOutDate;
                    String? checkinDate;
                    if ((date != null &&
                        date1 != null &&
                        currentDate.isAfter(date) &&
                        currentDate.isBefore(date1))) {
                      if (visitorCheckInOutDates != null && visitorCheckInOutDates.isNotEmpty) {
                        checkinDate =
                            visitorCheckInOutDates.last.visitorCheckinDate
                                .toString();
                        ischeckindate = true;
                        ischeckoutDate = true;

                        nameController.text = visitorData?.visitorName ?? " ";
                        mobilenumberController.text =
                            visitorData?.visitorMobileNo ?? "";
                        carPlateNumberController.text =
                            visitorData?.vehiclePlateNo ?? '';
                        drivingLicenceNumberController.text =
                            visitorData?.idDrivingLicenseNo ?? '';
                        numberofvistorsController.text =
                            visitorData?.noOfVisitor.toString() ?? '';
                        unitNumberController.text = visitorData?.unitNumber ?? '';
                        notesController.text = visitorData?.remarks ?? " ";
                        checkinDateController.text = checkinDate;
                        finalvalue = visitorData?.visitTypeName ?? '';
                        finalvalue1 = visitorData?.vistReason ?? "";
                        finalvalue2 = visitorData?.vehicleType ?? '';
                        visitTypeId = visitorData?.visitTypeId ?? 0;
                        visitReasonId = visitorData?.visitReasonId ?? 0 ;
                        vehicleTypeId = visitorData?.visitorTransportMode ??  0 ;
                        checkoutDateController.text =
                            DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
                        if (visitorData?.parkingRequired.toString() == 'Yes' ||
                            visitorData?.isParkingRequired == 1) {
                          isParkingRequired = true;
                        }
                      }
                    }else {
                      // Show error messages
                      if (date != null && currentDateTime.isBefore(date)) {
                        Utils.flushBarErrorMessage(
                            "Arrival date is tomorrow. Please come tomorrow.",
                            context);
                      } else if (date1 != null && currentDateTime.isAfter(date1)) {
                        Utils.flushBarErrorMessage(
                            "QR code is expired.", context);
                      }
                    }
                  }

                  else if ((visitorData?.visitTypeName == "Overnight Stay" ||
                      visitorData?.visitTypeId == 7) &&
                      visitorData?.visitorCheckInOutDate == null) {

                    if ((visitorArrivalDate != null) &&
                        (visitorArrivalDate == currentDateTime)) {
                      ischeckindate = true;
                      nameController.text = visitorData?.visitorName ?? " ";
                      mobilenumberController.text = visitorData?.visitorMobileNo ?? "";
                      carPlateNumberController.text = visitorData?.vehiclePlateNo ?? '';
                      drivingLicenceNumberController.text = visitorData?.idDrivingLicenseNo ?? '';
                      numberofvistorsController.text = visitorData?.noOfVisitor.toString() ?? '';
                      unitNumberController.text = visitorData?.unitNumber ?? '';
                      notesController.text = visitorData?.remarks ?? " ";
                      finalvalue = visitorData?.visitTypeName ?? '';
                      finalvalue1 = visitorData?.vistReason ?? "";
                      finalvalue2 = visitorData?.vehicleType ?? '';
                      visitTypeId = visitorData?.visitTypeId ?? 0;
                      visitReasonId = visitorData?.visitReasonId ?? 0 ;
                      vehicleTypeId = visitorData?.visitorTransportMode ??  0 ;
                      if (visitorData?.parkingRequired.toString() == 'Yes' ||
                          visitorData?.isParkingRequired == 1) {
                        isParkingRequired = true;
                      }
                      checkinDateController.text = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
                      Utils.flushBarErrorMessage(
                          "Your checkout date is tomorrow.", context);
                    } else {
                      if (visitorArrivalDate != null &&
                          currentDateTime.isBefore(visitorArrivalDate)) {
                        Utils.flushBarErrorMessage(
                            "Arrival date is tomorrow. Please come tomorrow.",
                            context);
                      } else {
                        Utils.flushBarErrorMessage(
                            "QR code is expired.", context);
                      }
                    }
                  }
                  else if ((visitorData?.visitTypeName == "Overnight Stay" ||
                      visitorData?.visitTypeId == 7) &&
                      visitorData?.visitorCheckInOutDate != null) {
                    List<VisitorCheckInOutDate>? visitorCheckInOutDates = visitorData?.visitorCheckInOutDate;
                    String? checkinDate;
                    if ((visitorArrivalDate != null) &&
                        (visitorArrivalDate == currentDateTime)) {
                      if (visitorCheckInOutDates != null && visitorCheckInOutDates.isNotEmpty) {
                        checkinDate =
                            visitorCheckInOutDates.last.visitorCheckinDate
                                .toString();
                        ischeckindate = true;
                        ischeckoutDate = true;

                        nameController.text = visitorData?.visitorName ?? " ";
                        mobilenumberController.text =
                            visitorData?.visitorMobileNo ?? "";
                        carPlateNumberController.text =
                            visitorData?.vehiclePlateNo ?? '';
                        drivingLicenceNumberController.text =
                            visitorData?.idDrivingLicenseNo ?? '';
                        numberofvistorsController.text =
                            visitorData?.noOfVisitor.toString() ?? '';
                        unitNumberController.text = visitorData?.unitNumber ?? '';
                        notesController.text = visitorData?.remarks ?? " ";
                        finalvalue = visitorData?.visitTypeName ?? '';
                        finalvalue1 = visitorData?.vistReason ?? "";
                        finalvalue2 = visitorData?.vehicleType ?? '';
                        visitTypeId = visitorData?.visitTypeId ?? 0;
                        visitReasonId = visitorData?.visitReasonId ?? 0 ;
                        vehicleTypeId = visitorData?.visitorTransportMode ??  0 ;
                        checkinDateController.text = checkinDate;
                        checkoutDateController.text =
                            DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
                        if (visitorData?.parkingRequired.toString() == 'Yes' ||
                            visitorData?.isParkingRequired == 1) {
                          isParkingRequired = true;
                        }
                      }
                    }else {
                      if (visitorArrivalDate != null &&
                          currentDateTime.isBefore(visitorArrivalDate)) {
                        Utils.flushBarErrorMessage(
                            "Arrival date is tomorrow. Please come tomorrow.",
                            context);
                      } else {
                        Utils.flushBarErrorMessage(
                            "QR code is expired.", context);
                      }
                    }
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

  void submitRegisterDetails() async {
    if (nameController.text.isEmpty) {
      Utils.flushBarErrorMessage('Name can\'t be empty', context);
    } else if (mobilenumberController.text.isEmpty) {
      Utils.flushBarErrorMessage('mobile Number can\'t be empty', context);
    } else if (carPlateNumberController.text.isEmpty) {
      Utils.flushBarErrorMessage('vehicleNumber can\'t be empty', context);
    } else if (drivingLicenceNumberController.text.isEmpty) {
      Utils.flushBarErrorMessage(
          'drivinglicenceNumber can\'t be empty', context);
    } else if (arrivalDateController.text.isEmpty) {
      Utils.flushBarErrorMessage('date can\'t be empty', context);
    } else if (arrivalTimeController.text.isEmpty) {
      Utils.flushBarErrorMessage('time can\'t be empty', context);
    } else if (numberofvistorsController.text.isEmpty) {
      Utils.flushBarErrorMessage('Number of visitors can\'t be empty', context);
    } else {
      int numberofvisitors;
      int duration;
      var registeredid = 0;

      final numberofVisitorsText = numberofvistorsController.text;

      if (int.tryParse(numberofVisitorsText) != null) {
        numberofvisitors = int.parse(numberofVisitorsText);
      } else {
        Utils.flushBarErrorMessage(
            'Invalid number of visitors: $numberofVisitorsText', context);
        return;
      }

      if (appusagetypeId == 21) {
        registeredid == 0;
      } else {
        registeredid == 1;
      }
      // if (entryType == "One Time" || entryType == "overnight stay"){
      //
      // }
      //
      String? arrivaldate;
      String? checkinFormatteddate;
      String? checkoutFormatteddate;
      if (arrivalDateController.text.isNotEmpty) {
        DateTime dateTime1 = DateFormat('yyyy-MM-dd')
            .parse(arrivalDateController.text.toString());
        arrivaldate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime1);
      }


      if (checkinDateController.text.isNotEmpty) {
        DateTime checkinformatter = DateFormat('yyyy-MM-dd hh:mm a')
            .parse(checkinDateController.text.toString());
        checkinFormatteddate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(checkinformatter);
        print(" checkindate= $checkinFormatteddate");
      }
      // checkoutdate

      if (checkoutDateController.text.isNotEmpty) {
        DateTime checkoutformatter = DateFormat('yyyy-MM-dd hh:mm a')
            .parse(checkoutDateController.text.toString());
        checkoutFormatteddate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(checkoutformatter);
        print("checkout =$checkoutFormatteddate");
      }

      Map<String, dynamic> data = {
        "block_name": blockName,
        "id_driving_license_no": drivingLicenceNumberController.text,
        "is_parking_required": isParkingRequired ? 1 : 0,
        "is_preregistered": registeredid,
        "no_of_visitor": numberofvisitors,
        "prereg_end_date": visitorData?.preregEndDate,
        "prereg_reqdate_mgmt_approve_status": 0,
        "prereg_start_date": visitorData?.preregStartDate,
        "property_id": 10000002,
        "rec_status": "8",
        "registration_qrcode": "string",
        "registration_qrcode_img": "string",
        "remarks": notesController.text,
        "unit_device_cnt": unitDeviceCnt,
        "unit_number": unitNumberController.text,
        "updated_by": userId,
        "user_id": userId,
        "user_type_id": userTypeId,
        "vehicle_plate_no": carPlateNumberController.text,
        "visit_reason_id": visitReasonId,
        "visit_type_id": visitTypeId,
        "visitor_arrival_date": arrivaldate,
        "visitor_arrival_time": arrivalTimeController.text,
        "visitor_mobile_no": mobilenumberController.text,
        "visitor_name": nameController.text,
        "visitor_registr_date":
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now()),
        "visitor_registrstion_status_id": 228,
        "visitor_stay_duration_hours": 0,
        "visitor_stay_enddate":
        checkoutFormatteddate ,
        "visitor_stay_startdate":
        checkinFormatteddate ,

        "visitor_transport_mode": vehicleTypeId
      };

      viewModel.updateVisitorRegistration(data, id, context).then((value) {
        if (value.data!.status == 200) {
          print('msg = ${value.data!.mobMessage}');
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        } else {
          Utils.flushBarErrorMessage(" Update Failed".toString(), context);
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
  void dispose() {
    qrViewController?.dispose();
    nameController.dispose();
    carPlateNumberController.dispose();
    drivingLicenceNumberController.dispose();
    visitReasonController.dispose();
    unitNumberController.dispose();
    numberofvistorsController.dispose();
    arrivalDateController.dispose();
    arrivalTimeController.dispose();
    durationController.dispose();
    checkinDateController.dispose();
    checkoutDateController.dispose();
    mobilenumberController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),

                  MyTextField(
                    labelText: 'Name',
                    hintText: 'Name',
                    controller: nameController,
                    textInputType: TextInputType.text,
                    preffixIcon: Icons.person,
                  ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  // ),
                  MyTextField(
                      labelText: 'Unit No.',
                      hintText: 'Unit No.',
                      controller: unitNumberController,
                      textInputType: TextInputType.text,
                      preffixIcon: Icons.home),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  // ),
                  MyTextField(
                    labelText: 'Mobile No.',
                    hintText: 'Mobile No.',
                    controller: mobilenumberController,
                    textInputType: TextInputType.text,
                    preffixIcon: Icons.phone_iphone,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  MyTextField(
                    labelText: 'Car Plate No.',
                    hintText: 'Car Plate No.',
                    controller: carPlateNumberController,
                    textInputType: TextInputType.text,
                    preffixIcon: CupertinoIcons.car,
                  ),

                  MyTextField(
                      labelText: 'ID/Driving License No',
                      hintText: 'ID/Driving License No',
                      controller: drivingLicenceNumberController,
                      textInputType: TextInputType.text,
                      preffixIcon: Icons.credit_card_rounded),

                  // VisitTypeDropdown
                  ChangeNotifierProvider.value(
                      value: viewModel,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Consumer<InviteVisitorViewModel>(
                            builder: (context, viewModel, _) {
                              if (viewModel.visitTypeResponse.status ==
                                  Status.loading) {

                              } else if (viewModel.visitTypeResponse.status ==
                                  Status.error) {
                                return Center(
                                  child: Text(viewModel.visitTypeResponse.message
                                      .toString()),
                                );
                              } else if (viewModel.visitTypeResponse.status ==
                                  Status.success) {
                                List<DropdownMenuItem<String>>
                                dataTypedropdownItems = [];

                                if (viewModel
                                    .visitTypeResponse.data?.result?.items !=
                                    null) {
                                  Set<String> enterprisecategoryNames = Set();
                                  viewModel.visitTypeResponse.data!.result!.items!
                                      .forEach((item) {
                                    if (item.visitType != null) {
                                      enterprisecategoryNames.add(item.visitType!);
                                    }
                                  });

                                  dataTypedropdownItems.addAll(
                                    enterprisecategoryNames
                                        .map(
                                          (visitType) => DropdownMenuItem<String>(
                                        value: visitType,
                                        child: Text(
                                          visitType,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                    )
                                        .toList(),
                                  );
                                }

                                if (dataTypedropdownItems.length == 1) {
                                  dataTypedropdownItems.add(
                                    DropdownMenuItem<String>(
                                      value: 'no_item',
                                      child: Text('No item'),
                                    ),
                                  );
                                }
                                String? visitTypeValue =
                                    visitorData?.visitTypeName ?? '';
                                entryType = visitTypeValue ?? '';
                                if (visitTypeValue.isEmpty) {
                                  visitTypeValue =
                                      dataTypedropdownItems.first.value;
                                }
                                return MyDropDown(
                                  hintText: 'Select Entry Type',
                                  value: visitTypeValue,
                                  // Set the initial value from qrData
                                  labelText: 'Entry Type',
                                  items: dataTypedropdownItems,
                                  onchanged: (value) {
                                    setState(() {
                                      // Update the selected value and perform any other necessary actions
                                      finalvalue = value.toString();

                                      visitTypeId = 0;
                                      for (int i = 0;
                                      i <
                                          viewModel.visitTypeResponse.data!
                                              .result!.items!.length;
                                      i++) {
                                        if (value ==
                                            viewModel.visitTypeResponse.data!
                                                .result!.items![i].visitType) {
                                          visitTypeId = viewModel.visitTypeResponse
                                              .data!.result!.items![i].id!;
                                          break;
                                        }
                                      }
                                    });
                                  },
                                );
                              }

                              return Text("");
                            }),
                      ])),
                  // VisitReasonDropdown
                  ChangeNotifierProvider.value(
                      value: viewModel,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Consumer<InviteVisitorViewModel>(
                            builder: (context, viewModel, _) {
                              if (viewModel.visitReasonResponse.status ==
                                  Status.loading) {
                                return Center(

                                );
                              } else if (viewModel.visitReasonResponse.status ==
                                  Status.error) {
                                return Center(
                                  child: Text(viewModel.visitReasonResponse.message
                                      .toString()),
                                );
                              } else if (viewModel.visitReasonResponse.status ==
                                  Status.success) {
                                List<DropdownMenuItem<String>>
                                dataTypedropdownItems = [];

                                if (viewModel
                                    .visitReasonResponse.data?.result?.items !=
                                    null) {
                                  Set<String> enterprisecategoryNames = Set();
                                  viewModel.visitReasonResponse.data!.result!.items!
                                      .forEach((item) {
                                    if (item.visitReason != null) {
                                      enterprisecategoryNames
                                          .add(item.visitReason!);
                                    }
                                  });

                                  dataTypedropdownItems.addAll(
                                    enterprisecategoryNames
                                        .map(
                                          (visitType) => DropdownMenuItem<String>(
                                        value: visitType,
                                        child: Text(
                                          visitType,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                    )
                                        .toList(),
                                  );
                                }

                                if (dataTypedropdownItems.length == 1) {
                                  dataTypedropdownItems.add(
                                    DropdownMenuItem<String>(
                                      value: 'no_item',
                                      child: Text('No item'),
                                    ),
                                  );
                                }
                                String? visitReasonValue =
                                    visitorData?.vistReason ?? '';
                                if (visitReasonValue.isEmpty) {
                                  visitReasonValue =
                                      dataTypedropdownItems.first.value;
                                }
                                return MyDropDown(
                                  hintText: 'Select Purpose of Visit Reason',
                                  // value: qrData?['Visit Reason'] != null ? qrData ??['Visit Reason']! : '',
                                  value: visitReasonValue,
                                  // qrData?['Visit Reason'],
                                  labelText: 'Purpose of Visit  ',
                                  items: dataTypedropdownItems,
                                  onchanged: (value) {
                                    setState(() {
                                      finalvalue1 = value.toString();

                                      visitReasonId = 0;
                                      for (int i = 0;
                                      i <
                                          viewModel.visitReasonResponse.data!
                                              .result!.items!.length;
                                      i++) {
                                        if (value ==
                                            viewModel.visitReasonResponse.data!
                                                .result!.items![i].visitReason) {
                                          visitReasonId = viewModel
                                              .visitReasonResponse
                                              .data!
                                              .result!
                                              .items![i]
                                              .id!;
                                          break;
                                        }
                                      }
                                    });
                                  },
                                );
                              }

                              return Text("");
                            }),
                      ])),

                  // VehicleTypeDropdown
                  Row(
                    children: [
                      Expanded(
                        child: ChangeNotifierProvider.value(
                            value: viewModel,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<InviteVisitorViewModel>(
                                      builder: (context, viewModel, _) {
                                        if (viewModel.vehicleTypeResponse.status ==
                                            Status.loading) {
                                          return Center(
                                            // child: CircularProgressIndicator(
                                            //   valueColor:
                                            //   AlwaysStoppedAnimation<Color>(Colors.amber),
                                            // ),
                                          );
                                        } else if (viewModel
                                            .vehicleTypeResponse.status ==
                                            Status.error) {
                                          return Center(
                                            child: Text(viewModel
                                                .vehicleTypeResponse.message
                                                .toString()),
                                          );
                                        } else if (viewModel
                                            .vehicleTypeResponse.status ==
                                            Status.success) {
                                          List<DropdownMenuItem<String>>
                                          dataTypedropdownItems = [];

                                          if (viewModel.vehicleTypeResponse.data
                                              ?.result?.items !=
                                              null) {
                                            Set<String> enterprisecategoryNames =
                                            Set();
                                            viewModel.vehicleTypeResponse.data!
                                                .result!.items!
                                                .forEach((item) {
                                              if (item.vehicleType != null) {
                                                enterprisecategoryNames
                                                    .add(item.vehicleType!);
                                              }
                                            });

                                            dataTypedropdownItems.addAll(
                                              enterprisecategoryNames
                                                  .map(
                                                    (vehicleType) =>
                                                    DropdownMenuItem<String>(
                                                      value: vehicleType,
                                                      child: Text(
                                                        vehicleType,
                                                        style:
                                                        Theme.of(context).textTheme.bodySmall,
                                                      ),
                                                    ),
                                              )
                                                  .toList(),
                                            );
                                          }

                                          if (dataTypedropdownItems.length == 1) {
                                            dataTypedropdownItems.add(
                                              DropdownMenuItem<String>(
                                                value: 'no_item',
                                                child: Text('No item'),
                                              ),
                                            );
                                          }
                                          String? vehicleTypeValue =
                                              visitorData?.vehicleType ?? '';
                                          ;
                                          if (vehicleTypeValue.isEmpty) {
                                            vehicleTypeValue =
                                                dataTypedropdownItems.first.value;
                                          }
                                          return MyDropDown(
                                            hintText: 'Select Vehicle Type',
                                            // value: qrData?['Vehicle Type'] != null ? qrData ??['Vehicle Type']! : '',
                                            value: vehicleTypeValue,
                                            // qrData?['Vehicle Type'],

                                            labelText: 'Vehicle Type',
                                            items: dataTypedropdownItems,
                                            onchanged: (value) {
                                              setState(() {
                                                finalvalue2 = value.toString();

                                                vehicleTypeId = 0;
                                                for (int i = 0;
                                                i <
                                                    viewModel
                                                        .vehicleTypeResponse
                                                        .data!
                                                        .result!
                                                        .items!
                                                        .length;
                                                i++) {
                                                  if (value ==
                                                      viewModel
                                                          .vehicleTypeResponse
                                                          .data!
                                                          .result!
                                                          .items![i]
                                                          .vehicleType) {
                                                    vehicleTypeId = viewModel
                                                        .vehicleTypeResponse
                                                        .data!
                                                        .result!
                                                        .items![i]
                                                        .id!;
                                                    break;
                                                  }
                                                }
                                              });
                                            },
                                          );
                                        }

                                        return Text("");
                                      }),
                                ])),
                      ),
                      SizedBox(
                        width: 140,
                        child: Row(
                          children: [
                            Text('Parking Req.',
                                style: Theme.of(context).textTheme.bodySmall),
                            Checkbox(
                              activeColor: Colors.orange.shade900,
                              checkColor: Colors.white,
                              value: isParkingRequired,
                              onChanged: (changedValue) {
                                setState(() {
                                  isParkingRequired = changedValue ?? false;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  // ),
                  MyTextField(
                      labelText: 'No.of Visitors',
                      hintText: 'No.of Visitors',
                      controller: numberofvistorsController,
                      textInputType: TextInputType.text,
                      preffixIcon: Icons.person_add_rounded),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  // if(entryType == "One Time" || entryType == "overnight stay")
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: arrivalDateController,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixText: ' ',
                              hintText: 'Arrival Date',

                              prefixIcon: Icon(
                                Icons.calendar_today,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: TextFormField(
                              controller: arrivalTimeController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodySmall,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: 'Arrival Time',
                                suffixIcon: Icon(
                                  Icons.access_time,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),

                  Visibility(
                    visible: ischeckindate,
                    child: MyDateField(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                      },
                      // enabled: ischeckindate ? true : false,
                      controller: checkinDateController,
                      hintText: 'Checkin Date',
                      labelText: 'Checkin Date',
                      preffixIcon: Icons.calendar_today,
                    ),
                  ),
                  if(ischeckindate == true && ischeckoutDate == true)
                    MyTextField(
                      labelText: 'Checkin Date',
                      hintText: 'Checkin Date',
                      controller: checkinDateController,
                      textInputType: TextInputType.text,
                      preffixIcon: Icons.calendar_today,
                    ),
                  Visibility(
                    visible: ischeckoutDate,
                    child: MyDateField(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                      },
                      controller: checkoutDateController,
                      hintText: 'Checkout Date',
                      labelText: 'Checkout Date',
                      preffixIcon: Icons.calendar_today,
                    ),
                  ),
                  MyTextField(
                    labelText: "Remarks",
                    hintText: 'Remarks',
                    controller: notesController,
                    textInputType: TextInputType.text,
                    preffixIcon: Icons.sticky_note_2_sharp,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // if (arrivalDate != null && (arrivalDate.isBefore(currentDate) || arrivalDate.isAfter(currentDate)))
                  Visibility(
                    visible: ischeckindate,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: PositiveButton(
                          onPressed: () async {
                            setState(() {
                              submitRegisterDetails();
                            });
                            nameController.clear();

                            carPlateNumberController.clear();
                            drivingLicenceNumberController.clear();
                            visitReasonController.clear();
                            unitNumberController.clear();
                            numberofvistorsController.clear();
                            arrivalDateController.clear();
                            arrivalTimeController.clear();
                            durationController.clear();
                            mobilenumberController.clear();
                            notesController.clear();
                            checkinDateController.clear();
                            checkoutDateController.clear();
                            setState(() {
                              isParkingRequired = false;
                              finalvalue = null;
                              finalvalue1 = null;
                              finalvalue2 = null;
                              ischeckindate = false;
                            });
                          },

                          // text: ischeckindate ? "CheckIn" : "Checkout"
                          // ischeckindate && ischeckoutDate ? "Checkout" :
                          text:  "CheckIn",
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: ischeckindate && ischeckoutDate,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: PositiveButton(
                          onPressed: () async {
                            setState(() {
                              submitRegisterDetails();
                            });
                            nameController.clear();

                            carPlateNumberController.clear();
                            drivingLicenceNumberController.clear();
                            visitReasonController.clear();
                            unitNumberController.clear();
                            numberofvistorsController.clear();
                            arrivalDateController.clear();
                            arrivalTimeController.clear();
                            durationController.clear();
                            mobilenumberController.clear();
                            notesController.clear();
                            checkinDateController.clear();
                            checkoutDateController.clear();
                            setState(() {
                              isParkingRequired = false;
                              finalvalue = null;
                              finalvalue1 = null;
                              finalvalue2 = null;
                              ischeckindate = false;
                              ischeckoutDate = false;
                            });
                          },
                          text: "Checkout",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
