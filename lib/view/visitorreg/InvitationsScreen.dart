import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '/model/SignInModel.dart';
import '/view/visitorreg/FavoriteVisitors.dart';
import '/view/visitorreg/ParkingScreen.dart';
import '/view/visitorreg/VisitorCheckoutScreen.dart';

import 'ContactsScreen.dart';
import 'VisitorRegistrationFormScreen.dart';
import 'ScanQrcode.dart';
import 'ViewInvitationsScreen.dart';

import '../../viewmodel/UserViewModel.dart';

class InvitationsScreen extends StatefulWidget {
  var contact;
  var data;
  var favoritevisitor;

  InvitationsScreen(
      {Key? key,
        required this.contact,
        required this.data,
        this.favoritevisitor})
      : super(key: key);

  //
  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  var userVM = UserViewModel();
  String userTypeName = '';
  String _selectedButton = "Registration";
  int unitDeviceCnt = 0;
  String unitNumber = '';
  String blockName = '';
  bool isButtonSelected = false;
  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  bool isprint = false;
  bool isdownload = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    permissions = widget.data;
    actionPermissions();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userType = value.userDetails?.appUserTypeName;
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      unitDeviceCnt = unitdevicecnt ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      // userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      // appusagetypeId = appusagetypeid ?? 0;

      setState(() {
        userTypeName = userType ?? '';
        // if (userTypeName == 'Resident / Unit users') {
        //   _selectedButton = 'Registration';
        // }
        // else {
        // //   _selectedButton = 'Registration';
        // // }
        print('usertype = $userTypeName');
      });
    });
  }

  void actionPermissions() async {
    setState(() {
      for (var item in permissions) {
        if ((item.moduleDisplayNameMobile == "Visitor Registration ") &&
            (item.action != null && item.action!.isNotEmpty)) {
          var actions = item.action ?? [];
          for (var act in actions) {
            if (act.actionName == "Add" || act.actionId == 1) {
              iscreate = true;
              print("addbutton = $iscreate");
            } else if (act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");
            } else if (act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");
            } else if (act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");
            } else if (act.actionName == "Print" || act.actionId == 5) {
              isprint = true;
              print("print = $isprint");
            } else if (act.actionName == "Download files" ||
                act.actionId == 6) {
              isdownload = true;
              print("download = $isdownload");
            } else if (act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");
            }
          }
        }
      }
    });
  }

  var contact;

  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case "Registration":
        return InviteGuestScreen(
          contact: widget.contact,
          favoritevisitor: widget.favoritevisitor,
        );
      case "Checkin/Checkout":
        return ScanQrcodeScreen();
      case "View Invitations":
        return ViewInvistationsScreen(
          permission: widget.data,
        );
      default:
        return Container(); // Return a default screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    if (width < 411 || height < 707) {
      fontSize = 14;
    } else {
      fontSize = 16;
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
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
          title: Text('Invitations',
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
          actions: [
            if (userTypeName != "Resident / Unit users")
              IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParkingScreen(),
                      ),
                    );

                    // if (result != null) {
                    //   var mobileNumber = result['_selectedContact'] as String;
                    //   // print("bay = $baynumber");
                    //   // var baytype = result['bayType'].toString();
                    //
                    //   print("mobileNo. = $mobileNumber");
                    //   setState(() {
                    //   contact = mobileNumber;
                    //   });
                    // }
                  },
                  icon: Icon(FontAwesomeIcons.car)),
            if (userTypeName == "Resident / Unit users" &&
                (_selectedButton == "Registration"))
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context)  => FavoriteVisitorsScreen(),
                  //   ),
                  // );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteVisitorsScreen()),
                  );
                },
                icon: Icon(FontAwesomeIcons.star),
              ),
          ],
        ),
        body: Column(children: [
          Container(
              color: Color(0xFF036CB2),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child:
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (userTypeName == "Resident / Unit users")
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          bottomLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                        ),
                        color: Color(0xFF036CB2),
                      ),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _selectedButton == "Contacts"
                                  ? Colors.white
                                  : Color(0xFF1883BD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35.0),
                                  bottomLeft: Radius.circular(00.0),
                                  topRight: Radius.circular(0.0),
                                  bottomRight: Radius.circular(0.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // final result = await Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ContactsScreen(),
                              //   ),
                              // );
                              final result = await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactsScreen()),
                              );
                              if (result != null) {
                                var mobileNumber = result['contact'];
                                print("mobileNo. = $mobileNumber");
                                setState(() {
                                  contact = mobileNumber;
                                });
                              }
                            },
                            child: Icon(
                              Icons.call,
                              size: 30,
                              color: _selectedButton == "Contacts"
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          )),
                    ),

                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      // width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _selectedButton == "Registration"
                              ? Colors.white
                              : Color(0xFF1883BD),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  userTypeName == "Resident / Unit users"
                                      ? 0.0
                                      : 35.0),
                              bottomLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                            ),
                          ),
                          // backgroundColor:Color(0xFF54C9F3)
                        ),
                        onPressed: () async {
                          setState(() {
                            _selectedButton = "Registration";
                          });
                        },
                        child: Center(
                          child: Text("Registration",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: fontSize,
                                  color: _selectedButton == "Registration"
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                  // if (userTypeName != "Resident / Unit users")SizedBox(width: 20,),
                  if (userTypeName == "Guard House")
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: _selectedButton == 'Checkin/Checkout'
                                  ? Colors.white
                                  : Color(0xFF1883BD),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                  ))),
                          onPressed: () async {
                            setState(() {
                              _selectedButton = 'Checkin/Checkout';
                            });
                          },
                          icon: Icon(
                            Icons.qr_code_scanner,
                            size: 18,
                            color: _selectedButton == "Checkin/Checkout"
                                ? Colors.black
                                : Colors.white,
                          ),
                          label: Text("Checkin/Checkout",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: fontSize,
                                    color: _selectedButton == "Checkin/Checkout"
                                        ? Colors.black
                                        : Colors.white),
                              )),
                        ),
                      ),
                    ),
                  Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        // width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: _selectedButton == 'View Invitations'
                                  ? Colors.white
                                  : Color(0xFF1883BD),
                              // side: BorderSide(
                              //     width: 1.0,color: Color(0xFFD7DE7C)
                              // ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0.0),
                                    bottomLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(35.0),
                                    bottomRight: Radius.circular(0.0),
                                  ))),
                          onPressed: () async {
                            setState(() {
                              _selectedButton = 'View Invitations';
                            });
                          },
                          child: Text("View Invitations",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: fontSize,
                                  color: _selectedButton == "View Invitations"
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              )),
                        ),
                      ))
                ]),
              )),
          Expanded(child: _getSelectedScreen()),
        ]));
  }
}
