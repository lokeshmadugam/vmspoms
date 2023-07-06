import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poms_app/utils/CardData.dart';
import 'package:poms_app/utils/MyDateField.dart';
import 'package:poms_app/utils/MyTextfield.dart';
import 'package:poms_app/view/visitorreg/ParkingAvailableScreen.dart';
import 'package:poms_app/viewmodel/visitorregistration/ParkingViewModel.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/visitorreg/FavoriteVisitors.dart';
import '../../model/visitorreg/ParkingModel.dart';
import '../../model/visitorreg/VehicleTypeModel.dart';
import '../../model/visitorreg/VisitReasonModel.dart';
import '../../model/visitorreg/VisitorDetailsModel.dart';
import '../../model/visitorreg/VisitorTypeModel.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/visitorregistration/InviteVisitorViewModel.dart';
import 'ContactsScreen.dart';
import '../../viewmodel/FileStorage.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../data/respose/ApiResponse.dart';
import '../../data/respose/Status.dart';
import '../../model/MediaUpload.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/utils.dart';

class InviteGuestScreen extends StatefulWidget {
  var contact;
var favoritevisitor;
  InviteGuestScreen({
    Key? key,
    required this.contact,
    this.favoritevisitor
  }) : super(key: key);

  @override
  State<InviteGuestScreen> createState() => _InviteGuestScreenState();
}

class _InviteGuestScreenState extends State<InviteGuestScreen> {
  var viewModel = InviteVisitorViewModel();
  var userVM = UserViewModel();
  var fileStgVM = FileStorageViewModel();
  var parkingVM = ParkingViewModel();
  TextEditingController nameController = TextEditingController();
  TextEditingController carPlateNumberController = TextEditingController();
  TextEditingController drivingLicenceNumberController =
      TextEditingController();
  TextEditingController visitReasonController = TextEditingController();
  TextEditingController numberofvistorsController = TextEditingController();
  TextEditingController arrivalDateController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController blockNameController = TextEditingController();
  TextEditingController visitTypeController = TextEditingController();
  TextEditingController assignedParkingLotController = TextEditingController();
  List<bool> isSelected = [true, false];
  var finalvalue;
  var finalvalue1;
  var finalvalue2;
  int visitTypeId = 0;
  int visitReasonId = 0;
  int vehicleTypeId = 0;
  int secuvisitTypeId = 0;
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
  VisitorResult? visitorData;
  int visitorId = 0;
  String imageUrl = '';
  String userTypeName = '';
  var bayType;

  var bayNumber;
  Contact? _contact;
  List<FavoriteVisitorsItems> items = [];
  @override
  void initState() {
    super.initState();
    getUserDetails();

    if (widget.contact != null) {
      _contact = widget.contact;
      name = _contact?.displayName;

      phoneNumber = _contact?.phones.first.value;
      print('Name: $name');
      print('Phone Number: $phoneNumber');
    }

    nameController = TextEditingController(text: name);

    mobilenumberController = TextEditingController(text: phoneNumber);
    if(widget.favoritevisitor != null){
      setState(() {
        items = widget.favoritevisitor; // Assign the list to the items variable
        print("object = $items");
        nameController.text = items[0].visitorName.toString();
        mobilenumberController.text = items[0].visitorMobileNo.toString();
        if(items[0].visitReasonId != 0){
          visitReasonId = items[0].visitReasonId ?? 0;
        }

        vehicleTypeId = items[0].visitorTransportMode ?? 0;
        carPlateNumberController.text = items[0].vehiclePlateNo.toString();
        drivingLicenceNumberController.text = items[0].idDrivingLicenseNo.toString();
        numberofvistorsController.text = items[0].noOfVisitor.toString();
        notesController.text = items[0].remarks.toString();
        if(items[0].isParkingRequired == 1){
          isParkingRequired =true;
        }
      });

    }
    // fetchVisitType1();
    // fetchVisitReasons1();
    // fetchVehicleType1();
    fetchVisitType();
    fetchVisitReasons();
    fetchVehicleType();
    // fetchVisitorStatus();
  }

  String firstName = "";
  String lastName = "";
  List<VehicleTypeItems> vehicleTypeItems = [];
  List<VisitReasonItems> visitReasonsItems = [];
  List<VisitTypeItems> visitTypeItems = [];
  List<ParkingItem> parkingItems = [];

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;

