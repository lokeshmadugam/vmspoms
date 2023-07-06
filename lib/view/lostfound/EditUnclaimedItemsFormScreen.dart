import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  List<String>? pickedImageUrls = [];
var image;

  List<dynamic>? decodedList;
  List<String>? imageUrls;
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
      if (items.foundByItemPic!.isNotEmpty ){
        decodedList = jsonDecode(items.foundByItemPic ?? "[]");

        imageUrls = decodedList?.map((item) => item.toString()).toList();
      } else {
        image = items.foundByItemPic;
      }
      // if (items.foundByItemPic != null &&
      //     items.foundByItemPic!.isNotEmpty &&
      //     items.foundByItemPic is List<String>) {
      //   // Remove backslashes from the JSON string
      //   final jsonString = items.foundByItemPic!.replaceAll(r'\\', '');
      //
      //   // Parse the JSON string
      //   decodedList = jsonDecode(jsonString);
      //
      //   // Extract the image URLs from the decoded list
      //   imageUrls = decodedList?.map<String>((item) => item.toString()).toList();
      // }
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

  Future<void> _createFile(List<String> imagePaths, BuildContext context) async {
    if (_signatureImagePath.isNotEmpty && pickedImagePaths.isEmpty) {
      imagePaths.add(_signatureImagePath);
    } else if (_signatureImagePath.isEmpty && pickedImagePaths.isNotEmpty) {
      imagePaths.addAll(pickedImagePaths);
    } else if (_signatureImagePath.isNotEmpty && pickedImagePaths.isNotEmpty) {
      imagePaths.add(_signatureImagePath);
      imagePaths.addAll(pickedImagePaths);
    } else {
      return;
    }

    if (imagePaths.isNotEmpty) {
      fileStgVM.getMediaUpload(imagePaths, context).then((response) {
        print(" resp = $response");
        if (response!.isNotEmpty) {
          List<String> _pickedImageUrls = [];
          String? _signatureUrl;

          for (int i = 0; i < response.length; i += 2) {
            String originalName = response[i].trim();
            String url = response[i + 1].trim();
            String originalNameWithUrl = '$originalName:$url';

            if (originalName == 'signature.png') {
              _signatureUrl = originalNameWithUrl;
              signatureUrl = _signatureUrl.toString();
            } else {
              _pickedImageUrls.add(url);
              pickedImageUrls = _pickedImageUrls;
            }
          }

          print('Signature URL: $_signatureUrl');
          print('Picked Image URLs: $_pickedImageUrls');
          print('Signature URL: $signatureUrl');
          print('Picked Image URLs: $pickedImageUrls');

          if (_signatureUrl != null || _pickedImageUrls.isNotEmpty) {
            createUnclaimedItems();
          } else {
            print('Error: No signature URL or picked image URLs');
          }
        }
        else {
          throw Exception('Invalid QR code response');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    if(width < 411 || height < 707){
      fontSize = 14;

    }else {
      fontSize = 16;

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
          'Unclaimed Form',
          style: Theme.of(context).textTheme.headlineMedium
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
                         style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: Colors.white
                      // fontWeight: FontWeight.bold,
                    ), )
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
                            onPressed: _scanQRCode,
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.007,),
                        if(widget.upload)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Upload image :',
                                    style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 15, color: Colors.black
                                      // fontWeight: FontWeight.bold,
                                    ), )
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
                                        Icon(Icons.upload,color: Colors.white,size: 18,),
                                        Text(
                                          'Gallery',
                                          style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 15, color: Colors.white
                                            // fontWeight: FontWeight.bold,
                                          ), ),
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
                          Column(
                            children: [
                              if (imageUrls!= null && imageUrls!.isNotEmpty
                                  )
                                Container(

                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.20,
                                  child: Center(
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: decodedList!.length,
                                      itemBuilder: (context, index) {

                                        if (index < imageUrls!.length) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              imageUrls![index],
                                              fit: BoxFit.cover,
                                              // Add any additional properties for the image widget
                                            ),
                                          );
                                        }
                                        return Container(); // Return an empty container if index is out of range
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return SizedBox(width: 10); // Adjust the spacing between images
                                      },
                                    ),
                                  ),
                                ),

                         if (image != null && image.isNotEmpty)
                                Container(

                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.20,
                                  child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          image,
                                          fit: BoxFit.cover,
                                          // Add any additional properties for the image widget
                                        ),
                                      )



                                  ),
                                ),
                              if (items.foundByItemPic == null || items.foundByItemPic!.isEmpty)
                                Container(

                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.20,
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
                                ),
                            ],
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
                                style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: Colors.white
                                  // fontWeight: FontWeight.bold,
                                ), )
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
                            onPressed: _scanQRCode,
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
                          style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 15, color: Colors.black
                              // fontWeight: FontWeight.bold,
                            ), )
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
                        await _createFile( imagePaths,context);
                        // _uploadImage(_image!.path, _signatureImagePath);
                        // createUnclaimedItems();
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
        _collectedByController.text = _scanResult;
      });
    } on Exception catch (e) {
      print('Error: $e');
    }
  }

//   Future getImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
// if(pickedFile != null){
//
//   setState(() {
//     final imageFile =  File(pickedFile!.path);
//     pickedImagePaths = [imageFile.path];
//     _image = imageFile;
//   });
// }
//   }




  Future<void> getImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxHeight: 150,
      maxWidth: 150,
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

  void createUnclaimedItems() async{
    String? formattedDateFound;
    String? formattedDateCollected;

    // String jsonString = jsonEncode(pickedImageUrls?.join(','));
    // print(jsonString);
    String jsonString = jsonEncode(pickedImageUrls);
    print(jsonString);
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
        "found_by_item_pic": jsonString,
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
        "found_by_item_pic": jsonString,
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
