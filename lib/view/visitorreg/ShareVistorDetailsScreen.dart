import 'dart:convert';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '/utils/PositiveButton.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../model/visitorreg/VisitorsListModel.dart';
import '../../viewmodel/UserViewModel.dart';

class ShareVisitorDetailsScreen extends StatefulWidget {
  VistorsListItems item;

  ShareVisitorDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ShareVisitorDetailsScreen> createState() =>
      _ShareVisitorDetailsScreenState();
}

class _ShareVisitorDetailsScreenState extends State<ShareVisitorDetailsScreen> {
  var userVM = UserViewModel();
  String imageUrl = '';
  DateTime currentDate = DateTime.now();
  bool sharebutton = false;

  // DateTime? visitorStayEndDate;
  void initState() {
    super.initState();
    getUserDetails();
    DateTime? visitorStayEndDate = widget.item.visitorStayEnddate != null
        ? DateTime.parse(widget.item.visitorStayEnddate.toString())
        : null;

    if (widget.item.visitTypeName != null &&
        (widget.item.visitTypeName == "One Time" ||
            widget.item.visitTypeName == "Overnight Stay") &&
        widget.item.visitorRegistrstionStatus != null &&
        (widget.item.visitorRegistrstionStatus == "Arrived" ||
            widget.item.visitorRegistrstionStatus == "Completed")) {
      setState(() {
        sharebutton = false;
      });
    } else {
      setState(() {
        sharebutton = true;
      });
    }
    if (visitorStayEndDate != null) {
      if (widget.item.visitTypeName != null &&
          (widget.item.visitTypeName == "Multiple Entry" ||
              widget.item.visitTypeId == 2) &&
          (visitorStayEndDate.isAfter(currentDate) ||
              visitorStayEndDate.isAtSameMomentAs(currentDate))) {
        setState(() {
          sharebutton = true;
        });
      } else {
        setState(() {
          sharebutton = false;
        });
      }
    }
  }

  int userId = 0;
  String firstName = "";
  String lastName = "";
  String propertyName = "";
  String unitNumber = "";
  String blockName = "";

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final firstname = value.userDetails?.firstName;
      final userid = value.userDetails?.id;
      userId = userid ?? 0;
      firstName = firstname ?? '';

      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';

      final propertyname = value.userDetails?.propertyDispName ?? "";
      propertyName = propertyname ?? '';
      final unitnmb = value.userDetails?.unitNumber;

      final blockname = value.userDetails?.blockName;
      blockName = blockname ?? "";
      setState(() {
        firstName = firstname ?? '';
        print(firstName);
        lastName = lastname ?? '';
        print(lastName);
        unitNumber = unitnmb ?? " ";
        blockName = blockname ?? "";
      });
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      // unitDeviceCnt = unitdevicecnt ?? 0 ;

      final usertypeId = value.userDetails?.userType;
      // userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      // appusagetypeId = appusagetypeid ?? 0;
    });
    _generateQRData();
