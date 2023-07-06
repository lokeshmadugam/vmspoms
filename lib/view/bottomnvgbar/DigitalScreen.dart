import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/LoginUserModel.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/LoginViewModel.dart';
import '../../viewmodel/UserViewModel.dart';
import 'package:http/http.dart' as http;

class DigitalScreen extends StatefulWidget {
  const DigitalScreen({Key? key}) : super(key: key);

  @override
  State<DigitalScreen> createState() => _DigitalScreenState();
}

class _DigitalScreenState extends State<DigitalScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController blockNameController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController roleNameController = TextEditingController();
  TextEditingController singupRequestDateController = TextEditingController();
  TextEditingController aboutmeController = TextEditingController();
  var viewModel = LoginViewModel();
  var data = LoginDetails();
  var userVM = UserViewModel();
  int userId = 0;
  String employeeId = "";
  int propertyId = 0;
  String firstName = "";
  String lastName = "";
  String mobileNumber = '';
  String email = '';
  String blockName = '';
  String unitNumber = '';
  String roleName = '';
  String appUsageTypeName = '';
  String date = '';
  final GlobalKey _globalKey = GlobalKey();
  String? _qrData;
  String profileImg = '';
  final double circleRadius = 100.0;
  bool showAppBar = false;
  File? _image;

  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;
      userId = userid ?? 0;
      final firstname = value.userDetails?.firstName;

      firstNameController.text = firstname ?? '';
      firstName = firstname ?? '';
      print(firstName);
      final lastname = value.userDetails?.lastName;
      lastNameController.text = lastname ?? '';
      lastName = lastname ?? '';
      print(lastName);

      final mobileNo = value.userDetails?.mobileNo;
      mobileNumberController.text = mobileNo ?? '';
      mobileNumber = mobileNo ?? '';
      final emailAdd = value.userDetails?.emailAddress ?? '';
      emailController.text = emailAdd ?? '';
      email = emailAdd ?? '';
      final unitnmb = value.userDetails?.unitNumber;
      unitNumberController.text = unitnmb ?? " ";
      unitNumber = unitnmb ?? '';
      final blockname = value.userDetails?.blockName;
      blockNameController.text = blockname ?? "";
      blockName = blockName ?? '';
      final rolename = value.userDetails?.roleName;
      roleNameController.text = rolename ?? '';
      roleName = rolename ?? '';
      final signdate = value.userDetails?.signupRequestDate?.toString() ?? '';
      // final singupdate =  DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(signdate));
      // singupRequestDateController.text = singupdate.isNotEmpty ? singupdate : '';
      final image = value.userDetails?.profileImg ?? '';

      appUsageTypeName = value.userDetails!.appUsageTypeName!;
      employeeId = value.userDetails!.employeeId!;

      setState(() {
        profileImg = (image ?? '').trim();
        print(profileImg);
      });
// date = signdate ?? '';
      // fetchLoginUserDetails();
      _generateQRData();
    });
  }

  // Future<void> _downloadAndSetImage() async {
  //   File imageFile = await urlToFile(profileImg);
  //   setState(() {
  //     _image = imageFile;
  //   });
  // }
  // Future<File> urlToFile(String imageUrl) async {
  //   var response = await http.get(Uri.parse(imageUrl));
  //   var bytes = response.bodyBytes;
  //   // Define the file path and name
  //   String tempPath = (await getTemporaryDirectory()).path;
  //   String filePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
  //
  //   // Write the image to the file
  //   File file = File(filePath);
  //   await file.writeAsBytes(bytes);
  //
  //   return file;
  // }
  void _generateQRData() async {
    // int _id = data?.id ?? 0;
    String _userFirstName = firstName ?? '';
    String _userLastName = lastName ?? '';
    String _mobileNo = mobileNumber ?? '';
    String _emailAddress = email ?? '';
    String _blockName = blockName ?? '';
    String _unitnumber = unitNumber ?? '';
    String _roleName = roleName ?? '';

    // Debug prints
    print('_firstName: $_userFirstName');
    print('_lastname: $_userLastName');
    print('_mobileNo: $_mobileNo');
    print('_email: $_emailAddress');
    print('_blockName: $_blockName');
    print('_unitNo: $_unitnumber');
    print('_roleName: $_roleName');
    // print('_vehicleType: $_vehicleType');
    //

    if (appUsageTypeName.trim() == 'VMS Management modules' ||
        appUsageTypeName.trim() == 'Guard House') {
      _qrData = 'First Name: $_userFirstName\n'
          ' Last Name: $_userLastName\n'
          'Mobile Number: $_mobileNo\n'
          'Email: $_emailAddress\n'
          'Employee Id: $employeeId\n'
          'User Id: $userId\n'
          'Block Name:$_blockName\n'
          'Unit Number: $_unitnumber';
    } else {
      _qrData = 'First Name: $_userFirstName\n'
          ' Last Name: $_userLastName\n'
          'Mobile Number: $_mobileNo\n'
          'Email: $_emailAddress\n'
          'Block Name:$_blockName\n'
          'Unit Number: $_unitnumber';
    }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 20, left: 20, right: 20),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: circleRadius / 2.0,
                      ),
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 120.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('My Digital Business Card'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: RepaintBoundary(
                                  key: _globalKey,
                                  child: Column(
                                    children: [
                                      QrImageView(
                                        data: _qrData ?? '',
                                        version: QrVersions.auto,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.20,
                                        gapless: false,
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _generateQRData();
                                      String vcardUrl =
                                          'https://example.com/download-vcard?data=$_qrData'; // Replace with your VCard download URL
                                      launch(vcardUrl);
                                    },
                                    child: Text('Download VCard'),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        // Download the QR code image
                                        // Assuming you have the QR code image URL stored in a variable called `qrCodeImageUrl`
                                        String qrCodeImageUrl =
                                            'https://example.com/qr-code-image.png'; // Replace with your QR code image URL
                                        launch(qrCodeImageUrl);
                                      },
                                      child: Text('Download QR Code')),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (profileImg != null && profileImg.isNotEmpty)
                      // if(_image!=null)
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            profileImg,
                            fit: BoxFit.fill,
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
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
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                label: Text('Share'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
