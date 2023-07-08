import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../utils/PositiveButton.dart';
import '../../utils/MyTextfield.dart';

import '../../model/trustednbgh/TrustedNbghListModel.dart';
import '../../model/trustednbgh/TrustedNeighboursModel.dart';
import '../../utils/utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/trustednbgh/TrustedNbghViewModel.dart';

enum DisplayMode {
  Add,
  Edit,
}

class TrustedNeighbourFormScreen extends StatefulWidget {
  final TrustedNbghItems trustedNbgh;
  final DisplayMode displayMode;

  TrustedNeighbourFormScreen(
      {Key? key, required this.trustedNbgh, required this.displayMode})
      : super(key: key);

  @override
  State<TrustedNeighbourFormScreen> createState() =>
      _TrustedNeighbourFormScreenState();
}

class _TrustedNeighbourFormScreenState
    extends State<TrustedNeighbourFormScreen> {
  var userVM = UserViewModel();
  var tnViewModel = TrustedNeighbourViewModel();
  String firstName = "";
  String lastName = "";
  String blackName = '';
  String unitNumber = '';
  int userId = 0;
  int propertyId = 0;
  int unitdevicecnt = 0;
  int userTypeId = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController blockNameController = TextEditingController();
  TextEditingController unitNumberController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<NeighboursItems> _getNeighbours = [];
  TextEditingController trustedNeighbourController = TextEditingController();

  bool _showList = false;
  String _searchTerm = "";
  int? selectedNeighbour;
  bool _itemSelected = false;
  String? deviceId;

  void initState() {
    super.initState();
    getUserDetails();
    getDeviceId();
    widget.trustedNbgh;
  }

  void dispose() {
    super.dispose();
  }

  @override
  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id ?? 0;
      userId = userid;
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final devicecnt = value.userDetails?.unitDeviceCnt ?? 0;
      unitdevicecnt = devicecnt;
      final usertypeid = value.userDetails?.userType ?? 0;
      userTypeId = usertypeid;
      final firstname = value.userDetails?.firstName;

      firstName = firstname ?? '';
      print(firstName);
      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      final blkName = value.userDetails?.blockName;
      final unitNum = value.userDetails?.unitNumber;
      print(lastName);
      setState(() {
        firstName = firstname ?? '';

        lastName = lastname ?? '';

        blackName = blkName ?? '';

        unitNumber = unitNum ?? '';
      });
    });
    trustedNeighbourController.addListener(() {
      if (trustedNeighbourController.text.isNotEmpty) {
        setState(() {
          _searchTerm = trustedNeighbourController.text;
          _showList = true;
        });
      } else {
        _searchTerm = "";
        _showList = false;
      }
      _fetchNeighbours(_searchTerm);
    });
  }

  @override
  Future<void> getDeviceId() async {
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      print('Device ID: $deviceId');
    } catch (e) {
      print('Error getting device ID: $e');
    }
  }

  @override
  void submitTrustedNeighboursForm() async {
    if (nameController.text.isEmpty) {
      Utils.flushBarErrorMessage('Name can\'t be empty', context);
    } else if (blockNameController.text.isEmpty) {
      Utils.flushBarErrorMessage('black Name can\'t be empty', context);
    } else if (unitNumberController.text.isEmpty) {
      Utils.flushBarErrorMessage('Unit Number can\'t be empty', context);
    } else if (contactNumberController.text.isEmpty) {
      Utils.flushBarErrorMessage('Contact Number can\'t be empty', context);
    } else {
      Map<String, dynamic> data = {
        "created_by": userId,
        "property_id": propertyId,
        "rec_status": 8,
        "trneigb_added_device_id": deviceId,
        "trneigb_added_property_userid": userId,
        "trneigbour_added_datetime":
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now()),
        "trneigbour_property_user_id": selectedNeighbour,
        "unit_number": unitNumber
      };
      // "2023-04-26T10:05:24.330Z"

      tnViewModel.addTrustedNeighbours(data, context).then((value) {
        if (value.data!.status == 201) {
          print('msg = ${value.data!.mobMessage}');
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        } else {
          Utils.flushBarErrorMessage("${value.data!.result}", context);
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
  Future<DateTime?> selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null;
  }

  void updateDateTime(DateTime pickedDateTime) {
    String formattedDateTime =
        DateFormat('yyyy-MM-dd hh:mm a').format(pickedDateTime);
    dateController.text = formattedDateTime;
    String isoFormattedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(pickedDateTime);
    // now you can send the isoFormattedDateTime in the put method
  }

//   Future<void> updateTrustedNeighbourData() async{
//     String inputDateString = dateController.text.toString();
//     DateTime dateTime;
//     try {
//       dateTime = DateFormat('dd-MM-yyyy hh:mm a').parse(inputDateString);
//     } catch (e) {
//       // Handle the error when the input string is not in the correct format.
//       print('Error parsing date: $e');
//       return;
//     }
//
//     String formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
// var data = UpdateTrustedNeighbourModel();
//
// data.propertyId = propertyId;
//     data.trneigbourAddedDatetime = formattedDateTime;
//     data.trneigbAddedDeviceId = deviceId;
//     data.trneigbAddedPropertyUserid = userId;
//     data.propertyId = propertyId;
//     data.trneigbourPropertyUserId = widget.trustedNbgh.id;
//     data.recStatus = 8;
//     data.updatedBy = userId;
//
// tnViewModel.updateTrustedNeighbours(data, context).then((value) {
//   if (value.data!.status == 200) {
//     print('msg = ${value.data!.message}');
//     Utils.flushBarErrorMessage("${value.data!.message}", context);
//   } else {
//     Utils.flushBarErrorMessage("${value.data!.result}", context);
//   }
// }).onError((error, stackTrace) {
//   if (kDebugMode) {
//     Utils.flushBarErrorMessage(error.toString(), context);
//     print(error.toString());
//   }
// });
//   }
  @override
  Future<void> _fetchNeighbours(String searchTerm) async {
    var response = await tnViewModel.fetchAllTrustedNeighbours(
      "ASC",
      "id",
      1,
      500,
      propertyId,
      searchTerm,
    );

    if (response.data?.status == 200) {
      if (response.data?.result != null) {
        var data = response.data!.result!.items;
        if (data != null) {
          setState(() {
            _getNeighbours = data;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Trusted Neighbours',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: widget.displayMode == DisplayMode.Add
          ? buildSingleChildScrollViewCreate(context)
          : widget.displayMode == DisplayMode.Edit
              ? editbuildSingleChildScrollView(context)
              : Container(),
    );
  }

  SingleChildScrollView buildSingleChildScrollViewCreate(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTextField(
              controller: trustedNeighbourController,
              textInputType: TextInputType.text,
              suffixIcon: Icons.search,
              hintText: 'Search the trusted neighbor',
              labelText: 'Trusted Neighbour',
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                  _itemSelected = false; // Reset the flag
                });
              },
            ),
            _showList && !_itemSelected
                ? Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(10.0),
                    child: Container(
                      height: _getNeighbours.length * 30.0,
                      child: ListView.builder(
                        itemExtent: 30.0,
                        itemCount: _getNeighbours
                            .where((neighbour) => (neighbour.firstName!
                                    .toLowerCase()
                                    .contains(_searchTerm.toLowerCase()) ||
                                neighbour.unitNumber!
                                    .toLowerCase()
                                    .contains(_searchTerm.toLowerCase())))
                            .toList()
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          final filteredNeighbours = _getNeighbours
                              .where((neighbour) => (neighbour.firstName!
                                      .toLowerCase()
                                      .contains(_searchTerm.toLowerCase()) ||
                                  neighbour.unitNumber!
                                      .toLowerCase()
                                      .contains(_searchTerm.toLowerCase())))
                              .toList();
                          final neighbour = filteredNeighbours[index];
                          if (neighbour == null) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              child: Text(
                                "No data found",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              final name = neighbour.firstName ?? '';
                              final unitNumber = neighbour.unitNumber ?? '';
                              final blockname = neighbour.blockName ?? '';
                              final contact = neighbour.mobileNo ?? '';
                              nameController.text = name;
                              unitNumberController.text = unitNumber;
                              blockNameController.text = blockname;
                              contactNumberController.text = contact;
                              setState(() {
                                _itemSelected = true;
                              });
                              selectedNeighbour = neighbour.id ?? 0;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${neighbour.firstName}-${neighbour.lastName}-${neighbour.unitNumber}-${neighbour.blockName}",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            _itemSelected
                ? Column(
                    children: [
                      MyTextField(
                        preffixIcon: Icons.person,
                        controller: nameController,
                        textInputType: TextInputType.text,
                        hintText: 'Name',
                        labelText: 'Name',
                        enabled: false,
                      ),
                      MyTextField(
                        controller: contactNumberController,
                        textInputType: TextInputType.number,
                        hintText: 'contact No.',
                        labelText: 'Contact No.',
                        enabled: false,
                      ),
                      MyTextField(
                        preffixIcon: Icons.apartment,
                        controller: blockNameController,
                        textInputType: TextInputType.text,
                        hintText: 'block Name',
                        labelText: 'block Name',
                        enabled: false,
                      ),
                      MyTextField(
                        preffixIcon: Icons.home,
                        controller: unitNumberController,
                        textInputType: TextInputType.text,
                        hintText: 'Unit No.',
                        labelText: 'Unit No.',
                        enabled: false,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: PositiveButton(
                              text: 'Submit',
                              onPressed: () {
                                setState(() {
                                  submitTrustedNeighboursForm();
                                });
                                nameController.clear();
                                contactNumberController.clear();
                                blockNameController.clear();
                                unitNumberController.clear();
                              },
                            )),
                      )
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView editbuildSingleChildScrollView(BuildContext context) {
    final nameController = TextEditingController(
        text: widget.trustedNbgh.trustedNegihbourName ?? '');
    var nameParts = nameController.text.split(' ');
    String inputDateString = widget.trustedNbgh.trneigbourAddedDatetime ?? '';
    DateTime inputDate = DateTime.parse(inputDateString);
    String outputDateString =
        DateFormat('yyyy-MM-dd hh:mm a').format(inputDate);

    dateController = TextEditingController(text: outputDateString);

    return SingleChildScrollView(
      child: Column(
        children: [
          MyTextField(
            controller: trustedNeighbourController,
            textInputType: TextInputType.text,
            hintText: 'search the trustedneighbour',
            labelText: 'Trusted Neighbour',
            onChanged: (value) {
              setState(() {
                _searchTerm = value;
                _itemSelected = false; // Reset the flag
              });
            },
          ),
          _showList && !_itemSelected
              ? Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(10.0),
                  child: Container(
                    height: _getNeighbours.length * 30.0,
                    child: ListView.builder(
                      itemExtent: 30.0,
                      itemCount: _getNeighbours
                          .where((neighbour) => neighbour.firstName!
                              .toLowerCase()
                              .contains(_searchTerm.toLowerCase()))
                          .toList()
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        final filteredNeighbours = _getNeighbours
                            .where((neighbour) => neighbour.firstName!
                                .toLowerCase()
                                .contains(_searchTerm.toLowerCase()))
                            .toList();
                        final neighbour = filteredNeighbours[index];
                        if (neighbour == null) {
                          return Padding(
                            padding:
                                EdgeInsets.only(left: 5, right: 5, bottom: 5),
                            child: Text(
                              "No data found",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return InkWell(
                          onTap: () {
                            final name = neighbour.firstName ?? '';
                            final unitNumber = neighbour.unitNumber ?? '';
                            final blockname = neighbour.blockName ?? '';
                            final contact = neighbour.mobileNo ?? '';
                            nameController.text = name;
                            unitNumberController.text = unitNumber;
                            blockNameController.text = blockname;
                            contactNumberController.text = contact;
                            setState(() {
                              _itemSelected = true;
                            });
                            selectedNeighbour = neighbour.id ?? 0;

                            // Update nameParts and trustedNbgh.trustedNegihbourName
                            final newParts = [
                              neighbour.firstName ?? '',
                              neighbour.lastName ?? '',
                              nameParts.length > 2 ? nameParts[2] : '',
                              neighbour.mobileNo ?? '',
                              nameParts.length > 4 ? nameParts[4] : '',
                              neighbour.unitNumber ?? '',
                              nameParts.length > 6 ? nameParts[6] : '',
                              neighbour.blockName ?? '',
                            ];
                            setState(() {
                              nameParts = newParts;
                              widget.trustedNbgh.trustedNegihbourName =
                                  newParts.join(' ');
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${neighbour.firstName}-${neighbour.lastName}-${neighbour.unitNumber}-${neighbour.blockName}"),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : SizedBox.shrink(),
          MyTextField(
            controller: TextEditingController(
                text: nameParts.isNotEmpty ? nameParts[0] : ''),
            textInputType: TextInputType.text,
            hintText: 'First name',
            labelText: 'First name',
            onChanged: (value) {
              nameParts.isNotEmpty
                  ? nameParts[0] = value
                  : nameParts.add(value);
              widget.trustedNbgh.trustedNegihbourName = nameParts.join(' ');
            },
          ),
          MyTextField(
            controller: TextEditingController(
                text: nameParts.length > 1 ? nameParts[1] : ''),
            textInputType: TextInputType.text,
            hintText: 'Last name',
            labelText: 'Last name',
            onChanged: (value) {
              nameParts.length > 1
                  ? nameParts[1] = value
                  : nameParts.add(value);
              widget.trustedNbgh.trustedNegihbourName = nameParts.join(' ');
            },
          ),
          // MyTextField(
          //   controller: TextEditingController(
          //       text: nameParts.length > 7 ? nameParts[7] : ''),
          //   textInputType: TextInputType.number,
          //   hintText: 'contact No.',
          //   labelText: 'Contact No.',
          //   onChanged: (value) {
          //     nameParts.isNotEmpty
          //         ? nameParts[3] = value
          //         : nameParts.add(value);
          //     widget.trustedNbgh.trustedNegihbourName = nameParts.join(' ');
          //   },
          // ),
          MyTextField(
            controller: TextEditingController(
                text: nameParts.length > 5 ? nameParts[5] : ''),
            textInputType: TextInputType.text,
            hintText: 'block Name',
            labelText: 'block Name',
            onChanged: (value) {
              nameParts.length > 3
                  ? nameParts[3] = value
                  : nameParts.add(value);
              widget.trustedNbgh.trustedNegihbourName = nameParts.join(' ');
            },
          ),
          MyTextField(
            controller: TextEditingController(
                text: nameParts.length > 3 ? nameParts[3] : ''),
            textInputType: TextInputType.text,
            hintText: 'Unit No.',
            labelText: 'Unit No.',
            onChanged: (value) {
              nameParts.length > 1
                  ? nameParts[1] = value
                  : nameParts.add(value);
              widget.trustedNbgh.trustedNegihbourName = nameParts.join(' ');
            },
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                // TextFormField(
                //   controller: dateController,
                //   decoration: InputDecoration(
                //     // ...
                //     suffixIcon: IconButton(
                //       onPressed: () async {
                //         DateTime? pickedDateTime = await selectDateTime(context);
                //         if (pickedDateTime != null) {
                //           updateDateTime(pickedDateTime);
                //         }
                //       },
                //       icon: Icon(Icons.calendar_month),
                //     ),
                //   ),
                //   keyboardType: TextInputType.datetime,
                // ),

                TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Date',
                labelText: 'Date',
                suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        DateTime pickedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        String formattedDateTime =
                            DateFormat('yyyy-MM-dd hh:mm a')
                                .format(pickedDateTime);
                        dateController.text = formattedDateTime;
                        // widget.trustedNbgh.trneigbourAddedDatetime = formattedDateTime;
                      }
                    }
                  },
                  icon: Icon(Icons.calendar_month),
                ),
              ),
              keyboardType: TextInputType.datetime,
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              child: PositiveButton(
                text: 'Submit',
                onPressed: () {
                  // updateTrustedNeighbourData();
                },
              ))
        ],
      ),
    );
  }
}
// MyTextField(
//   controller: trustedNeighbourController,
//   textInputType: TextInputType.text,
//   onChanged: (value) {
//     setState(() {
//       _searchTerm = value;
//     });
//   },
// ),
