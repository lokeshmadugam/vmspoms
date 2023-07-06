import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view/LoginScreen.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/ProfileViewModel.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/LoginViewModel.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../utils/MyDateField.dart';

import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final bool showAppBar;

  ProfileScreen({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController blockNameController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController roleNameController = TextEditingController();
  TextEditingController singupRequestDateController = TextEditingController();
  TextEditingController aboutmeController = TextEditingController();
  TextEditingController mailingAddressController = TextEditingController();
  TextEditingController buildupAreaController = TextEditingController();
  var viewModel = LoginViewModel();
  var userVM = UserViewModel();
  int userId = 0;
  int propertyId = 0;
  String firstName = "";
  String lastName = "";
  String mobileNumber = '';
  String email = '';
  String blockName = '';
  String unitNumber = '';
  String roleName = '';
  String date = '';
  String profileImg = '';
  final GlobalKey _globalKey = GlobalKey();
  String? _qrData;

  final double circleRadius = 100.0;
  bool showAppBar = false;
  DateTime? _selectedDateTime;
  File? _image;
  final picker = ImagePicker();
  var profileViewModel = ProfileViewModel();
  String addressLine1 = '';
  String addressLine2 = '';
  String city = '';
  String state = '';

  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();

    blockNameController.dispose();
    unitNumberController.dispose();
    roleNameController.dispose();
    singupRequestDateController.dispose();
    aboutmeController.dispose();
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
      //final blockname = "${value.userDetails!.blockName!} | ${value.userDetails!.unitNumber}";
      /*blockNameController.text = blockname ?? "";
      blockName = blockName ?? '';*/
      final rolename = value.userDetails?.roleName;
      roleNameController.text = rolename ?? '';
      roleName = rolename ?? '';
      final signdate = value.userDetails?.signupRequestDate?.toString() ?? '';

      setState(() {
        final image = value.userDetails?.profileImg.toString().trim() ?? '';
        profileImg = image ?? '';
      });

      aboutmeController.text = value.userDetails!.remarks.toString();

      mailingAddressController.text = "${value.userDetails!.blockName} ${value.userDetails!.unitNumber} | ${value.userDetails!.propertyAddressLine1}, ${value.userDetails!.propertyAddressLine2}, ${value.userDetails!.propertyCity}, ${value.userDetails!.propertyState}.";
      addressLine1 = value.userDetails!.propertyAddressLine1.toString();
      addressLine2 = value.userDetails!.propertyAddressLine2.toString();
      city = value.userDetails!.propertyCity.toString();
      state = value.userDetails!.propertyState.toString();

      blockName = value.userDetails!.blockName.toString();

      if (signdate.isNotEmpty) {
        final singupdate =
            DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(signdate));
        singupRequestDateController.text =
            singupdate.isNotEmpty ? singupdate : '';
      }

// date = signdate ?? '';
      // fetchLoginUserDetails();
      //_downloadAndSetImage();
      _generateQRData();
    });
  }

  @override
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
    _qrData =
        // 'Id :$_id\n'
        'First Name: $_userFirstName\n'
        'Last Name: $_userLastName\n'
        'Mobile Number: $_mobileNo\n'
        'Email: $_emailAddress\n'
        'Block Name:$_blockName\n'
        'Unit Number: $_unitnumber\n'
        'Role Name: $_roleName';
  }

  /*Future<void> _downloadAndSetImage() async {
    File imageFile = await urlToFile(profileImg);
    setState(() {
      _image = imageFile;
    });
  }

  Future<File> urlToFile(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    var bytes = response.bodyBytes;
    // Define the file path and name
    String tempPath = (await getTemporaryDirectory()).path;
    String filePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch.toString()}.png';

    // Write the image to the file
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return file;
  }*/

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    double? fontSize1;
    double? fontSize2;
    if(width < 411 || height < 707){
      fontSize = 11;
      fontSize1 = 14;
      fontSize2 = 21;

    }else {
      fontSize = 14;
      fontSize1 = 16;
      fontSize2 = 24;
    }
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: circleRadius,
                    height: circleRadius,
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
                ),
                onTap: () {
                  popUp();
                },
              ),
              MyTextField(
                controller: firstNameController,
                textInputType: TextInputType.text,
                hintText: 'First Name',
                labelText: 'First Name',
              ),
              MyTextField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  labelText: 'Last Name',
                  textInputType: TextInputType.text),
              MyTextField(
                  controller: mobileNumberController,
                  hintText: 'Mobile Number',
                  labelText: 'Mobile Number',
                  enabled: false,
                  textInputType: TextInputType.number),
              MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  labelText: 'E-mail',
                  enabled: false,
                  textInputType: TextInputType.emailAddress),
              /*MyTextField(
                  controller: blockNameController,
                  hintText: 'Block Name | Unit Number',
                  labelText: 'Block Name | Unit Number',
                  enabled: false,
                  textInputType: TextInputType.text),*/
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: mailingAddressController,
                        hintText: 'Mailing Address',
                        labelText: 'Mailing Address',
                        enabled: false,
                        maxLines: null,
                        textInputType: TextInputType.multiline),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(
                        Icons.copy, color: Colors.grey,
                      ),
                    ),
                    onTap: _copyToClipboard,
                  )
                ],
              ),
              MyTextField(
                  controller: buildupAreaController,
                  hintText: 'Build-Up Area',
                  labelText: 'Build-Up Area',
                  enabled: false,
                  textInputType: TextInputType.text),
              MyTextField(
                  controller: aboutmeController,
                  hintText: 'About Me',
                  labelText: 'About Me',
                  maxLines: null,
                  textInputType: TextInputType.multiline),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline, color: Colors.red, size: 18,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Expanded(
                      child: Text(
                          'Kindly contact the management office if you wish to change your mobile number, email address or mailing address. This is because a proof of property ownership is required for verification.',
                        softWrap: true, style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: Colors.red) ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF036CB2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        icon: Icon(Icons.change_circle_outlined),
                        label: Text("Password",
                            style: GoogleFonts.roboto(textStyle:TextStyle(
                                fontSize: fontSize1,
                                color: Colors.white,
                                fontWeight: FontWeight.w500))),
                        onPressed: () {},
                      ),
                      PositiveButton(
                          text: 'Submit',
                          onPressed: () {
                            submitProfileDetails();
                          }),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF036CB2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        icon: Icon(Icons.logout),
                        label: Text('Log Out',
                            style: GoogleFonts.roboto(textStyle: TextStyle(
                                fontSize: fontSize1,
                                color: Colors.white,
                                fontWeight: FontWeight.w500))),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool isRememberMe = prefs.getBool('rememberMe')!;
                          if (isRememberMe) {
                            userVM.removeUser(context);
                          } else {
                            prefs.setString('email', '');
                            prefs.setString('password', '');
                            userVM.removeUser(context);
                          }
                        },
                      ),
                      // PositiveButton(
                      //     text: 'Log Out',
                      //     onPressed: () {
                      //       userVM.removeUser(context);
                      //     })
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void popUp() {
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
                    Column(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.camera_alt,
                            size: 45,
                            color: Colors.indigo.shade500,
                          ),
                          onTap: () {
                            _getImageFromCamera();
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          'Take Photo',
                          style: TextStyle(color: Colors.indigo.shade500),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.photo,
                            size: 45,
                            color: Colors.indigo.shade500,
                          ),
                          onTap: () {
                            _getImageFromGallery();
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(color: Colors.indigo.shade500),
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

  Future<void> _copyToClipboard() async {
    String address = firstName+" "+lastName+'\n'+blockName+" "
        +unitNumber+'\n'+addressLine1+'\n'+addressLine2+'\n'+city+'\n'+state;
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard!')),
    );
  }

  Future<void> _getImageFromCamera() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        uploadImage(_image!.path);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        uploadImage(_image!.path);
      });
    }
  }

  Future<void> uploadImage(var imagePath) async {
    profileViewModel.mediaUpload(imagePath, context).then((response) {
      if (response.data != null) {
        if (response.data?.refName != null) {
          setState(() {
            profileImg = response.data!.refName.toString().trim();
            //submitProfileDetails(response.data!.refName.toString());
          });
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  void submitProfileDetails() async {
    Map<String, dynamic> data = {
      "email_address": email,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "mobile_no": mobileNumber,
      "profile_img": profileImg,
      "remarks": aboutmeController.text,
      "updated_by": userId
    };

    profileViewModel.updateProfileDetails(userId, data, context).then((value) {
      if (value.data!.status == 200) {
        print('msg = ${value.data!.mobMessage}');
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
