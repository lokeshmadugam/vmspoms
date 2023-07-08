import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../model/packages/PackageReceived.dart';
import '../../model/SignInModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyTextfield.dart';

class ResidentViewFormScreen extends StatefulWidget {
  var data;

  ResidentViewFormScreen({super.key, required this.data});

  @override
  State<ResidentViewFormScreen> createState() => _ResidentViewFormScreenState();
}

class _ResidentViewFormScreenState extends State<ResidentViewFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _packageCollectedByController = TextEditingController();
  final _packageCollectedOnController = TextEditingController();
  final _packageReceivedDateController = TextEditingController();
  final _remarksController = TextEditingController();
  final _blockNameController = TextEditingController();
  final _unitNoController = TextEditingController();
  final _packageTypeController = TextEditingController();
  UserDetails userDetails = UserDetails();
  File? _image;

  List<String> blockNamesList = [];
  List<String> unitNumbersList = [];

  bool _isPackageReceiptExpanded = false;
  bool _isPackageCollectionExpanded = false;
  bool _isPackageCollectionHeaderVisible = false;

  Items items = Items();

  String? blockName;
  String? unitNo;

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
      _packageTypeController.text = items.packageFrom.toString();
      _packageCollectedByController.text = items.packageCollectedBy.toString();
      _packageCollectedOnController.text = items.packageCollectedOn.toString();
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
      fontSize = 16;
    } else {
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
                  child: Text('Back',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
            ),
          ],
        ),
        title: Text('Received Details',
            style: Theme.of(context).textTheme.headlineLarge),
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
                        color: Color(0xFF3F9AE5)),
                    //color: Colors.indigo[300],
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          child: Text("Package Receipt Details",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: fontSize, color: Colors.white
                                    // fontWeight: FontWeight.bold,
                                    ),
                              )),
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
                                //width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 4),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Block Name :',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            blockName.toString(),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              //width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 4),
                                    child: Text('Unit No :'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          unitNo.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          enabled: false,
                          labelText: 'Package Received Date',
                          controller: _packageReceivedDateController,
                          onPressed: () {
                            //_pickDateTime(_packageReceivedDateController);
                          },
                        ),
                        MyTextField(
                            preffixIcon: FontAwesomeIcons.boxesPacking,
                            enabled: false,
                            controller: _packageTypeController,
                            labelText: 'Package Type',
                            textInputType: TextInputType.text),
                        MyTextField(
                            preffixIcon: Icons.sticky_note_2_sharp,
                            enabled: false,
                            controller: _remarksController,
                            labelText: 'Remarks',
                            textInputType: TextInputType.text),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Package Image :',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            //width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Image.network(
                                  items.packageImg.toString().trim()),
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
                          color: Color(0xFF386DB6)),
                      //color: Colors.indigo[300],
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            child: Text("Package Collection Details",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: fontSize, color: Colors.white
                                      // fontWeight: FontWeight.bold,
                                      ),
                                )),
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
                            enabled: false,
                            controller: _packageCollectedByController,
                            suffixIcon: Icons.qr_code_2_outlined,
                            labelText: 'Package Collected by',
                            textInputType: TextInputType.text),
                        MyDateField(
                          preffixIcon: Icons.calendar_today,
                          enabled: false,
                          labelText: 'Package Collected on',
                          controller: _packageCollectedOnController,
                          onPressed: () {
                            //_pickDateTime(_packageCollectedOnController);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Sign Here :',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 15, color: Colors.black
                                      // fontWeight: FontWeight.bold,
                                      ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Image.network(items.packageCollectionAckImg
                                  .toString()
                                  .trim()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
