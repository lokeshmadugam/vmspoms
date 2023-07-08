import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../data/respose/Status.dart';
import '../../model/visitorreg/VisitorDetailsModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/MyTextField.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/visitorregistration/InviteVisitorViewModel.dart';

class VisitorCheckoutScreen extends StatefulWidget {
  const VisitorCheckoutScreen({Key? key}) : super(key: key);

  @override
  State<VisitorCheckoutScreen> createState() => _VisitorCheckoutScreenState();
}

class _VisitorCheckoutScreenState extends State<VisitorCheckoutScreen> {
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
  String? checkinDate;

  @override
  void initState() {
    super.initState();
    // Call the method to set the values of the text form fields
    // getqrData();
    getUserDetails();
    _initializeScanner();
    // String? parkingRequired = qrData?['Parking Required']?.toString();
    // if (parkingRequired == 'Yes') {
    //   isParkingRequired = true;
    // }
    fetchVisitType();
    fetchVisitReasons();
    fetchVehicleType();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arrivalDateController.text = DateFormat.yMd().format(DateTime.now());
    arrivalTimeController.text = TimeOfDay.now().format(context);
    checkoutDateController.text =
        DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
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

  //Favorite Visitors
  void fetchFavoriteVisitorList() async {
    viewModel
      ..getVisitorDetails(id).then((response) {
        if (response.data?.status == 200) {
          if (response.data?.result != null) {
            var data = response.data!.result;
            if (data != null) {
              setState(() {
                visitorData = data;
                if (visitorData != null) {
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
                  String? visitTypeValue = visitorData?.visitTypeName ?? '';
                  if (visitorData?.parkingRequired.toString() == 'Yes' ||
                      visitorData?.isParkingRequired == 1) {
                    isParkingRequired = true;
                  }
                  if (visitorData?.visitorCheckInOutDate != null) {
                    var data = visitorData?.visitorCheckInOutDate ?? [];
                    for (var i in data) {
                      checkinDate = i.visitorCheckinDate.toString();
                      checkinDateController.text = checkinDate.toString();
                    }
                  }
                  // isParkingRequired =   visitorData?.parkingRequired.toString() == 'Yes';
                  // isParkingRequired = qrData?['Parking Required']?.toString() == 'Yes';
                }
              });
            }
          }
        }
      }).catchError((error) {
        Utils.flushBarErrorMessage("failed", context);
      });
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
                                SizedBox(width: 120, child: Text(key ?? '')),
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

                  // nameController.text = qrData?['Visitor Name'] ?? '';
                  // mobilenumberController.text = qrData?['Mobile Number'] ?? '';
                  // carPlateNumberController.text =
                  //     qrData?['Vehicle Number'] ?? '';
                  // drivingLicenceNumberController.text =
                  //     qrData?['Driving Licence No'] ?? '';
                  // numberofvistorsController.text =
                  //     qrData?['Number of Visitors'] ?? '';
                  // unitNumberController.text =
                  //     qrData?['Number of Visitors'] ?? '';
                  // String? visitTypeValue = qrData?['Unit No.'] ?? '';
                  // isParkingRequired = qrData?['Parking Required']?.toString() == 'Yes';
                  // isParkingRequired = qrData?['Parking Required']?.toString() == 'Yes';
                  id = int.parse(qrData?['Id'] ?? '0');
                  // updateIsParkingRequired(qrData);
                  print('id = $id');
                  if (id != 0) {
                    fetchFavoriteVisitorList();
                  }
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
      DateTime date = DateFormat.yMd().parse(arrivalDateController.text);
      DateFormat formatter = DateFormat('yyyy-MM-dd');

      String formattedDate = formatter.format(date);

      Map<String, dynamic> data = {
        "block_name": blockName,
        "id_driving_license_no": drivingLicenceNumberController.text,
        "is_parking_required": isParkingRequired ? 1 : 0,
        "is_preregistered": registeredid,
        "no_of_visitor": numberofvisitors,
        "prereg_end_date": "2023-05-09T09:41:42.224Z",
        "prereg_reqdate_mgmt_approve_status": 0,
        "prereg_start_date": "2023-05-09T09:41:42.224Z",
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
        "visitor_arrival_date": formattedDate,
        "visitor_arrival_time": arrivalTimeController.text,
        "visitor_mobile_no": mobilenumberController.text,
        "visitor_name": nameController.text,
        "visitor_registr_date":
            DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now()),
        "visitor_registrstion_status_id": 228,
        "visitor_stay_duration_hours": 0,
        "visitor_stay_enddate":
            entryType == "One Time" || entryType == "overnight stay"
                ? DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now())
                : null,
        "visitor_stay_startdate":
            entryType == "One Time" || entryType == "overnight stay"
                ? formattedDate
                : null,
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
          'Visitors Checkout',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
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
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  // ),
                  MyTextField(
                      labelText: 'ID/Driving License No',
                      hintText: 'ID/Driving License No',
                      controller: drivingLicenceNumberController,
                      textInputType: TextInputType.text,
                      preffixIcon: Icons.credit_card_rounded),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.01,
                  // ),
                  // VisitTypeDropdown
                  ChangeNotifierProvider.value(
                      value: viewModel,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Consumer<InviteVisitorViewModel>(
                            builder: (context, viewModel, _) {
                          if (viewModel.visitTypeResponse.status ==
                              Status.loading) {
                            return Center(
                                // child: CircularProgressIndicator(
                                //   valueColor:
                                //   AlwaysStoppedAnimation<Color>(Colors.amber),
                                // ),
                                );
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
                                          style: TextStyle(fontSize: 14),
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
                                // child: CircularProgressIndicator(
                                //   valueColor:
                                //   AlwaysStoppedAnimation<Color>(Colors.amber),
                                // ),
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
                                          style: TextStyle(fontSize: 14),
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
                                                        TextStyle(fontSize: 14),
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
                                style: TextStyle(
                                  fontSize: 14,
                                )),
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
                  if (checkinDate != null || checkinDate.toString().isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: MyDateField(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              // if (picked != null) {
                              //   setState(() {
                              //     checkinDateController.text =
                              //         DateFormat.yMd().format(picked);
                              //   });
                              // }
                            },
                            controller: checkinDateController,
                            hintText: 'Checkin Date',
                            labelText: 'Checkin Date',
                            preffixIcon: Icons.calendar_today,
                            enabled: false,
                          ),
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
                              // if (picked != null) {
                              //   setState(() {
                              //     checkoutDateController.text =
                              //         DateFormat.yMd().format(picked);
                              //   });
                              // }
                            },
                            controller: checkoutDateController,
                            hintText: 'Checkout Date',
                            labelText: 'Checkout Date',
                            preffixIcon: Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
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
                  Align(
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
                            });
                          },
                          text: "Submit"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
