import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/data/respose/Status.dart';

import '../../model/intercom/IntercomListingModel.dart';
import '../../utils/MyTextField.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/intercom/IntercomViewModel.dart';

import 'IntercomContactsScreen.dart';

class IntercomFormScreen extends StatefulWidget {
  var data;
  final Contact inetrcomcontact;

  // final Value priorty;

  IntercomFormScreen({
    super.key,
    required this.data,
    required this.inetrcomcontact,
  });

  //required this.priorty,
  @override
  State<IntercomFormScreen> createState() => _IntercomFormScreenState();
}

class _IntercomFormScreenState extends State<IntercomFormScreen> {
  var userVM = UserViewModel();
  var intercomViewModel = IntercomViewModel();
  String firstName = "";
  String lastName = "";
  int propertyId = 0;
  String userTypeName = "";
  int userId = 0;
  String countryId = "";

  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnamerController = TextEditingController();

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<IntercomItems> _intercomList = [];
  var firstname;
  var lastname;
  var phoneNumber;
  int? updatedBy;
  int priorityCounter = 0;
  String unitNumber = " ";
  int highestPriority = 0;

  void initState() {
    super.initState();
    print('name = ${widget.inetrcomcontact.displayName}');
    // name = widget.inetrcomcontact.displayName;
    String fullName = widget.inetrcomcontact.displayName;
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts.first;
    String lastName = nameParts.sublist(1).join(' ');
    String selectedPhone = widget.inetrcomcontact.selectedPhone ?? '';
    phoneNumber = widget.inetrcomcontact.phones?.isNotEmpty == true
        ? widget.inetrcomcontact.phones.first.value ?? ''
        : '';

    _firstnameController = TextEditingController(text: firstName);
    _lastnamerController = TextEditingController(text: lastName);
    if (selectedPhone.isNotEmpty) {
      _phoneNumberController = TextEditingController(text: selectedPhone);
    } else {
      _phoneNumberController = TextEditingController(text: phoneNumber);
    }

    if (widget.data == null) {
      updatedBy = 0;
    } else {
      // _intercomList = widget.data;
      updatedBy = widget.data.id ?? 0;
      _firstnameController.text = widget.data.firstName;
      _lastnamerController.text = widget.data.lastName;

      _phoneNumberController.text = widget.data.phoneNumber;
// final name = widget.data.p
    }
    getUserDetails();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;
      userId = userid ?? 0;
      final country = value.userDetails?.countryCode ?? '';
      countryId = country ?? '';
      final appusage = value.userDetails?.appUsageTypeName ?? '';
      userTypeName = appusage ?? '';
      final firstname = value.userDetails?.firstName;
      firstName = firstname ?? '';

      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      final propertyid = value.userDetails?.propertyId ?? 0;
      propertyId = propertyid ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
      fetchIntercomList();
    });
  }

  Future<void> fetchIntercomList() async {
    intercomViewModel
        .getIntercomList("ASC", "id", 1, 500, propertyId, unitNumber)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _intercomList = data;
              for (var item in data) {
                final priorityCount = item.priority ?? 0;
                if (priorityCount > highestPriority) {
                  highestPriority = priorityCount;
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

  Future<void> submitRegisterDetails() async {
    int newPriority = highestPriority + 1;
    print("newPriority = $newPriority");
    if (_firstnameController.text.isEmpty) {
      Utils.flushBarErrorMessage('Name can\'t be empty', context);
    } else if (_phoneNumberController.text.isEmpty) {
      Utils.flushBarErrorMessage('Mobile Number can\'t be empty', context);
    } else {
      // if (priorityCounter == null) {
      //   setState(() {
      //
      //   });
      // }
      if (widget.data == null) {
        Map<String, dynamic> data = {
          "country_code": countryId,
          "created_by": userId,
          "first_name": _firstnameController.text,
          "last_name": _lastnamerController.text,
          "phone_number": _phoneNumberController.text,
          "priority": newPriority,
          "property_id": propertyId,
          "rec_status": 8,
          "unit_number": unitNumber,
          "user_id": userId
        };

        intercomViewModel.intercomRegistration(data, context).then((value) {
          if (value.data!.status == 201) {
            print('msg = ${value.data!.mobMessage}');
            Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
          } else {
            Utils.flushBarErrorMessage(" ${value.data!.mobMessage}", context);
          }
        }).onError((error, stackTrace) {
          if (kDebugMode) {
            Utils.flushBarErrorMessage(error.toString(), context);
            print(error.toString());
          }
        });
      } else {
        Map<String, dynamic> data = {
          "country_code": widget.data.country_code,
          "first_name": _firstnameController,
          "last_name": _lastnamerController,
          "phone_number": _phoneNumberController,
          "priority": widget.data.priority ?? 0,
          "property_id": propertyId,
          "rec_status": 8,
          "unit_number": unitNumber,
          "updated_by": userId,
          "user_id": userId
        };

        //items.id
        intercomViewModel
            .updateIntercom(data, widget.data.id, context)
            .then((value) {
          if (value.data!.status == 200) {
            print('msg = ${value.data!.mobMessage}');
            Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
          } else {
            Utils.flushBarErrorMessage(" ${value.data!.mobMessage}", context);
          }
        }).onError((error, stackTrace) {
          if (kDebugMode) {
            Utils.flushBarErrorMessage(error.toString(), context);
            print(error.toString());
          }
        });
      }
    }
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
                  Navigator.pop(context);
                  // setState(() {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => IntercomListingScreen()));
                  // });
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
                    Navigator.pop(context);
                    // setState(() {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => IntercomListingScreen(  )));
                    // });
                  },
                  child: Text('Back',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
            ),
          ],
        ),
        title:
            Text('Intercom', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IntercomContactsScreen()),
                );
              },
              icon: Icon(Icons.contact_phone_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 15.0,right: 15.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       // if (userTypeName == "Resident / Unit users")
            //         Container(
            //           // width: MediaQuery.of(context).size.width * 0.20,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10.0),
            //               bottomLeft: Radius.circular(10.0),
            //               topRight: Radius.circular(10.0),
            //               bottomRight: Radius.circular(10.0),
            //
            //             ),
            //             color: Color(0xFF85D2FF),
            //           ),
            //           child: SizedBox(
            //               height: MediaQuery.of(context).size.height * 0.035,
            //               width :MediaQuery.of(context).size.width * 0.035,
            //               child: ElevatedButton(
            //                 style: ElevatedButton.styleFrom(
            //                   primary: Color(0xFF1883BD) ,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.only(
            //                       topLeft: Radius.circular(10.0),
            //                       bottomLeft: Radius.circular(10.0),
            //                       topRight: Radius.circular(10.0),
            //                       bottomRight: Radius.circular(10.0),
            //                     ),
            //                   ),
            //                 ),
            //                 onPressed: () async {
            //                   Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                       builder: (context) => IntercomContactsScreen(),
            //                     ),
            //                   );
            //                 },
            //                 child: Icon(
            //                   Icons.quick_contacts_dialer_sharp,
            //                   color:  Colors.white ,
            //                 ),
            //
            //               )
            //           ),
            //         ),
            //       // SizedBox(
            //       //   width: MediaQuery.of(context).size.width * 0.01,
            //       // ),
            //     ],
            //   ),
            // ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    MyTextField(
                        preffixIcon: Icons.person,
                        controller: _firstnameController,
                        labelText: 'First Name',
                        textInputType: TextInputType.text),
                    MyTextField(
                        preffixIcon: Icons.library_add_sharp,
                        controller: _lastnamerController,
                        labelText: 'Last Name',
                        textInputType: TextInputType.number),

                    MyTextField(
                        preffixIcon: Icons.phone_android,
                        controller: _phoneNumberController,
                        labelText: 'Mobile Number',
                        textInputType: TextInputType.text),
                    // MyTextField(
                    //     controller: _licenseController,
                    //     labelText: 'Driving License No',
                    //     textInputType: TextInputType.text),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: PositiveButton(
                          text: 'Submit',
                          onPressed: () {
                            setState(() {
                              submitRegisterDetails();
                            });
                            _firstnameController.clear();
                            _lastnamerController.clear();
                            _phoneNumberController.clear();
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