      userId = userid ?? 0;
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      unitDeviceCnt = unitdevicecnt ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      appusagetypeId = appusagetypeid ?? 0;
      final name = value.userDetails?.firstName;
      final userType = value.userDetails?.roleName;
      firstName = name ?? '';

      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';

      setState(() {
        firstName = name ?? '';
        print(firstName);
        lastName = lastname ?? '';
        print(lastName);
        userTypeName = userType ?? '';
      });
    });
  }



  void fetchVisitType() async {
    viewModel.getVisitorType().then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              visitTypeItems = data;
            });
            for (var item in data) {
              final visittype = item.visitType ?? "";
              var id = item.id ?? 0;
// visitTypeId = id;
// finalvalue = item.visitType ?? "";
              if (userTypeName != "Resident User") {
                if (visittype == "One Time" || id == 1) {
                  setState(() {
                    visitTypeController.text = visittype;

                    secuvisitTypeId = id;
                  });
                }
              }
            }

          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchParkingData() async {
    parkingVM
        .getParking(
      "ASC",
      "id",
      1,
      500,
      propertyId,
      // '0',
      unitNumberController.text,
    )
        .then((response) async {
      if (response.data?.status == 200) {
        if (response.data?.unOccupied != null) {
          var data = response.data!.unOccupied!.items;
          if (data != null) {
            setState(() {
              parkingItems = data;
            });

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ParkingAvailableScreen(data: parkingItems)),
            );
            if (result != null) {
              var baynumber = result['bayNumber'] as String;
              print("bay = $baynumber");
              var baytype = result['bayType'].toString();

              print("type = $baytype");
              setState(() {
                // bayNumber = baynumber;
                assignedParkingLotController.text = baynumber;
                // Use the bayType value as needed
                bayType = baytype;
              });
            }
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  void fetchVisitReasons() async {
    viewModel.getVisitReasons().then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              visitReasonsItems = data;
for(var i in visitReasonsItems){


  if(visitReasonId == i.id ){
    finalvalue1 = i.visitReason.toString();
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
  //
  void fetchVehicleType() async {
    viewModel.getVehicleTypes().then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            for (var item in data){

            }
            setState(() {

              vehicleTypeItems = data;
              for(var i in vehicleTypeItems){


                if(vehicleTypeId == i.id ){
                  finalvalue2 = i.vehicleType.toString();
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
  // Function to fetch visitors status and get IDs
  // void fetchVisitorStatus() async {
  //   await viewModel.getVisitorsStatus("ASC", "id", 1, 25, "VMS", "VisitorStatus");
  //   final data = viewModel.visitorStatusResponse.data?.result?.items;
  //   if (data != null) {
  //     for (var item in data) {
  //       final id = item.keyValue;
  //       print('ID: $id');
  //     }
  //   }
  // }

  String visitType = '';
  String visitReason = '';
  String? _qrData;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    carPlateNumberController.dispose();
    drivingLicenceNumberController.dispose();
    visitReasonController.dispose();
    unitNumberController.dispose();
    blockNameController.dispose();
    visitTypeController.dispose();
    numberofvistorsController.dispose();
    arrivalDateController.dispose();
    arrivalTimeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    mobilenumberController.dispose();
    notesController.dispose();
    assignedParkingLotController.dispose();
  }

  final GlobalKey _globalKey = GlobalKey();

  void _generateQRData() async {
    int _id = visitorData?.id ?? 0;
    String _visitorName = visitorData?.visitorName ?? '';
    String _visitorMobileNo = visitorData?.visitorMobileNo ?? '';
    String _numberofvisitors = visitorData?.noOfVisitor.toString() ?? '';
    String _vehiclenumber = visitorData?.vehiclePlateNo ?? '';
    String _drivinglicence = visitorData?.idDrivingLicenseNo ?? '';
    String _visittype = visitorData?.visitTypeName ?? '';
    String _visitReason = visitorData?.vistReason ?? '';
    String _vehicleType = visitorData?.vehicleType ?? '';
    String _parkingRequired = visitorData?.parkingRequired ?? '';
    if(visitorData?.visitorArrivalDate != null || visitorData!.visitorArrivalDate.toString().isNotEmpty ) {
      String _arrivalDate = visitorData?.visitorArrivalDate ?? '';
    }
    // Debug prints
    print('_visitorName: $_visitorName');
    print('_visiorMobileNo: $_visitorMobileNo');
    print('_numberofvisitors: $_numberofvisitors');
    print('_vehiclenumber: $_vehiclenumber');
    print('_drivingliecence: $_drivinglicence');
    print('_visittype: $_visittype');
    print('_visitReason: $_visitReason');
    print('_vehicleType: $_vehicleType');

    _qrData = 'Id :$_id\n'
        'Unit No.: $unitNumber\n'
        'Visitor Name: $_visitorName\n'
        'Mobile Number: $_visitorMobileNo\n'
        'Visit Type: $_visittype\n'
        'Visit Reason: $_visitReason\n'
        'Vehicle Type:$_vehicleType\n'
        'Vehicle Number: $_vehiclenumber\n'
        'Number of Visitors: $_numberofvisitors\n'
        'Parking Required:$_parkingRequired\n'
        'Driving Liecence No: $_drivinglicence\n';
    // 'Arrival Date':
  }

  Future<String?> _generateQRCodeImage() async {
    _generateQRData(); // Call the function to generate QR data

    try {
      final boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        final pngBytes = byteData?.buffer.asUint8List();

        if (pngBytes != null) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/qr_code.png';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(pngBytes);
          print(imagePath);
          return imagePath;
        }
      }
    } catch (e) {
      print('Error occurred while generating QR code image: $e');
    }

    return null; // Return null if an error occurred
  }

  void _shareQRCode() async {
    try {
      final imagePath = await _generateQRCodeImage();
      print('image = $imagePath');
      if (imagePath != null) {
        await Share.shareFiles([imagePath], text: _qrData);
      } else {
        throw Exception('Failed to generate QR code image');
      }
    } catch (e) {
      print('Error occurred while sharing QR code: $e');
    }
  }

  Future<void> submitRegisterDetails() async {
    if (nameController.text.isEmpty) {
      Utils.flushBarErrorMessage('Name can\'t be empty', context);
    } else if (mobilenumberController.text.isEmpty) {
      Utils.flushBarErrorMessage('mobile Number can\'t be empty', context);
    }
    // else if (carPlateNumberController.text.isEmpty) {
    //   Utils.flushBarErrorMessage('vehicleNumber can\'t be empty', context);
    // } else if (drivingLicenceNumberController.text.isEmpty) {
    //   Utils.flushBarErrorMessage(
    //       'drivinglicenceNumber can\'t be empty', context);
    // }
    else {
      int numberofvistors =
          int.parse(numberofvistorsController.text.toString());
      // int duration = int.parse(durationController.text.toString());
      var registeredid = 0;
      if (appusagetypeId == 21) {
        registeredid == 0;
      } else {
        registeredid == 1;
      }
      String formattedDate = '';
      if (arrivalDateController.text.isNotEmpty) {
        DateTime date = DateFormat.yMd().parse(arrivalDateController.text);
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        formattedDate = formatter.format(date);
      }
      String? startDate;
      String? endDate;
      if (startDateController.text.isNotEmpty) {
        DateTime date1 = DateFormat.yMd().parse(startDateController.text);
        DateFormat formatter = DateFormat('yyyy-MM-dd');

        startDate = formatter.format(date1);
      }
      if (endDateController.text.isNotEmpty) {
        DateTime date2 = DateFormat.yMd().parse(endDateController.text);
        DateFormat formatter = DateFormat('yyyy-MM-dd');

        endDate = formatter.format(date2);
      }
      String? unitnumber;
      String? blockname;
      int? entrytypeid;
      if (userTypeName == "Resident User") {
        unitnumber = unitNumber;
        blockname = blockName;
        entrytypeid = visitTypeId;
      } else {
        unitnumber = unitNumberController.text;
        blockname = blockNameController.text;
        entrytypeid = secuvisitTypeId;
      }
      if (userTypeName == "Resident User") {}
      Map<String, dynamic> data = {
        "block_name": blockname,
        "created_by": userId,
        "id_driving_license_no": drivingLicenceNumberController.text,
        "is_parking_required": isParkingRequired ? 1 : 0,
        "is_preregistered": registeredid,
        "no_of_visitor": numberofvistors,
        "parkingLotUsageRest": {
          "bay_status": 0,
          "bay_type": bayType,
          "created_by": userId,
          "lot_number": assignedParkingLotController.text,
          "property_id": propertyId,
          "rec_status": 8,
          "unit_shop_id": 0,
          "usage_date":
              DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now()),
          "usage_fr_time": "2023-06-03T05:08:46.446Z",
          "usage_to_time": "2023-06-03T05:08:46.446Z",
          "visitor_id": 0
        },
        "prereg_end_date": endDate,
        "prereg_reqdate_mgmt_approve_status": "string",
        "prereg_start_date": startDate,
        "property_id": propertyId,
        "rec_status": 8,
        "registration_qrcode": "string",
        "registration_qrcode_img": "string",
        "remarks": notesController.text,
        "unit_device_cnt": unitDeviceCnt,
        "unit_number": unitnumber,
        "user_id": userId,
        "user_type_id": userTypeId,
        "vehicle_plate_no": carPlateNumberController.text,
        "visit_reason_id": visitReasonId,
        "visit_type_id": entrytypeid,
        "visitor_arrival_date": formattedDate,
        "visitor_arrival_time": arrivalTimeController.text,
        "visitor_mobile_no": mobilenumberController.text,
        "visitor_name": nameController.text,
        "visitor_registr_date": "2023-06-03T05:08:46.446Z",
        "visitor_registrstion_status_id": 228,
        "visitor_stay_duration_hours": 0,
        "visitor_stay_enddate": "2023-06-03T05:08:46.446Z",
        "visitor_stay_startdate": "2023-06-03T05:08:46.446Z",
        "visitor_transport_mode": vehicleTypeId
      };

      viewModel.visitorRegistration(data, context).then((value) {
        if (value.data!.status == 201) {
          print('msg = ${value.data!.mobMessage}');
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);

          final id = value.data!.result;
          visitorId = id!;
          print(visitorId);

          // Call fetchVisitorDetails() directly from your view
          fetchVisitorDetails();
          // viewModel.getVisitorDetails(visitorId);
        } else {
          Utils.flushBarErrorMessage(
              " Registration Failed".toString(), context);
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          Utils.flushBarErrorMessage(error.toString(), context);
          print(error.toString());
        }
      });
    }
  }

  Future<void> fetchVisitorDetails() async {
    ApiResponse response = await viewModel.getVisitorDetails(visitorId);
    if (response.data!.status == 200) {
      setState(() {
        visitorData = response.data!.result;
        setState(() {
          _generateQRData();
        });
        vistorDetailsPopup(context);
        // WidgetsBinding.instance!.addPostFrameCallback((_) {
        //   vistorDetailsPopup(context);
        // });
        print(visitorData?.name);
      });
    } else {
      print(response.message);
    }
  }

  Future<void> vistorDetailsPopup(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: SingleChildScrollView(
                  child: Column(children: [
                SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.03,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                  child: Image.asset(
                      'assets/images/VMS-POMS_Logo1.png',
                      height: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                  child: Text('E - Residences', style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 15) )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            firstName,
                            style: GoogleFonts.roboto(textStyle:TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF002449))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "-",
                            style:GoogleFonts.roboto(textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF002449)),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            blockName ?? '',
                            style: GoogleFonts.roboto(textStyle:TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF002449))),
                          ),

                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            unitNumber ?? '',
                            style: GoogleFonts.roboto(textStyle:TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF002449))),
                          ),
                          // Text(lastName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.11,
                    // width: MediaQuery.of(context).size.width * 0.50,
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: Column(
                        children: [
                          QrImageView(
                            data: _qrData ?? '',
                            version: QrVersions.auto,
                            size: MediaQuery.of(context).size.height * 0.20,
                            gapless: false,
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(visitorData?.registrationQrcode ?? " ",
                      style: TextStyle(fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 5, right: 5, bottom: 10),
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.37,
                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color(0xFFD3D3D3FF),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          ContainerValue(
                            text: "Visitor Name",
                            value: ": ${visitorData?.visitorName ?? ''}",
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          ContainerValue(
                            text: "Mobile No.",
                            value: ": ${visitorData?.visitorMobileNo ?? ''}",
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          ContainerValue(
                            text: "Visit Type",
                            value: ": ${visitorData?.visitTypeName ?? ''}",
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          ContainerValue(
                            text: "Vehicle Number",
                            value: ": ${visitorData?.vehiclePlateNo ?? ''}",
                            // value: ": ${visitorData?.visitorRegistrDate != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(visitorData?.visitorRegistrDate.toString())) : ''} ${item.visitorArrivalTime}",
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          ContainerValue(
                            text: "Purpose of Visit",
                            value: ": ${visitorData?.vistReason ?? ''}",
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          ContainerValue(
                            text: "ID/Driver\'s License",
                            value: ": ${visitorData?.idDrivingLicenseNo ?? ''}",
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          ContainerValue(
                            text: "No. of Visitor",
                            value:
                                ": ${visitorData?.noOfVisitor.toString() ?? ''}",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.indigo.shade900,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        onPressed: () {
                          _shareQRCode();
                        },
                        icon: Icon(Icons.share),
                        label: Text(
                          'Share',
                        )),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.10),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.indigo.shade900,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        label: Text('Close')),
                  ],
                )
              ])),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 8),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              MyTextField(
                hintText: 'Name',
                labelText: 'Name',
                preffixIcon: Icons.person,
                controller: nameController,
                textInputType: TextInputType.text,
              ),

              if (userTypeName != "Resident User")
                Visibility(
                  visible: true,
                  child: MyTextField(
                    hintText: 'Block Name',
                    labelText: 'Block Name',
                    controller: blockNameController,
                    textInputType: TextInputType.text,
                    preffixIcon: Icons.apartment,
                  ),
                ),

              if (userTypeName != "Resident User")
                Visibility(
                  visible: true,
                  child: MyTextField(
                    hintText: 'Unit No.',
                    labelText: 'Unit No.',
                    controller: unitNumberController,
                    textInputType: TextInputType.text,
                    preffixIcon: Icons.home,
                  ),
                ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.005,
              // ),
              MyTextField(
                labelText: 'Mobile No.',
                hintText: 'Mobile No.',
                controller: mobilenumberController,
                textInputType: TextInputType.text,
                preffixIcon: Icons.phone_iphone,
              ),

              // VisitTypeDropdown
              if (userTypeName == "Resident User")
              Visibility(
                visible:  true,
                child: MyDropDown(
                    value: finalvalue,
                    labelText: 'Entry Type',
                    hintText: 'Select Entry Type',
                    items: visitTypeItems
                        .map((item) => item.visitType)
                        .map((identityType) =>
                        DropdownMenuItem<String>(
                          value: identityType,
                          child: Text(identityType!),
                        ))
                        .toList(),
                    onchanged: (value) {

                      for(int i=0;i<visitTypeItems.length;i++){
                        if(value==visitTypeItems[i].visitType){
                          setState(() {
                            visitTypeId = visitTypeItems[i].id!;
                            finalvalue = value.toString();
                            print('visittype = $visitTypeId');
                            print('finalvalue = $finalvalue');
                          });

                          break;
                        }
                      }
                    }
                ),
              ),


              if (userTypeName != "Resident User")
                Visibility(
                  visible: true,
                  child: MyTextField(
                      hintText: 'Entry type',
                      labelText: 'Entry Type',
                      controller: visitTypeController,
                      textInputType: TextInputType.text,
                      preffixIcon: Icons.view_carousel_outlined,
                      enabled: false),
                ),



              MyDropDown(
                  value: finalvalue1,
                  hintText: 'Select Purpose of Visit Reason',
                  labelText: 'Purpose of Visit Reason',
                  items: visitReasonsItems
                      .map((item) => item.visitReason)
                      .map((identityType) =>
                      DropdownMenuItem<String>(
                        value: identityType,
                        child: Text(identityType!),
                      ))
                      .toList(),
                  onchanged: (value) {
                    finalvalue1 = value.toString();
                    for(int i=0;i<visitReasonsItems.length;i++){
                      if(value==visitReasonsItems[i].visitReason){
                        visitReasonId = visitReasonsItems[i].id!;
                        break;
                      }
                    }
                  }
              ),

              Row(
                children: [
                  Expanded(
                    child: MyDropDown(
    hintText: 'Vehicle Type',
    value: finalvalue2,
    labelText: 'Vehicle Type',
    items: vehicleTypeItems
        .map((item) => item.vehicleType)
        .map((identityType) =>
        DropdownMenuItem<String>(
          value: identityType,
          child: Text(identityType!),
        ))
        .toList(),
    onchanged: (value) {
    setState(() {
    finalvalue2 = value.toString();
    for(int i=0;i<vehicleTypeItems.length;i++){
    if(value==vehicleTypeItems[i].vehicleType){
    vehicleTypeId = vehicleTypeItems[i].id!;
    break;
    }
    }



    });
    },
    )


                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('Parking',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                        Checkbox(
                          activeColor: Colors.orange.shade900,
                          checkColor: Colors.white,
                          value: isParkingRequired,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (bool? value) async {
                            setState(() {
                              isParkingRequired = value ?? false;
                              if (isParkingRequired) {
                                if (userTypeName != "Resident / Unit users") {
                                  if (unitNumberController.text.isNotEmpty) {
                                    fetchParkingData();
                                  } else {
                                    Utils.flushBarErrorMessage(
                                        "Unit Number can't be empty", context);
                                    isParkingRequired = false;
                                    assignedParkingLotController.text = '';
                                    bayType = " ";
                                  }
                                }
                              } else {
                                // Handle the case when the checkbox is unchecked
                                assignedParkingLotController.text = '';
                                bayType = " ";
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),

              MyTextField(
                  labelText: 'Vehicle Plate No.',
                  hintText: 'Vehicle Plate No.',
                  controller: carPlateNumberController,
                  textInputType: TextInputType.text,
                  preffixIcon: Icons.car_crash_sharp),

              MyTextField(
                  labelText: 'ID/Driving License No',
                  hintText: 'ID/Driving License No',
                  controller: drivingLicenceNumberController,
                  textInputType: TextInputType.text,
                  preffixIcon: Icons.credit_card_rounded),

              MyTextField(
                  labelText: 'No.of Visitors',
                  hintText: 'No.of Visitors',
                  controller: numberofvistorsController,
                  textInputType: TextInputType.text,
                  preffixIcon: Icons.person_add_rounded),


              if (
                  (finalvalue == "One Time" || visitTypeId == 1) ||
                  (finalvalue == "Overnight Stay" || visitTypeId == 7))
                Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: MyDateField(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                arrivalDateController.text =
                                    DateFormat.yMd().format(picked);
                              });
                            }
                          },
                          controller: arrivalDateController, labelText: 'Arrival Date',
                          preffixIcon: Icons.calendar_today,

                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                arrivalTimeController.text =
                                    picked.format(context);
                              });
                            }
                          },
                          child: MyDateField(
                            controller: arrivalTimeController,
                            hintText: 'Arrival Time',
                            labelText: " Arr.Time",

                                    suffixIcon: Icons.access_time,

                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  arrivalTimeController.text =
                                      picked.format(context);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if ((finalvalue == "Multiple Entry" || visitTypeId == 2))
                Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      Expanded(
                        // width: 150,
                        child: MyDateField(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                startDateController.text =
                                    DateFormat.yMd().format(picked);
                              });
                            }
                          },
                          controller: startDateController,
                          hintText: 'Start Date',
                          labelText: 'Start Date',
                          preffixIcon: Icons.calendar_today,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.01,
                      ),
                      Expanded(
                        child: MyDateField(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                endDateController.text =
                                    DateFormat.yMd().format(picked);
                              });
                            }
                          },
                          controller: endDateController,
                          hintText: 'End Date',
                          labelText: 'End Date',
                          preffixIcon: Icons.calendar_today,
                        ),
                      ),
                    ],
                  ),
                ),
              if((userTypeName != "Resident User" && secuvisitTypeId == 1 ))
                Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: MyDateField(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                arrivalDateController.text =
                                    DateFormat.yMd().format(picked);
                              });
                            }
                          },
                          controller: arrivalDateController, labelText: 'Arrival Date',
                          preffixIcon: Icons.calendar_today,

                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                arrivalTimeController.text =
                                    picked.format(context);
                              });
                            }
                          },
                          child: MyDateField(
                            controller: arrivalTimeController,
                            hintText: 'Arrival Time',
                            labelText: " Arr.Time",

                            suffixIcon: Icons.access_time,

                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  arrivalTimeController.text =
                                      picked.format(context);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


              if (userTypeName != "Resident User")
                Visibility(
                  visible: true,
                  child: MyTextField(
                      hintText: 'Parking lot No.',
                      labelText: 'Parking lot No.',
                      controller: assignedParkingLotController,
                      textInputType: TextInputType.text,
                      preffixIcon: CupertinoIcons.car,
                      enabled: false),
                ),

              MyTextField(
                hintText: 'Remarks',
                labelText: "Remarks",
                controller: notesController,
                textInputType: TextInputType.text,
                preffixIcon: Icons.sticky_note_2_sharp,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: PositiveButton(
                    onPressed: () async {
                      setState(() {
                        vistorDetailsPopup(context);
                        // submitRegisterDetails();
                      });
                      nameController.clear();
                      carPlateNumberController.clear();
                      drivingLicenceNumberController.clear();
                      visitReasonController.clear();
                      blockNameController.clear();
                      unitNumberController.clear();
                      visitTypeController.clear();
                      numberofvistorsController.clear();
                      arrivalDateController.clear();
                      arrivalTimeController.clear();
                      startDateController.clear();
                      endDateController.clear();
                      mobilenumberController.clear();
                      notesController.clear();
                      assignedParkingLotController.clear();
                      setState(() {
                        isParkingRequired = false;
                        finalvalue = null;
                        finalvalue1 = null;
                        finalvalue2 = null;
                      });
                    }, text: 'Submit',

                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container containerValue({
    required var text,
    required String value,
  }) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            //VerticalDivider(width: 1,),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required TextInputType textInputType,
    required IconData preffixIcon,
    String? initialValue,
    String? labelText,
    bool? enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        enabled: enabled,
        style: TextStyle(
          color: Colors.black, // Set the text color
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixText: ' ',
            hintText: hintText,
            labelText: labelText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            prefixIcon: Icon(
              preffixIcon,
              color: Colors.grey,
            )),
        initialValue: initialValue,
      ),
    );
  }
}
// visitTypeDropdown
// if (userTypeName == "Resident / Unit users")
//   ChangeNotifierProvider.value(
//       value: viewModel,
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         Consumer<InviteVisitorViewModel>(
//             builder: (context, viewModel, _) {
//           if (viewModel.visitTypeResponse.status ==
//               Status.loading) {
//             // return const Center(
//             //   child: CircularProgressIndicator(
//             //     valueColor:
//             //         AlwaysStoppedAnimation<Color>(Colors.amber),
//             //   ),
//             // );
//           } else if (viewModel.visitTypeResponse.status ==
//               Status.error) {
//             return Center(
//               child: Text(
//                   viewModel.visitTypeResponse.message.toString()),
//             );
//           } else if (viewModel.visitTypeResponse.status ==
//               Status.success) {
//             List<DropdownMenuItem<String>> dataTypedropdownItems =
//                 [];
//
//             if (viewModel.visitTypeResponse.data?.result?.items !=
//                 null) {
//               Set<String> enterprisecategoryNames = Set();
//               viewModel.visitTypeResponse.data!.result!.items!
//                   .forEach((item) {
//                 if (item.visitType != null) {
//                   enterprisecategoryNames.add(item.visitType!);
//                 }
//               });
//
//               dataTypedropdownItems.addAll(
//                 enterprisecategoryNames
//                     .map(
//                       (visitType) => DropdownMenuItem<String>(
//                         value: visitType,
//                         child: Text(
//                           visitType,
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ),
//                     )
//                     .toList(),
//               );
//             }
//
//             if (dataTypedropdownItems.length == 1) {
//               dataTypedropdownItems.add(
//                 DropdownMenuItem<String>(
//                   value: 'no_item',
//                   child: Text('No item'),
//                 ),
//               );
//             }
//
//             return MyDropDown(
//               hintText: 'Select Entry Type',
//               value: finalvalue,
//               labelText: 'Entry Type',
//               items: dataTypedropdownItems,
//               onchanged: (value) {
//                 setState(() {
//                   finalvalue = value.toString();
//
//                   visitTypeId = 0;
//                   for (int i = 0;
//                       i <
//                           viewModel.visitTypeResponse.data!
//                               .result!.items!.length;
//                       i++) {
//                     if (value ==
//                         viewModel.visitTypeResponse.data!.result!
//                             .items![i].visitType) {
//                       visitTypeId = viewModel.visitTypeResponse
//                           .data!.result!.items![i].id!;
//                       break;
//                     }
//                   }
//                 });
//               },
//             );
//           }
//
//           return Text("");
//         }),
//       ])),
// VisitReasonDropdown
// ChangeNotifierProvider.value(
//     value: viewModel,
//     child: Column(mainAxisSize: MainAxisSize.min, children: [
//       Consumer<InviteVisitorViewModel>(
//           builder: (context, viewModel, _) {
//         if (viewModel.visitReasonResponse.status ==
//             Status.loading) {
//         } else if (viewModel.visitReasonResponse.status ==
//             Status.error) {
//           return Center(
//             child: Text(
//                 viewModel.visitReasonResponse.message.toString()),
//           );
//         } else if (viewModel.visitReasonResponse.status ==
//             Status.success) {
//           List<DropdownMenuItem<String>> dataTypedropdownItems =
//               [];
//
//           if (viewModel.visitReasonResponse.data?.result?.items !=
//               null) {
//             Set<String> enterprisecategoryNames = Set();
//             viewModel.visitReasonResponse.data!.result!.items!
//                 .forEach((item) {
//               if (item.visitReason != null) {
//                 enterprisecategoryNames.add(item.visitReason!);
//               }
//             });
//
//             dataTypedropdownItems.addAll(
//               enterprisecategoryNames
//                   .map(
//                     (visitType) => DropdownMenuItem<String>(
//                       value: visitType,
//                       child: Text(
//                         visitType,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   )
//                   .toList(),
//             );
//           }
//
//           if (dataTypedropdownItems.length == 1) {
//             dataTypedropdownItems.add(
//               DropdownMenuItem<String>(
//                 value: 'no_item',
//                 child: Text('No item'),
//               ),
//             );
//           }
//
//           return MyDropDown(
//             hintText: 'Select Purpose of Visit Reason',
//             value: finalvalue1,
//             labelText: 'Purpose of Visit  ',
//             items: dataTypedropdownItems,
//             onchanged: (value) {
//               setState(() {
//                 finalvalue1 = value.toString();
//
//                 visitReasonId = 0;
//                 for (int i = 0;
//                     i <
//                         viewModel.visitReasonResponse.data!
//                             .result!.items!.length;
//                     i++) {
//                   if (value ==
//                       viewModel.visitReasonResponse.data!.result!
//                           .items![i].visitReason) {
//                     visitReasonId = viewModel.visitReasonResponse
//                         .data!.result!.items![i].id!;
//                     break;
//                   }
//                 }
//               });
//             },
//           );
//         }
//
//         return Text("");
//       }),
//     ])),

