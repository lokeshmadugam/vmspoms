import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../model/lostfound/LostItems.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/MyTextfield.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/SignInModel.dart';
import '../../utils/MyDateField.dart';
import 'package:path_provider/path_provider.dart';

import '../../viewmodel/FileStorage.dart';
import '../../viewmodel/lostfound/EditLostDetailsFormScreenViewModel.dart';

class EditLostDetailsFormScreen extends StatefulWidget {
  var data;
bool upload;
  EditLostDetailsFormScreen({super.key, required this.data,required this.upload});

  @override
  State<EditLostDetailsFormScreen> createState() =>
      _EditLostDetailsFormScreenState();
}

class _EditLostDetailsFormScreenState extends State<EditLostDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateLostController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lostLocationController = TextEditingController();

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
  bool _isLostDetailsExpanded = false;
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

  List<dynamic>? decodedList;
  List<String>? imageUrls;
  List<dynamic>? lostitemdecodedList;
  List<String>? lostitemimageUrls;
  var imageUrl;
  @override
  void initState() {
    super.initState();
    items = widget.data;
    if (items.foundBy == 0 || items.foundBy == null) {
      _isLostDetailsExpanded = false;
      _isFoundDetailsExpanded = true;
      _isCollectionDetailsHeaderVisible = false;
      _isCollectionDetailsExpanded = false;
    } else {
      _isLostDetailsExpanded = false;
      _isFoundDetailsExpanded = false;
      _isCollectionDetailsHeaderVisible = true;
      _isCollectionDetailsExpanded = true;

      _foundByController.text = items.foundBy.toString();
      _dateFoundController.text = DateFormat('yyyy-MM-dd hh:mm a').format(
          DateTime.parse(items.foundDateTime.toString() ?? ''));
      _foundItemNameController.text = items.foundItemName.toString();
      _foundDescriptionController.text = items.foundDescription.toString();
      _foundLostLocationController.text = items.foundLocation.toString();
    }

    if (items.collectedBy == 0 || items.collectedBy == null) {

    } else {
      _collectedByController.text = items.collectedBy.toString();
      _collectedDateController.text = DateFormat('yyyy-MM-dd hh:mm a').format(
          DateTime.parse(items.collectedDateTime.toString() ?? ''));
      _remarksController.text = items.collectedRemarks.toString();
    }
    if (items.foundByItemPic.toString().isNotEmpty && items.foundByItemPic is List<String>){
      decodedList = jsonDecode(items.foundByItemPic ?? "[]");

      imageUrls = decodedList?.map((item) => item.toString()).toList();
    }
    if (items.lostItemImgUrl.toString().isNotEmpty && items.lostItemImgUrl is List<String>){
      lostitemdecodedList = jsonDecode(items.foundByItemPic ?? "[]");

      lostitemimageUrls = decodedList?.map((item) => item.toString()).toList();
    }
    _dateLostController.text = DateFormat('yyyy-MM-dd hh:mm a').format(
        DateTime.parse(items.lostDateTime.toString() ?? ''));
    _itemNameController.text = items.lostItemName.toString();
    _descriptionController.text = items.lostDescription.toString();
    _lostLocationController.text = items.lostLocation.toString();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel
        .fromJson(jsonData)
        .userDetails!;
    token = SignInModel
        .fromJson(jsonData)
        .accessToken!;
  }

  Future<void> _createFile(List<String> imagePaths,
      BuildContext context) async {
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
            createLostItems();
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
      print("SmallSize = $fontSize");
    }else {
      fontSize = 16;
      print("BigSize = $fontSize");
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
          'Lost Details Form',
            style: Theme.of(context).textTheme.headlineLarge
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLostDetailsExpanded = !_isLostDetailsExpanded;
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
                            "Lost Details",
                            style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: Colors.white
                              // fontWeight: FontWeight.bold,
                            ), )
                          ),
                        ),
                        Spacer(),
                        Icon(
                          _isLostDetailsExpanded
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
                  visible: _isLostDetailsExpanded,
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          labelText: 'Date Lost',
                          controller: _dateLostController,
                          onPressed: () {
                            _pickDateTime(_dateLostController);
                          },
                        ),
                        MyTextField(
                            preffixIcon: Icons.list_outlined,
                            controller: _itemNameController,
                            labelText: 'Item Name',
                            textInputType: TextInputType.text),
                        MyTextField(
                            preffixIcon: Icons.notes,
                            controller: _descriptionController,
                            labelText: 'Description',
                            textInputType: TextInputType.text),
                        MyTextField(
                            preffixIcon: Icons.location_on_outlined,
                            controller: _lostLocationController,
                            labelText: 'Lost Location',
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.007,),
                        if(widget.upload)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Lost item pictute :',
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
                                      Icon(Icons.upload, color: Colors.white,
                                        size: 18,),
                                      Text(
                                        'Gallery',
                                          style: GoogleFonts.roboto(textStyle:TextStyle(fontSize:15, color: Colors.white
                                            // fontWeight: FontWeight.bold,
                                          ), )
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
                        // Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: Container(
                        //     //width: MediaQuery.of(context).size.width,
                        //     height: MediaQuery
                        //         .of(context)
                        //         .size
                        //         .height * 0.20,
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: Colors.grey),
                        //         borderRadius: BorderRadius.circular(5)),
                        //     child: Center(
                        //       child: _image == null
                        //           ? Text('No Image Selected')
                        //           : Image.file(_image!),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child:
                          Column(
                            children: [
                              if (items.lostItemImgUrl != null && items.lostItemImgUrl!.isNotEmpty && items.lostItemImgUrl is List<String> )
                                Container(

                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.20,
                                  child: Center(
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: lostitemdecodedList!.length,
                                      itemBuilder: (context, index) {

                                        if (index < lostitemimageUrls!.length) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              lostitemimageUrls![index],
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
                              if (items.lostItemImgUrl != null && items.lostItemImgUrl!.isNotEmpty && items.lostItemImgUrl is String)
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
                                          items.lostItemImgUrl.toString().trim(),
                                          fit: BoxFit.cover,
                                          // Add any additional properties for the image widget
                                        ),
                                      )



                                  ),
                                ),
                              if (items.lostItemImgUrl == null || items.lostItemImgUrl!.isEmpty)
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01,
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
                        color: Color(0xFF386DB6)),

                    //color: Colors.indigo[300],Color(0xFF0F2DA4)
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
                            preffixIcon: Icons.countertops,
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
                            preffixIcon: Icons.notes,
                            controller: _foundDescriptionController,
                            labelText: 'Description',
                            textInputType: TextInputType.text),
                        MyTextField(
                            preffixIcon: Icons.location_on,
                            controller: _foundLostLocationController,
                            labelText: 'Found Location',
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.007,),
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
                                ), ),
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
                                      Icon(Icons.upload, color: Colors.white,
                                        size: 18,),
                                      Text(
                                        'Gallery',
                                          style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 15, color: Colors.white
                                            // fontWeight: FontWeight.bold,
                                          ), )
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
                              if (items.foundByItemPic != null && items.foundByItemPic!.isNotEmpty && items.foundByItemPic is List<String> )
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
                              if (items.foundByItemPic != null && items.foundByItemPic!.isNotEmpty && items.foundByItemPic is String)
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
                                            items.foundByItemPic.toString().trim(),
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


                          // Column(
                          //   children: [
                          //     if(items.foundByItemPic != null || items.foundByItemPic!.isNotEmpty)
                          //       Padding(
                          //         padding: const EdgeInsets.all(12.0),
                          //
                          //         child:
                          //         Container(
                          //           //width: MediaQuery.of(context).size.width,
                          //           height: MediaQuery.of(context).size.height * 0.20,
                          //           decoration: BoxDecoration(
                          //             border: Border.all(color: Colors.grey),
                          //             borderRadius: BorderRadius.circular(5),
                          //           ),
                          //           child: Center(
                          //             child: ListView.builder(
                          //               scrollDirection: Axis.horizontal,
                          //               // itemCount: image.length,
                          //               itemBuilder: (context, index) {
                          //                 List<dynamic> decodedList = jsonDecode(items.foundByItemPic ?? "[]");
                          //                 List<String> imageUrls = decodedList.map((item) => item.toString()).toList();
                          //                 if (index < imageUrls.length) {
                          //                   return Container(
                          //                     height: 100,
                          //                     child: Image.network(
                          //                       imageUrls[index],
                          //                       fit: BoxFit.cover,
                          //                       // Add any additional properties for the image widget
                          //                     ),
                          //                   );
                          //                 }
                          //                 return Container(); // Return an empty container if index is out of range
                          //               },
                          //             ),
                          //           ),
                          //         ),
                          //
                          //
                          //
                          //       ),
                          //     if(items.foundByItemPic!.isEmpty)
                          //     Container(
                          //       height: MediaQuery.of(context).size.height * 0.20,
                          //       decoration: BoxDecoration(
                          //         border: Border.all(color: Colors.grey),
                          //         borderRadius: BorderRadius.circular(5),
                          //       ),
                          //       child: Center(
                          //         child: pickedImagePaths.isEmpty
                          //             ? Text('No Image Selected')
                          //             : ListView.builder(
                          //           scrollDirection: Axis.horizontal,
                          //           itemCount: pickedImagePaths.length,
                          //           itemBuilder: (context, index) {
                          //             return Image.file(File(pickedImagePaths[index]));
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )







                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.01,
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
                          color: Color(0xFF74941E)),
                      //color: Colors.indigo[300],
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Collection Details",
                                style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 18, color: Colors.white
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
                            preffixIcon: Icons.countertops_sharp,
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sign Here :',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.15,
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.70,
                  child: PositiveButton(
                      text: 'Submit',
                      onPressed: () {
                        _createFile( imagePaths,context);
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

  void createLostItems() async {
    String? formattedDateFound;
    String? formattedDateCollected;
    String jsonString = jsonEncode(pickedImageUrls);
    print(jsonString);
    DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a')
        .parse(_dateLostController.text.toString());
    String formattedDateLost =
    DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);

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


    if (items.foundBy == 0 || items.foundBy == null) {
      Map<String, dynamic> data = {
        "lost_date_time": formattedDateLost,
        "lost_description": _descriptionController.text.toString(),
        "lost_item_img_url": jsonString,
        "lost_item_name": _itemNameController.text.toString(),
        "lost_location": _lostLocationController.text.toString(),
        "lost_report_user_id": userDetails.id,
        "lost_unit_no": userDetails.unitNumber,
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
          .createUnclaimedData(data, context);
    } else {
      Map<String, dynamic> data = {
        "lost_date_time": formattedDateLost,
        "lost_description": _descriptionController.text.toString(),
        "lost_item_img_url": jsonString,
        "lost_item_name": _itemNameController.text.toString(),
        "lost_location": _lostLocationController.text.toString(),
        "lost_report_user_id": userDetails.id,
        "lost_unit_no": userDetails.unitNumber,
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
        "received_by_sign": signatureUrl,
      };

      Provider.of<EditLostDetailsFormScreenViewModel>(context, listen: false)
          .updateEditLostFoundDetails(items.id, data, context);
    }
  }
}
  // void _uploadImage(var imagePath, String signatureImagePath) {
  //   String? formattedDateFound;
  //   String? formattedDateCollected;
  //
  //   DateTime dateTime = DateFormat('M/d/yyyy h:mm a')
  //       .parse(_dateLostController.text.toString());
  //   String formattedDateLost =
  //       DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
  //
  //   if(_dateFoundController.text.isNotEmpty){
  //     DateTime dateTime1 = DateFormat('M/d/yyyy h:mm a')
  //         .parse(_dateFoundController.text.toString());
  //     formattedDateFound = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime1);
  //   }
  //
  //
  //   if(_collectedDateController.text.isNotEmpty){
  //     DateTime dateTime2 = DateFormat('M/d/yyyy h:mm a')
  //         .parse(_collectedDateController.text.toString());
  //     formattedDateCollected =
  //         DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime2);
  //   }
  //
  //
  //   if (items.foundBy == 0 || items.foundBy == null) {
  //     Map<String, dynamic> data = {
  //       "lost_date_time": formattedDateLost,
  //       "lost_description": _descriptionController.text.toString(),
  //       "lost_item_img_url": "",
  //       "lost_item_name": _itemNameController.text.toString(),
  //       "lost_location": _lostLocationController.text.toString(),
  //       "lost_report_user_id": userDetails.id,
  //       "lost_unit_no": userDetails.unitNumber,
  //       "found_by": userDetails.id,
  //       "found_by_item_pic": "",
  //       "found_date_time": formattedDateFound,
  //       "found_description": _foundDescriptionController.text.toString(),
  //       "found_item_name": _foundItemNameController.text.toString(),
  //       "found_location": _foundLostLocationController.text.toString(),
  //       "found_unit_no": userDetails.unitNumber,
  //       "property_id": userDetails.propertyId,
  //       "rec_status": userDetails.recStatus,
  //       "updated_by": userDetails.id
  //     };
  //
  //     Provider.of<EditLostDetailsFormScreenViewModel>(context, listen: false)
  //         .getMediaUpload(imagePath, data, context, items.id);
  //   } else {
  //
  //     Map<String, dynamic> data = {
  //       "lost_date_time": formattedDateLost,
  //       "lost_description": _descriptionController.text.toString(),
  //       "lost_item_img_url": "",
  //       "lost_item_name": _itemNameController.text.toString(),
  //       "lost_location": _lostLocationController.text.toString(),
  //       "lost_report_user_id": userDetails.id,
  //       "lost_unit_no": userDetails.unitNumber,
  //       "found_by": userDetails.id,
  //       "found_by_item_pic": "",
  //       "found_date_time": formattedDateFound,
  //       "found_description": _foundDescriptionController.text.toString(),
  //       "found_item_name": _foundItemNameController.text.toString(),
  //       "found_location": _foundLostLocationController.text.toString(),
  //       "found_unit_no": userDetails.unitNumber,
  //       "property_id": userDetails.propertyId,
  //       "rec_status": userDetails.recStatus,
  //       "updated_by": userDetails.id,
  //       "collected_by": _collectedByController.text.toString(),
  //       "collected_date_time": formattedDateCollected,
  //       "collected_remarks": _remarksController.text.toString(),
  //       "received_by_sign": "",
  //     };
  //
  //     Provider.of<EditLostDetailsFormScreenViewModel>(context, listen: false)
  //         .getMediaUpload(imagePath, data, context, items.id);
  //
  //   }
  //
  // }

// Future<void> _createFile1(BuildContext context, List<String> imagePaths) async {
//   if (_signatureImagePath.isNotEmpty && pickedImagePaths.isEmpty) {
//     imagePaths.add(_signatureImagePath);
//   }  else if (_signatureImagePath.isEmpty && pickedImagePaths.isNotEmpty) {
//     imagePaths.addAll(pickedImagePaths);
//
//   } else if (_signatureImagePath.isNotEmpty && pickedImagePaths.isNotEmpty) {
//     imagePaths.add(_signatureImagePath);
//     imagePaths.addAll(pickedImagePaths);
//     // .map((file) => file.path)
//   } else {
//     return;
//   }
//
//   try {
//     if (imagePaths.isNotEmpty) {
//       final qrcode = await fileStgVM.getMediaUpload(imagePaths, context);
//       if (qrcode!.isNotEmpty) {
//         List<String> _pickedImageUrls = []; // Initialize the list here
//         String? _signatureUrl;
//
//         for (int i = 0; i < qrcode!.length; i += 2) {
//           String originalName = qrcode![i].trim();
//           String url = qrcode![i + 1].trim();
//           String originalNameWithUrl = '$originalName:$url';
//
//           if (originalName != null) {
//             if (originalName == 'signature.png') {
//               _signatureUrl = originalNameWithUrl;
//               signatureUrl = _signatureUrl.toString();
//             } else {
//               _pickedImageUrls?.add(jsonDecode(url.toString().trim()));
//               pickedImageUrls = _pickedImageUrls;
//             }
//           }
//         }
//
//         print('Signature URL: $_signatureUrl');
//         print('Picked Image URLs: $_pickedImageUrls');
//         print('Signature URL: $signatureUrl');
//         print('Picked Image URLs: $pickedImageUrls');
//         if ((_signatureUrl != null || _pickedImageUrls != null ) ||(_signatureUrl != null && _pickedImageUrls != null)) {
//           createLostItems();
//         }else{
//           'error';
//         }
//       } else {
//         throw Exception('Invalid QR code response');
//       }
//
//
//
//     }
//
//   }catch (e) {
//     print('Error occurred: $e');
//     throw Exception('Failed to generate QR code');
//   }
// }
