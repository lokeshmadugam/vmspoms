import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../model/packages/PackageReceived.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/packages/PackageStatus.dart';
import '../../utils/NegativeButton.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../model/packages/PackageReceivedRequest.dart';

import 'package:image_picker/image_picker.dart';

import '../../model/SignInModel.dart';
import '../../utils/MyDateField.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/MyDropdown.dart';

import '../../utils/MyTextfield.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/packages/PackageReceivedFormScreenViewModel.dart';

class PackageReceivedFormScreen extends StatefulWidget {
  var data;

  PackageReceivedFormScreen({super.key, required this.data});

  @override
  State<PackageReceivedFormScreen> createState() =>
      _PackageReceivedFormScreenState();
}

class _PackageReceivedFormScreenState extends State<PackageReceivedFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _packageCollectedByController = TextEditingController();
  final _packageCollectedOnController = TextEditingController();
  final _packageReceivedDateController = TextEditingController();
  final _remarksController = TextEditingController();
  final _blockNameController = TextEditingController();
  final _unitNoController = TextEditingController();
  var packageFrom;
  var packageTypeId;
  UserDetails userDetails = UserDetails();
  File? _image;
  var token;
  String? _qrData;
  PackageReceivedFormScreenViewModel viewModel =
      PackageReceivedFormScreenViewModel();

  List<String> _blockSuggestions = [];
  List<String> _unitSuggestions = [];
  List<String> blockNamesList = [];
  List<String> unitNumbersList = [];

  bool _isPackageReceiptExpanded = false;
  bool _isPackageCollectionExpanded = false;
  bool _isPackageCollectionHeaderVisible = false;

  String? _courierName;

  Items items = Items();

  String _scanResult = '';

  DateTime? _selectedDateTime;
  String? blockName;
  String? unitNo;
  late PackageResult _packageStatus;
  var packageStatusId;

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  String _signatureImagePath = "";


  @override
  void dispose() {

    _packageCollectedByController.dispose();
    _packageCollectedOnController.dispose();
    _packageReceivedDateController.dispose();
    _remarksController.dispose();
    _blockNameController.dispose();
    _unitNoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.data == null) {
      _isPackageReceiptExpanded = true;
      _isPackageCollectionExpanded = false;
      _isPackageCollectionHeaderVisible = false;
      blockName = '';
      unitNo = '';
    } else {
      items = widget.data;
      print(items.id);

      _isPackageReceiptExpanded = false;
      _isPackageCollectionExpanded = true;
      _isPackageCollectionHeaderVisible = true;
      blockName = items.blockName.toString();
      unitNo = items.unitNumber.toString();
      _packageReceivedDateController.text = DateFormat('yyyy-MM-dd hh:mm a')
          .format(DateTime.parse(items.packageReceivedDate.toString() ?? ''));
      _remarksController.text = items.remarks.toString();
      _courierName = items.packageFrom.toString();
    }
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    token = SignInModel.fromJson(jsonData).accessToken!;

    blockNamesList.clear();
    unitNumbersList.clear();

    setState(() {
      fetchPackageStatus();
      Provider.of<PackageReceivedFormScreenViewModel>(context, listen: false)
          .fetchDeliveryServiceList(userDetails.countryCode);
      Provider.of<PackageReceivedFormScreenViewModel>(context, listen: false)
          .fetchPackageTypeList();
      Provider.of<PackageReceivedFormScreenViewModel>(context, listen: false)
          .fetchBlockUnitNoList("", userDetails.propertyId, "");
    });


   // _generateQRData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double? fontSize;
    if(width < 411 || height < 707){
      fontSize = 16;

    }else {
      fontSize = 18;

    }
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
                  child: Text(
                    'Back',
                  style: Theme.of(context).textTheme.headlineMedium
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Package Receipt',
        style: Theme.of(context).textTheme.headlineLarge
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isPackageReceiptExpanded = !_isPackageReceiptExpanded;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  Color(0xFF3F9AE5)),
                    //color: Colors.indigo[300],
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "Package Receipt Details",
                            style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 18, color: Colors.white
                              // fontWeight: FontWeight.bold,
                            ), ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          _isPackageReceiptExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isPackageReceiptExpanded,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(

                                child: MyTextField(controller: _blockNameController, textInputType: TextInputType.text,
                                  suffixIcon: Icons.arrow_drop_down_outlined,
                                  onPressed: popUpBlockList,
                                  labelText: 'Block Name',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child:  MyTextField(controller: _unitNoController, textInputType: TextInputType.text,
                                suffixIcon: Icons.arrow_drop_down_outlined,
                                onPressed: popUpUnitList,
                                labelText: 'Unit No.',
                              ),

                            ),
                          ],
                        ),
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          labelText: 'Package Received Date',
                          controller: _packageReceivedDateController,
                          onPressed: () {
                            _pickDateTime(_packageReceivedDateController);
                          },
                        ),
                        Consumer<PackageReceivedFormScreenViewModel>(
                            builder: (context, model, child) {
                          if (model.packageType.data != null) {
                            var data = model.packageType.data!.result!.items!;

                            return MyDropDown(
                                hintText: 'Package Type',
                                value: null,
                                items: data
                                    .map((item) => item.packageType)
                                    .map((packageType) =>
                                        DropdownMenuItem<String>(
                                          value: packageType,
                                          child: Text(packageType!),
                                        ))
                                    .toList(),
                                onchanged: (value) {
                                  for (int i = 0; i < data.length; i++) {
                                    if (value == data[i].packageType) {
                                      packageTypeId = data[i].id;
                                      break;
                                    }
                                  }
                                });
                          }
                          return Container();
                        }),
                        Consumer<PackageReceivedFormScreenViewModel>(
                            builder: (context, model, child) {
                          if (model.deliveryService.data != null) {
                            var data =
                                model.deliveryService.data!.result!.items!;

                            return MyDropDown(
                                hintText: 'Courier Services',
                                // package from
                                value: null,
                                items: data
                                    .map((item) => item.deliveryServName)
                                    .map((deliveryServName) =>
                                        DropdownMenuItem<String>(
                                          value: deliveryServName,
                                          child: Text(deliveryServName!),
                                        ))
                                    .toList(),
                                onchanged: (value) {
                                  packageFrom = value.toString();
                                });
                          }
                          return Container();
                        }),
                        MyTextField(
                          preffixIcon: Icons.sticky_note_2_sharp,
                            controller: _remarksController,
                            labelText: 'Remarks',
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.007,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Package Image :',
                                  style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF036CB2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons
                                      .camera_alt,size: 18,color: Colors.white,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6.0),
                                        child: Text(
                                          'Take Photo',
                                          style:  GoogleFonts.roboto(textStyle:TextStyle(fontSize: 16, color: Colors.white
                                              // fontWeight: FontWeight.bold,
                                            ), ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                getImage();
                              },
                            )
                          ],
                        ),
                        if(items.packageImg == null)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            //width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 0.5),
                                borderRadius: BorderRadius.circular(5),
                           ),
                            child: Center(
                              child: _image == null
                                  ? Text('No Image Selected')
                                  : Image.file(_image!),
                            ),
                          ),
                        ),
                        if(items.packageImg != null)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            //width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: _image == null
                                ? Image.network((items.packageImg ?? " ").trim())
                                  : Image.file(_image!),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Visibility(
                  visible: _isPackageCollectionHeaderVisible,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isPackageCollectionExpanded =
                            !_isPackageCollectionExpanded;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:  Color(0xFF386DB6)),
                      //color: Colors.indigo[300],
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Package Collection Details",
                              style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: Colors.white
                                // fontWeight: FontWeight.bold,
                              ), ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            _isPackageCollectionExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 30,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isPackageCollectionExpanded,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        MyTextField(
                            preffixIcon: Icons.person,
                            controller: _packageCollectedByController,
                            suffixIcon: Icons.qr_code_2_outlined,
                            onPressed: _scanQRCode,
                            labelText: 'Package Collected by',
                            textInputType: TextInputType.text),
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          labelText: 'Package Collected on',
                          controller: _packageCollectedOnController,
                          onPressed: () {
                            _pickDateTime(_packageCollectedOnController);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sign Here :',
                           style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 16, color: Colors.white
                              // fontWeight: FontWeight.bold,
                            ), ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: SfSignaturePad(
                                key: _signaturePadKey,
                                strokeColor: Colors.black,
                                backgroundColor: Colors.grey.shade200,
                                onDrawEnd: () {
                                  _saveSignatureImage();
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                /*if (_qrData != null)
                  Column(
                    children: [
                      Text(
                        'Scan this QR code:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      Visibility(
                        visible: true,
                        child: QrImageView(
                          data: _qrData.toString(),
                          version: QrVersions.auto,
                          size: 200.0,
                          gapless: false,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),*/
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: PositiveButton(

                        text: 'Submit',
                        onPressed: () {
                          _uploadImage(_image!.path, _signatureImagePath);

                          /*

                            Consumer<PackageReceivedFormScreenViewModel>(
                                builder: (context, model, child) {
                                  var data = model.postApiResponse.data!.status;

                                  if(data == 200){
                                    Utils.toastMessage('Success');
                                  }
                                  return Container();
                                }
                            );*/
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchPackageStatus() async {
    ApiResponse response = await viewModel.fetchPackageStatus();
    if (response.data!.status == 200) {
      setState(() {
        _packageStatus = response.data!.result;
        for(int i=0;i<_packageStatus.items!.length;i++){
          if(widget.data == null){
            if(_packageStatus.items![i].displayName == 'Package Arrived'){
              packageStatusId = _packageStatus.items![i].id;
              break;
            }
          } else {
            if(_packageStatus.items![i].displayName == 'Received'){
              packageStatusId = _packageStatus.items![i].id;
              break;
            }
          }
        }
      });
    } else {
      print(response.message);
    }
  }

  Future<void> _saveSignatureImage() async {
    try {
      final signatureData =
          await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
      final data =
          await signatureData.toByteData(format: ui.ImageByteFormat.png);
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/signature.png';
      final File file = File(filePath);
      await file.writeAsBytes(data!.buffer.asUint8List());

      setState(() {
        _signatureImagePath = filePath;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _scanQRCode() async {
    try {
      final String qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Scanner color
        'Cancel', // Cancel button text
        true, // Show flash icon
        ScanMode.QR, // Scan mode
      );
      setState(() {
        _scanResult = qrCode;
        _packageCollectedByController.text = _scanResult;
      });
    } on Exception catch (e) {
      print('Error: $e');
    }
  }

  void _generateQRData() {
    setState(() {
      String _firstName = userDetails.firstName.toString();
      String _lastName = userDetails.lastName.toString();
      String _email = userDetails.emailAddress.toString();
      String _blockName = userDetails.blockName.toString();
      String _unitNumber = userDetails.unitNumber.toString();
      String _appUserTypeName = userDetails.appUserTypeName.toString();
      String _mobile = userDetails.mobileNo.toString();
      _qrData =
          'First Name: $_firstName\nLast Name: $_lastName\nEmail: $_email\nBlock Name: $_blockName\nUnit No: $_unitNumber\nApp User Type Name: $_appUserTypeName\nMobile No: $_mobile';

      // Sample sample = Sample();
      // sample.firstName = userDetails.firstName.toString();
      // sample.lastName = userDetails.lastName.toString();
      // sample.emailAddress = userDetails.emailAddress.toString();
      // sample.blockName = userDetails.blockName.toString();
      // sample.unitNumber = userDetails.unitNumber.toString();
      // sample.appUserTypeName = userDetails.appUserTypeName.toString();
      // sample.mobileNo = userDetails.mobileNo.toString();
      // _qrData = sample.toJson().toString();
    });
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(selected.year, selected.month,
              selected.day, selectedTime.hour, selectedTime.minute);
          controller.text =
              DateFormat('yyyy-MM-dd hh:mm a').format(_selectedDateTime!);
        });
      }
    }
  }

  void _uploadImage(var imagePath, String signatureImagePath) {
    DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a')
        .parse(_packageReceivedDateController.text.toString());
    String formattedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);

    String formattedDateTime1 = "";
    if (_packageCollectedOnController.text.isNotEmpty) {
      DateTime dateTime1 = DateFormat('yyyy-MM-dd hh:mm a')
          .parse(_packageCollectedOnController.text.toString());
      formattedDateTime1 = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime1);
    }

    PackageReceivedRequest request = PackageReceivedRequest();
    request.id = items.id;
    request.blockName = blockName;
    request.packageCollectedBy = _packageCollectedByController.text.toString();
    request.packageCollectedOn = formattedDateTime1;
    request.packageCollectionAckImg = "";
    request.packageFrom = packageFrom;
    request.packageImg = "";
    request.packageReceiptNotification = "";
    request.packageReceivedBy = userDetails.id;
    request.packageReceivedDate = formattedDateTime;
    request.packageTypeId = packageTypeId;
    request.propertyId = userDetails.propertyId;
    request.recStatus = userDetails.recStatus;
    request.remarks = _remarksController.text.toString();
    request.unitNumber = unitNo;
    request.packageReceiptsStatus = packageStatusId;
    if(widget.data == null){
      request.createdBy = userDetails.id;
    } else {
      request.updatedBy = userDetails.id;
    }

    Provider.of<PackageReceivedFormScreenViewModel>(context, listen: false)
        .getMediaUpload(
            imagePath, signatureImagePath, request, context, widget.data);
  }


  void popUpBlockList() {

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
              //mainAxisSize: MainAxisSize.min,
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
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Block Names',
                       style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 16, color: Colors.white
                        // fontWeight: FontWeight.bold,
                      ), ),
                      ),
                    ),
                  ),
                ),
          Consumer<PackageReceivedFormScreenViewModel>(
              builder: (context, model, child) {
                if (model.blockUnitNumber.data != null) {
                  var data = model.blockUnitNumber.data!.result!.items!;



                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item =data[index];

                      return InkWell(
                        child: ListTile(
                          title: Text(item.blockName ?? ''),
                        ),
                        onTap: () {
                          setState(() {
                            _blockNameController.text = item.blockName ?? '';
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.01,
                      );
                    },
                  );
                }
                return Container();
              }),
                Align(
                  alignment: Alignment.center,
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



  void popUpUnitList() {
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
              //mainAxisSize: MainAxisSize.min,
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
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Unit Numbers',
                          style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 16, color: Colors.white
                            // fontWeight: FontWeight.bold,
                          ), ),
                      ),
                    ),
                  ),
                ),

                Consumer<PackageReceivedFormScreenViewModel>(
                    builder: (context, model, child) {
                      if (model.blockUnitNumber.data != null) {
                        var data = model.blockUnitNumber.data!.result!.items!;



                        return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var item =data[index];

                            return InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(item.unitNumber ?? ''),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _unitNoController.text = item.unitNumber ?? '';
                                });
                                Navigator.pop(context);
                                // Close the popup or perform any other actions needed
                              },
                            );

                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.01,
                            );
                          },
                        );
                      }
                      return Container();
                    }),
                Align(
                  alignment: Alignment.center,
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
}
