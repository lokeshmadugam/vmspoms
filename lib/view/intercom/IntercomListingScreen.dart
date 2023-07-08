import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/model/intercom/IntercomListingModel.dart';
import '/utils/Popup.dart';
import '/view/intercom/IntercomFormScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/respose/Status.dart';
import '../../model/SignInModel.dart';
import '../../utils/CardData.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/intercom/IntercomViewModel.dart';
import '../intercom/IntercomContactsScreen.dart';

class IntercomListingScreen extends StatefulWidget {
  var data;

  IntercomListingScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<IntercomListingScreen> createState() => _IntercomListingScreenState();
}

class _IntercomListingScreenState extends State<IntercomListingScreen> {
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

  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;

  void initState() {
    super.initState();
    getUserDetails();
    permissions = widget.data;
    actionPermissions();
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

  void actionPermissions() async {
    setState(() {
      for (var item in permissions) {
        if ((item.moduleDisplayNameMobile == "Intercom") &&
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
            } else if (act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");
            }
          }
        }
      }
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
        title:
            Text('Intercom', style: Theme.of(context).textTheme.headlineLarge),
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
                  if (iscreate)
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF036CB2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      onTap: () {
                        // popUp();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntercomFormScreen(
                                      data: null,
                                      inetrcomcontact: contact,
                                    )));
                        //   // priorty: priorityCounter,
                      },
                    ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ReorderableListView.builder(
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

                    int displayedIndex = index + 1;

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
                        onDismissed: (direction) async {
                          setState(() {
                            _filteredintercomList.removeAt(index);
                          });

                          return showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    elevation: 16,
                                    child: Popup(
                                      title: 'Intercom Details',
                                      message:
                                      ' Are you sure you want to delete this id?',
                                      negativeButtonText: "No",
                                      onNegativePressed: () {
                                        fetchIntercomList();
                                        Navigator.pop(context);
                                      },
                                      positiveButtonText: "Yes",
                                      onPositivePressed: () async {
                                        if (isdelete) {
                                          final response = await intercomViewModel
                                              .deletetIntercomDetails(
                                              item.id, context);

                                          if (response.data!.status ==
                                              200) {
                                            setState(() {
                                              fetchIntercomList();
                                              Utils.toastMessage(response
                                                  .data!.mobMessage
                                                  .toString());

                                              Navigator.pop(context);
                                            });
                                          } else if (response
                                              .data!.result ==
                                              Status.error) {
                                            setState(() {
                                              _filteredintercomList.insert(
                                                  index, item);
                                              Utils.flushBarErrorMessage(
                                                  response.data!.mobMessage
                                                      .toString(),
                                                  context);
                                            });
                                          }
                                        } else {
                                          fetchIntercomList();
                                          Navigator.pop(context);
                                          Utils.toastMessage(
                                              'Do not have access to delete');
                                        }
                                      },
                                    ));
                              });
                        },
                        child: buildInkWell(context, item));

                    // return Container(
                    //   key: UniqueKey(),
                    // );
                  },

                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      final adjustedOldIndex =
                          oldIndex + 1; // Adjust old index by adding 1
                      var adjustedNewIndex =
                          newIndex + 1; // Adjust new index by adding 1

                      if (adjustedNewIndex > adjustedOldIndex) {
                        adjustedNewIndex -= 1;
                      }

                      final item =
                          _filteredintercomList.removeAt(adjustedOldIndex - 1);
                      _filteredintercomList.insert(adjustedNewIndex - 1, item);

                      // Update the priority based on the new order
                      if (isupdate) {
                        updatePriorities();
                      }
                    });
                  },

                  // onReorder: (oldIndex, newIndex) {
                  //   setState(() {
                  //     final adjustedOldIndex = oldIndex + 1; // Adjust old index by adding 1
                  //     final adjustedNewIndex = newIndex + 1; // Adjust new index by adding 1
                  //
                  //     // Update the priority of the moved item
                  //     final movedItem = _filteredintercomList.removeAt(adjustedOldIndex - 1);
                  //     movedItem.priority = adjustedNewIndex;
                  //     _filteredintercomList.insert(adjustedOldIndex - 1, movedItem);
                  //
                  //     // Update the priorities of other items
                  //     updatePriorities();
                  //
                  //     // Perform the reorder of the list based on the updated priorities
                  //     final item = _filteredintercomList.removeAt(adjustedOldIndex - 1);
                  //     _filteredintercomList.insert(adjustedNewIndex - 1, item);
                  //   });
                  // },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  InkWell buildInkWell(BuildContext context, IntercomItems item) {
    return InkWell(
      child: Card(
        color: Colors.grey.shade100,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                      _launchPhoneDialer(item.phoneNumber ?? '');
                    },
                    icon: Icon(Icons.phone_forwarded, color: Color(0xFF036CB2)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (isupdate || isview) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  IntercomFormScreen(data: item, inetrcomcontact: contact),
            ),
          );
        }
      },
    );
  }

  void updatePriorities() {
    for (int i = 0; i < _filteredintercomList.length; i++) {
      var item = _filteredintercomList[i];
      item.priority = i + 1;
      Map<String, dynamic> data = {
        "country_code": item.countryCode,
        "first_name": item.firstName,
        "last_name": item.lastName,
        "phone_number": item.phoneNumber,
        "priority": item.priority,
        "property_id": item.propertyId,
        "rec_status": 8,
        "unit_number": unitNumber,
        "updated_by": userId,
        "user_id": userId,
      };

      // Perform the update for each item asynchronously
      intercomViewModel.updateIntercom(data, item.id!, context).then((value) {
        if (value.data!.status == 200) {
          print('msg = ${value.data!.mobMessage}');
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        } else {
          Utils.flushBarErrorMessage("Registration Failed".toString(), context);
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          Utils.flushBarErrorMessage(error.toString(), context);
          print(error.toString());
        }
      });
    }
  }

// void updatePriorities() {
//   for (int i = 1; i < _filteredintercomList.length; i++) {
//     var item = _filteredintercomList[i];
//     item.priority = i;
//     Map<String, dynamic> data = {
//       "country_code": item.countryCode,
//       "first_name": item.firstName,
//       "last_name": item.lastName,
//       "phone_number": item.phoneNumber,
//       "priority": item.priority,
//       "property_id": item.propertyId,
//       "rec_status": 8,
//       "updated_by": userId,
//       "user_id": userId,
//
//     };
//
//     intercomViewModel.updateIntercom( data,item.id!, context).then((value) {
//       if (value.data!.status == 200) {
//         print('msg = ${value.data!.mobMessage}');
//         Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
//       } else {
//         Utils.flushBarErrorMessage("Registration Failed".toString(), context);
//       }
//     }).onError((error, stackTrace) {
//       if (kDebugMode) {
//         Utils.flushBarErrorMessage(error.toString(), context);
//         print(error.toString());
//       }
//     });
//   }
// }
}