// VehicleTypeDropdown


// ChangeNotifierProvider.value(
//     value: viewModel,
//     child:
//         Column(mainAxisSize: MainAxisSize.min, children: [
//       Consumer<InviteVisitorViewModel>(
//           builder: (context, viewModel, _) {
//         if (viewModel.vehicleTypeResponse.status ==
//             Status.loading) {
//         } else if (viewModel.vehicleTypeResponse.status ==
//             Status.error) {
//           return Center(
//             child: Text(viewModel
//                 .vehicleTypeResponse.message
//                 .toString()),
//           );
//         } else if (viewModel.vehicleTypeResponse.status ==
//             Status.success) {
//           List<DropdownMenuItem<String>>
//               dataTypedropdownItems = [];
//
//           if (viewModel.vehicleTypeResponse.data?.result
//                   ?.items !=
//               null) {
//             Set<String> enterprisecategoryNames = Set();
//             viewModel
//                 .vehicleTypeResponse.data!.result!.items!
//                 .forEach((item) {
//               if (item.vehicleType != null) {
//                 enterprisecategoryNames
//                     .add(item.vehicleType!);
//               }
//             });
//
//             dataTypedropdownItems.addAll(
//               enterprisecategoryNames
//                   .map(
//                     (vehicleType) =>
//                         DropdownMenuItem<String>(
//                       value: vehicleType,
//                       child: Text(
//                         vehicleType,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   )
//                   .toList(),
//             );
//           }
//
//           if (dataTypedropdownItems.length == 1) {
//             dataTypedropdownItems.add(
//               DropdownMenuItem<String>(
//                 value: 'no_item',
//                 child: Text('No item'),
//               ),
//             );
//           }
//
//           return MyDropDown(
//             hintText: 'Vehicle Type',
//             value: finalvalue2,
//             labelText: 'Vehicle Type',
//             items: dataTypedropdownItems,
//             onchanged: (value) {
//               setState(() {
//                 finalvalue2 = value.toString();
//
//                 vehicleTypeId = 0;
//                 for (int i = 0;
//                     i <
//                         viewModel.vehicleTypeResponse.data!
//                             .result!.items!.length;
//                     i++) {
//                   if (value ==
//                       viewModel.vehicleTypeResponse.data!
//                           .result!.items![i].vehicleType) {
//                     vehicleTypeId = viewModel
//                         .vehicleTypeResponse
//                         .data!
//                         .result!
//                         .items![i]
//                         .id!;
//                     break;
//                   }
//                 }
//               });
//             },
//           );
//         }
//
//         return Text("");
//       }),
//     ])),
// void fetchVisitType1() async {
//   viewModel.getVisitorType1();
// }
//
// void fetchVisitReasons1() async {
//   viewModel.getVisitReasons1("ASC", "id", 1, 25);
// }
//
// void fetchVehicleType1() async {
//   viewModel.getVehicleTypes1("ASC", "id", 1, 50);
// }