import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../viewmodel/FileStorage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../model/lostfound/UnclaimedItems.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/MyTextfield.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/SignInModel.dart';
import '../../utils/MyDateField.dart';
import 'package:path_provider/path_provider.dart';

import '../../viewmodel/lostfound/EditLostDetailsFormScreenViewModel.dart';

class EditUnclaimedItemsFormScreen extends StatefulWidget {
  var data;
  bool upload;
  EditUnclaimedItemsFormScreen({super.key, required this.data,required this.upload});

  @override
  State<EditUnclaimedItemsFormScreen> createState() =>
      _EditUnclaimedItemsFormScreenState();
}

class _EditUnclaimedItemsFormScreenState
    extends State<EditUnclaimedItemsFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _foundByController = TextEditingController();
  final _dateFoundController = TextEditingController();
  final _foundItemNameController = TextEditingController();
  final _foundDescriptionController = TextEditingController();
  final _foundLostLocationController = TextEditingController();

  final _collectedByController = TextEditingController();
  final _collectedDateController = TextEditingController();
  final _remarksController = TextEditingController();

  UserDetails userDetails = UserDetails();
  File? _image;
  var token;
  var fileStgVM = FileStorageViewModel();
  bool _isFoundDetailsExpanded = true;
  bool _isCollectionDetailsExpanded = false;
  bool _isCollectionDetailsHeaderVisible = false;

  String _scanResult = '';
  DateTime? _selectedDateTime;

  Items items = Items();

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  String _signatureImagePath = '';
  List<String> imagePaths = [];

  List<String> pickedImagePaths = [];
  String? signatureUrl;
  List<String>? pickedImageUrls;

  QRViewController? qrViewController;
  late String qrCode;
  GlobalKey qrKey = GlobalKey();
  Map<String, String>? qrData;


  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      items = widget.data;
      _isFoundDetailsExpanded = false;
      _isCollectionDetailsHeaderVisible = true;
      _isCollectionDetailsExpanded = true;

      _foundByController.text = items.foundBy.toString();
      _dateFoundController.text = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(items.foundDateTime.toString() ?? ''));
      _foundItemNameController.text = items.foundItemName.toString();
      _foundDescriptionController.text = items.foundDescription.toString();
      _foundLostLocationController.text = items.foundLocation.toString();

      if (items.collectedBy == 0 || items.collectedBy == null) {
      } else {
        _collectedByController.text = items.collectedBy.toString();
        _collectedDateController.text = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(items.collectedDateTime.toString() ?? ''));
        _remarksController.text = items.collectedRemarks.toString();
      }
    }

    _getUserDetails();

  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    token = SignInModel.fromJson(jsonData).accessToken!;
  }

  Future<void> _createFile(BuildContext context, List<String> imagePaths) async {
    if (_signatureImagePath.isNotEmpty && pickedImagePaths.isEmpty) {
      imagePaths.add(_signatureImagePath);
    }  else if (_signatureImagePath.isEmpty && pickedImagePaths.isNotEmpty) {
      imagePaths.addAll(pickedImagePaths);

    } else if (_signatureImagePath.isNotEmpty && pickedImagePaths.isNotEmpty) {
      imagePaths.add(_signatureImagePath);
      imagePaths.addAll(pickedImagePaths);
      // .map((file) => file.path)
    } else {
      return;
    }

    try {
      if (imagePaths.isNotEmpty) {
        final qrcode = await fileStgVM.getMediaUpload(imagePaths, context);
        if (qrcode!.isNotEmpty) {
          List<String> _pickedImageUrls = []; // Initialize the list here
          String? _signatureUrl;

          for (int i = 0; i < qrcode!.length; i += 2) {
            String originalName = qrcode![i].trim();
            String url = qrcode![i + 1].trim();
            String originalNameWithUrl = '$originalName:$url';

            if (originalName == 'signature.png') {
              _signatureUrl = originalNameWithUrl;
              signatureUrl = _signatureUrl;
            } else {
              _pickedImageUrls.add(url);
              pickedImageUrls = _pickedImageUrls;
            }
          }

          print('Signature URL: $_signatureUrl');
          print('Picked Image URLs: $_pickedImageUrls');
          print('Signature URL: $signatureUrl');
          print('Picked Image URLs: $pickedImageUrls');
          if ((_signatureUrl != null || _pickedImageUrls != null ) ||(_signatureUrl != null && _pickedImageUrls != null)) {
            createUnclaimedItems();
          }else{
            'error';
          }
        } else {
          throw Exception('Invalid QR code response');
        }



      }

    }catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to generate QR code');
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
                    style: TextStyle(
                      fontSize: 16, // reduce the font size
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Unclaimed Form',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor:  Color(0xFF036CB2),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isFoundDetailsExpanded = !_isFoundDetailsExpanded;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF3F9AE5)),
                    //color: Colors.indigo[300],
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "Found Details",
                            style: TextStyle(fontSize: 18, color: Colors.white
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          _isFoundDetailsExpanded
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
                  visible: _isFoundDetailsExpanded,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        MyTextField(
                            preffixIcon: Icons.find_replace,
                            controller: _foundByController,
                            suffixIcon: Icons.qr_code_2_outlined,
                            onPressed: (){
                              _scanQRCode(1);
                            },
                            labelText: 'Found by',
                            textInputType: TextInputType.number),
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          labelText: 'Date Found',
                          controller: _dateFoundController,
                          onPressed: () {
                            _pickDateTime(_dateFoundController);
                          },
                        ),

                        MyTextField(
                            preffixIcon: Icons.list_outlined,
                            controller: _foundItemNameController,
                            labelText: 'Item Name',
                            textInputType: TextInputType.text),
                        MyTextField(
                            preffixIcon: Icons.note,
                            controller: _foundDescriptionController,
                            labelText: 'Description',
                            textInputType: TextInputType.text),
                        MyTextField(
                            preffixIcon: Icons.location_on_outlined,
                            controller: _foundLostLocationController,
                            labelText: 'Found Location',
                            textInputType: TextInputType.text),
                        if(widget.upload)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Upload image :',
                                    style: TextStyle(
                                        fontSize: 16.0,
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
                                        Icon(Icons.upload,color: Colors.white,),
                                        Text(
                                          'Gallery',
                                          style: TextStyle(color: Colors.white),
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
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                            // Container(
                            //   //width: MediaQuery.of(context).size.width,
                            //   height: MediaQuery.of(context).size.height * 0.20,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.grey),
                            //       borderRadius: BorderRadius.circular(5)),
                            //   child: Center(
                            //     child: _image == null
                            //         ? Text('No Image Selected')
                            //         : Image.file(_image!),
                            //   ),
                            // ),


                            Container(
                              height: MediaQuery.of(context).size.height * 0.20,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: pickedImagePaths.isEmpty
                                    ? Text('No Image Selected')
                                    : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pickedImagePaths.length,
                                  itemBuilder: (context, index) {
                                    return Image.file(File(pickedImagePaths[index]));
                                  },
                                ),
                              ),
                            )







                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Visibility(
                  visible: _isCollectionDetailsHeaderVisible,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isCollectionDetailsExpanded =
                        !_isCollectionDetailsExpanded;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF386DB6)),
                      //color: Colors.indigo[300],
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Collection Details",
                              style: TextStyle(fontSize: 18, color: Colors.white
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            _isCollectionDetailsExpanded
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
                  visible: _isCollectionDetailsExpanded,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        MyTextField(
                            preffixIcon: Icons.collections,
                            controller: _collectedByController,
                            suffixIcon: Icons.qr_code_2_outlined,
                            onPressed: () {
                              _scanQRCode(2);
                            },
                            labelText: 'Collected by',
                            textInputType: TextInputType.number),
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          labelText: 'Collected on',
                          controller: _collectedDateController,
                          onPressed: () {
                            _pickDateTime(_collectedDateController);
                          },
                        ),
                        MyTextField(
                            preffixIcon: Icons.sticky_note_2_sharp,
                            controller: _remarksController,
                            labelText: 'Remarks',
                            textInputType: TextInputType.text),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sign Here :',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: PositiveButton(
                      text: 'Submit',
                      onPressed: () async {
                        // await _createFile(context, imagePaths);
                        // _uploadImage(_image!.path, _signatureImagePath);
                        createUnclaimedItems();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> _scanQRCode(int i) async {
    try {
      qrViewController?.resumeCamera();
      if(i==1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                height: 250,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (controller) {
                    _onQRViewCreated(controller);
                  },
                ),
              ),
            );
          },
        );
      } else if(i==2) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                height: 250,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (controller) {
                    _onQRViewCreated1(controller);
                  },
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code!;
        qrData = _parseQRCodeData(qrCode);
        qrViewController?.pauseCamera();

        Navigator.pop(context);

        _foundByController.text = qrData!['User Id']!;
      });
    });
  }

  void _onQRViewCreated1(QRViewController controller) {
    qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code!;
        qrData = _parseQRCodeData(qrCode);
        qrViewController?.pauseCamera();

        Navigator.pop(context);

        _collectedByController.text = qrData!['User Id']!;
      });
    });
  }




  Future<void> getImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxHeight: 100,
      maxWidth: 100,
    );

    if (pickedFiles != null) {
      setState(() {
        pickedImagePaths.clear(); // Clear the list before adding new paths

        for (var pickedFile in pickedFiles) {
          pickedImagePaths.add(pickedFile.path);
        }

        _image = pickedImagePaths.isNotEmpty ? File(pickedImagePaths[0]) : null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
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
    String? formattedDateFound;
    String? formattedDateCollected;

    if (_dateFoundController.text.isNotEmpty) {
      DateTime dateTime1 = DateFormat('yyyy-MM-dd hh:mm a')
          .parse(_dateFoundController.text.toString());
      formattedDateFound = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime1);
    }

    if (_collectedDateController.text.isNotEmpty) {
      DateTime dateTime2 = DateFormat('yyyy-MM-dd hh:mm a')
          .parse(_collectedDateController.text.toString());
      formattedDateCollected =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime2);
    }

    if (widget.data == null) {
      Map<String, dynamic> data = {
        "found_by": userDetails.id,
        "found_by_item_pic": "",
        "found_date_time": formattedDateFound,
        "found_description": _foundDescriptionController.text.toString(),
        "found_item_name": _foundItemNameController.text.toString(),
        "found_location": _foundLostLocationController.text.toString(),
        "found_unit_no": userDetails.unitNumber,
        "property_id": userDetails.propertyId,
        "rec_status": userDetails.recStatus,
        "updated_by": userDetails.id
      };

      Provider.of<EditLostDetailsFormScreenViewModel>(context, listen: false)
          .getMediaUpload(imagePath, data, context, items.id);
    } else {

      Map<String, dynamic> data = {
        "found_by": userDetails.id,
        "found_by_item_pic": "",
        "found_date_time": formattedDateFound,
        "found_description": _foundDescriptionController.text.toString(),
        "found_item_name": _foundItemNameController.text.toString(),
        "found_location": _foundLostLocationController.text.toString(),
        "found_unit_no": userDetails.unitNumber,
        "property_id": userDetails.propertyId,
        "rec_status": userDetails.recStatus,
        "updated_by": userDetails.id,
        "collected_by": _collectedByController.text.toString(),
        "collected_date_time": formattedDateCollected,
        "collected_remarks": _remarksController.text.toString(),
        "received_by_sign": "",
      };

      Provider.of<EditLostDetailsFormScreenViewModel>(context, listen: false)
          .getMediaUpload(imagePath, data, context, items.id);

    }
  }
  void createUnclaimedItems() async{
    String? formattedDateFound;
    String? formattedDateCollected;
    // String pickedImageUrlsString = pickedImageUrls!.join(',');
    if (_dateFoundController.text.isNotEmpty) {
      DateTime dateTime1 = DateFormat('yyyy-MM-dd hh:mm a')
          .parse(_dateFoundController.text.toString());
      formattedDateFound = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime1);

    }

    if (_collectedDateController.text.isNotEmpty) {
      DateTime dateTime2 = DateFormat('yyyy-MM-dd hh:mm a')
          .parse(_collectedDateController.text.toString());
      formattedDateCollected =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime2);
    }
    // String? formattedDateFound;
    // String? formattedDateCollected;
    // String pickedImageUrlsString = pickedImageUrls!.join(',');
    //
    // if (_dateFoundController.text.isNotEmpty) {
    //   DateTime dateTime1 = DateFormat('dd-MM-yyyy hh:mm a').parse(_dateFoundController.text);
    //
    //   String formattedDateFound = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime1);
    //
    // }



    //
    // if (_collectedDateController.text.isNotEmpty) {
    //   DateTime dateTime2 = DateFormat('MM/dd/yyyy hh:mm a').parse(_collectedDateController.text);
    //   formattedDateCollected = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime2);
    // }
    if (widget.data == null) {
      Map<String, dynamic> data = {
        "found_by": userDetails.id,
        "found_by_item_pic": 'pickedImageUrlsString',
        "found_date_time": formattedDateFound,
        "found_description": _foundDescriptionController.text.toString(),
        "found_item_name": _foundItemNameController.text.toString(),
        "found_location": _foundLostLocationController.text.toString(),
        "found_unit_no": userDetails.unitNumber,
        "property_id": userDetails.propertyId,
        "rec_status": userDetails.recStatus,
        "updated_by": userDetails.id
      };

      Provider.of<EditLostDetailsFormScreenViewModel>(context, listen: false)
          .createUnclaimedData(data, context);
    } else {

      Map<String, dynamic> data = {
        "found_by": userDetails.id,
        "found_by_item_pic": 'pickedImageUrlsString',
        "found_date_time": formattedDateFound,
        "found_description": _foundDescriptionController.text.toString(),
        "found_item_name": _foundItemNameController.text.toString(),
        "found_location": _foundLostLocationController.text.toString(),
        "found_unit_no": userDetails.unitNumber,
        "property_id": userDetails.propertyId,
        "rec_status": userDetails.recStatus,
        "updated_by": userDetails.id,
        "collected_by": _collectedByController.text.toString(),
        "collected_date_time": formattedDateCollected,
        "collected_remarks": _remarksController.text.toString(),
        "received_by_sign": signatureUrl,
      };

      Provider.of<EditLostDetailsFormScreenViewModel>(context, listen: false)
          .updateEditLostFoundDetails(items.id, data, context );

    }
  }
}
