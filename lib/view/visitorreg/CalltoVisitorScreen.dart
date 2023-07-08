import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/model/intercom/IntercomListingModel.dart';
import '/utils/CardData.dart';
import '/view/intercom/IntercomFormScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/intercom/IntercomViewModel.dart';
import '../intercom/IntercomContactsScreen.dart';

class CalltoVisitorScreen extends StatefulWidget {
  const CalltoVisitorScreen({Key? key}) : super(key: key);

  @override
  State<CalltoVisitorScreen> createState() => _CalltoVisitorScreenState();
}

class _CalltoVisitorScreenState extends State<CalltoVisitorScreen> {
  var userVM = UserViewModel();
  var intercomViewModel = IntercomViewModel();
  String firstName = "";
  String lastName = "";
  int propertyId = 0;
  int userId = 0;

  String unitNumber = " ";
  List<IntercomItems> _intercomList = [];
  List<IntercomItems> _filteredintercomList = [];
  final _searchController = TextEditingController();
  final contact = Contact(displayName: " ", phones: []);
  var priorityCounter;

  void initState() {
    super.initState();
    getUserDetails();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;
      userId = userid ?? 0;
      final firstname = value.userDetails?.firstName;

      firstName = firstname ?? '';

      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      final propertyid = value.userDetails?.propertyId;
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
              _filteredintercomList = _intercomList;
            });
            // for (var item in data) {
            //   final priorityCount = item.priority ?? 0;
            //   priorityCounter = (priorityCount+1);
            //   print("count = $priorityCounter");
            // }
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  @override
  // void _launchPhoneDialer(String phoneNumber) async {
  //   final Uri phoneUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //
  //   if (await canLaunch(phoneUri.toString())) {
  //     await launch(phoneUri.toString());
  //   } else {
  //     print('Could not launch dialer');
  //   }
  // }
  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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
        title: Text('Call to Visitors',
            style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        child: MyTextField(
                      hintText: 'Search',
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _filteredintercomList = _intercomList;
                          } else {
                            var searchWords = value.toLowerCase().split(' ');
                            _filteredintercomList = _intercomList.where((item) {
                              var nameWords = (item.firstName ?? '')
                                  .toLowerCase()
                                  .split(' ');
                              // Search based on first position or second position
                              return searchWords.any((searchWord) =>
                                  nameWords[0].contains(searchWord) ||
                                  (nameWords.length > 1 &&
                                      nameWords[1].contains(searchWord)));
                            }).toList();
                          }
                        });
                      },
                      textInputType: TextInputType.text,
                      suffixIcon: Icons.search,
                    )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ListView.builder(
                  itemCount: _filteredintercomList.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    _filteredintercomList.sort(
                        (a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));

                    var item = _filteredintercomList[index];

                    if (item == null) {
                      return Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                        child: Text(
                          "No data found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return Dismissible(
                      key: Key(item.id.toString()),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      child: Card(
                        color: Colors.grey.shade100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  ContainerValue(
                                    text: "First Name",
                                    value: ": ${item.firstName ?? ""}",
                                  ),
                                  Divider(color: Colors.grey.shade400),
                                  ContainerValue(
                                    text: "Last Name",
                                    value: ": ${item.lastName ?? ''}",
                                  ),
                                  Divider(color: Colors.grey.shade400),
                                  ContainerValue(
                                    text: "Mobile Number",
                                    value: ": ${item.phoneNumber ?? ''}",
                                  ),
                                  Divider(color: Colors.grey.shade400),
                                  ContainerValue(
                                    text: "Priority",
                                    value: ": ${item.priority.toString()}",
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _launchPhoneDialer(
                                          item.phoneNumber ?? '');
                                    },
                                    icon: Icon(Icons.phone_forwarded,
                                        color: Color(0xFF036CB2)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

// Container containerValue({required var text, required String value,}) {
//   return Container(
//     child: Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Row(
//         children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width / 3,
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           //VerticalDivider(width: 1,),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
/*
 void popUp() {

    showDialog(
      context: context,

      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          child: StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return
      SingleChildScrollView(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                color: Color(0xFF036CB2),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                //gradient: blueGreenGradient,
              ),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    'Verify Unit',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.04,
              // width: MediaQuery.of(context).size.width * 0.95,
              child: Center(
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(10.0),
                  selectedColor: Color(0xFF85D2FF),
                  fillColor: Color(0xFF036CB2),
                  // Colors.indigo.shade500,
                  borderColor: Colors.grey.shade400,
                  borderWidth: 1,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: isSelectedPopup[0]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30),
                      child: Text(
                        'Mobile Number',
                        style: TextStyle(
                          color: isSelectedPopup[1]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                  isSelected: isSelectedPopup,
                  onPressed: (index) {
                    setState(() {
                      for (int i = 0; i < isSelectedPopup.length; i++) {
                        isSelectedPopup[i] = i == index;
                      }
                    });
                  },
                ),
              ),
            ),
            isSelectedPopup[0]
                ? SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.90,
              child: TextFormField(
                controller: emailPopupController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    prefixText: ' ',
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email_rounded)
                ),
              ),
            )
                : SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.90,
              child: TextFormField(
                controller: mobileNumberPopupController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    prefixText: ' ',
                    hintText: "Mobile Number",
                    prefixIcon: Icon(Icons.dialpad)
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.90,
              child: ValueListenableBuilder(
                  valueListenable: obsecurePassword,
                  builder: (context, value, child) {
                    return TextFormField(
                      controller: passwordPopupController,
                      obscureText: obsecurePassword.value,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        prefixText: ' ',
                        hintText: "Password",
                        prefixIcon: Icon(Icons.password_rounded),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                                onTap: () {
                                  obsecurePassword.value =
                                  !obsecurePassword.value;
                                },
                                child: obsecurePassword.value
                                    ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                                    : const Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.grey,
                                )),
                            IconButton(
                              icon: Image.asset(
                                "assets/images/face-id-100.png",
                              ),
                              onPressed: () {
                                // showBiometricAlertDialogPopup();
                                // _checkBiometric();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: PositiveButton(
            //       text: 'Close',
            //       onPressed: () {
            //         Navigator.pop(context);
            //       }),
            // ),
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.01,
            ),
          ],
        ),
      );

    }
          ),
        );
      },
    );
  }
 */