// _generateQRData1();
  }

  final GlobalKey _globalKey = GlobalKey();
  String? _qrData;

  void _generateQRData() async {
    int _id = widget.item.id ?? 0;
    String _visitorName = widget.item.visitorName ?? '';
    String _visitorMobileNo = widget.item.visitorMobileNo ?? '';
    String _numberofvisitors = widget.item.noOfVisitor.toString();
    String _vehiclenumber = widget.item.vehiclePlateNo ?? '';
    String _drivinglicence = widget.item.idDrivingLicenseNo ?? '';
    String _visittype = widget.item.visitTypeName ?? '';
    String _visitReason = widget.item.vistReason ?? '';
    String _vehicleType = widget.item.vehicleType ?? '';
    String _parkingRequired = widget.item.parkingRequired ?? '';

    // Debug prints
    print('_visitorName: $_visitorName');
    print('_visitorMobileNo: $_visitorMobileNo');
    print('_numberofvisitors: $_numberofvisitors');
    print('_vehiclenumber: $_vehiclenumber');
    print('_drivinglicence: $_drivinglicence');
    print('_visittype: $_visittype');
    print('_visitReason: $_visitReason');
    print('_vehicleType: $_vehicleType');
    print('_parkingRequired: $_parkingRequired');

    _qrData = 'Id :$_id\n'
        'Unit No.: ${widget.item.unitNumber}\n'
        'Visitor Name: $_visitorName\n'
        'Mobile Number: $_visitorMobileNo\n'
        'Visit Type: $_visittype\n'
        'Visit Reason: $_visitReason\n'
        'Vehicle Type:$_vehicleType\n'
        'Vehicle Number: $_vehiclenumber\n'
        'Number of Visiors: $_numberofvisitors\n'
        'Parking Required:$_parkingRequired\n'
        'Driving Licence No: $_drivinglicence';
  }

  void _generateQRData1() async {
    setState(() {
      Data data = Data();
      data.visitorName = widget.item.visitorName ?? '';
      data.id = widget.item.id ?? 0;
      data.visitorName = widget.item.visitorName ?? '';
      data.visitorMobileNo = widget.item.visitorMobileNo ?? '';
      data.numberofvisitors = widget.item.noOfVisitor.toString();
      data.vehiclenumber = widget.item.vehiclePlateNo ?? '';
      data.drivinglicence = widget.item.idDrivingLicenseNo ?? '';
      data.visittype = widget.item.visitTypeName ?? '';
      data.visitReason = widget.item.vistReason ?? '';
      data.vehicleType = widget.item.vehicleType ?? '';
      data.parkingRequired = widget.item.parkingRequired ?? '';
      _qrData = data.toJson().toString();
    });
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
        // Add a delay before sharing the QR code
        await Future.delayed(Duration(seconds: 1));

        await Share.shareFiles([imagePath], text: _qrData);
      } else {
        throw Exception('Failed to generate QR code image');
      }
    } catch (e) {
      print('Error occurred while sharing QR code: $e');
    }
  }

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    double? fontSize1;
    double? fontSize2;
    if (width < 411 || height < 707) {
      fontSize = 11;
      fontSize1 = 14;
      fontSize2 = 21;
    } else {
      fontSize = 14;
      fontSize1 = 16;
      fontSize2 = 24;
    }
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
            'Share Details',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding:
              const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Image.asset(
                  'assets/images/VMS-POMS_Logo1.png',
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
            ),
            if (propertyName != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                child: Text(propertyName.toString(),
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      fontSize: fontSize2,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF580066),
                    ))),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5),
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
            Center(
              child: Text(
                widget.item.registrationQrcode ?? " ",
                style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Host : $firstName",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: fontSize1,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF002449)),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.004,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Block : $blockName",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: fontSize1,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF002449)),
                          )),
                      SizedBox(
                        width: 10,
                      ),

                      Text(
                        "Unit No. : $unitNumber",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: fontSize1,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF002449)),
                        ),
                      )
                      // Text(lastName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text('Visitor Name',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                                Text(": "),
                                Expanded(
                                    child: Text(widget.item.visitorName ?? '',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text('Mobile No.',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                                Text(": "),
                                Expanded(
                                    child: Text(
                                        widget.item.visitorMobileNo ?? '',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text('Visit Type',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                                Text(": "),
                                Expanded(
                                    child: Text(widget.item.visitTypeName ?? '',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text('Vehicle No.',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                                Text(": "),
                                Expanded(
                                    child: Text(
                                        widget.item.vehiclePlateNo ?? '',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text('Purpose of Visit',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                                Text(": "),
                                Expanded(
                                    child: Text(widget.item.vistReason ?? '',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text('ID/Driver\'s License',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                                Text(": "),
                                Expanded(
                                    child: Text(
                                        widget.item.idDrivingLicenseNo ?? '',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text('No. of Visitor',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                                Text(": "),
                                // add a one-character space
                                Expanded(
                                    child: Text(
                                        widget.item.noOfVisitor.toString() ??
                                            '',
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize)))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    child: Text(
                                      'Visitor Status',
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: fontSize)),
                                    )),
                                Text(": "),
                                // add a one-character space
                                Expanded(
                                    child: Text(
                                  widget.item.visitorRegistrstionStatus ?? '',
                                  style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: fontSize)),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            if (sharebutton == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF036CB2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      _shareQRCode();
                    },
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                  ),

                  // if (sharebutton == false)
                  SizedBox(width: MediaQuery.of(context).size.width * 0.10),
                  Center(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF036CB2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        label: Text('Close')),
                  ),
                ],
              ),
            if (sharebutton == false)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: PositiveButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // icon: Icon(Icons.close),
                      text: 'Close'),
                ),
              ),
          ]),
        ))));
  }
}

class Data {
  String? visitorName;
  int? id;
  String? visitorMobileNo;
  String? numberofvisitors;
  String? vehiclenumber;
  String? drivinglicence;
  String? visittype;
  String? visitReason;
  String? vehicleType;
  String? parkingRequired;

  Data({
    this.visitorName,
    this.id,
    this.visitorMobileNo,
    this.numberofvisitors,
    this.vehiclenumber,
    this.drivinglicence,
    this.visittype,
    this.visitReason,
    this.vehicleType,
    this.parkingRequired,
  });

  Map<String, dynamic> toJson() {
    return {
      'visitorName': visitorName,
      'id': id,
      'visitorMobileNo': visitorMobileNo,
      'numberofvisitors': numberofvisitors,
      'vehiclenumber': vehiclenumber,
      'drivinglicence': drivinglicence,
      'visittype': visittype,
      'visitReason': visitReason,
      'vehicleType': vehicleType,
      'parkingRequired': parkingRequired,
    };
  }
}
