import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/MyDateField.dart';
import '../../utils/PositiveButton.dart';
import '../../utils/MyTextfield.dart';
import '../../viewmodel/lostfound/LostDetailsFormScreenViewModel.dart';
import '../../model/SignInModel.dart';

class LostDetailsFormScreen extends StatefulWidget {
  var data;
bool upload;
  LostDetailsFormScreen({super.key, required this.data,required this.upload});

  @override
  State<LostDetailsFormScreen> createState() => _LostDetailsFormScreenState();
}

class _LostDetailsFormScreenState extends State<LostDetailsFormScreen> {

  final _formKey = GlobalKey<FormState>();
  UserDetails userDetails = UserDetails();

  DateTime? _selectedDateTime;
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lostDateController = TextEditingController();
  final _lostLocationController = TextEditingController();

  File? _image;

  @override
  void initState() {
    super.initState();
    if(widget.data == null){

    } else {

    }
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
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
                    style: Theme.of(context).textTheme.headlineMedium
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Lost / Damaged Items',
          style: Theme.of(context).textTheme.headlineLarge
        ),
        centerTitle: true,
        backgroundColor:  Color(0xFF036CB2),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyTextField(
                  preffixIcon: Icons.list_outlined,
                    controller: _itemNameController,
                    labelText: 'Item Name',
                    textInputType: TextInputType.text),
                MyTextField(
                    preffixIcon: Icons.note,
                    controller: _descriptionController,
                    labelText: 'Description',
                    textInputType: TextInputType.number),
                MyDateField(
                  preffixIcon: Icons.calendar_today,
                  labelText: 'Lost Date',
                  controller: _lostDateController,
                  onPressed: () {
                    _pickDateTime(_lostDateController);
                  },
                ),
                MyTextField(
                    preffixIcon: Icons.location_on_outlined,
                    controller: _lostLocationController,
                    labelText: 'Lost Location',
                    textInputType: TextInputType.number),
                SizedBox(height: MediaQuery.of(context).size.height * 0.007,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Lost item picture :',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    if(widget.upload)
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
                if(widget.upload)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    //width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: _image == null
                          ? Text('No image selected')
                          : Image.file(_image!),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.70,
                  child: PositiveButton(
                      text: 'Submit',
                      onPressed: () {

                        DateTime dateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(_lostDateController.text.toString());
                        String formattedDateTime = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);

                        Map<String, dynamic> data = {
                          "created_by": userDetails.id,
                          "lost_date_time": formattedDateTime,
                          "lost_description": _descriptionController.text.toString(),
                          "lost_item_img_url": "",
                          "lost_item_name": _itemNameController.text.toString(),
                          "lost_location": _lostLocationController.text.toString(),
                          "lost_report_user_id": userDetails.id,
                          "lost_unit_no": userDetails.unitNumber,
                          "property_id": userDetails.propertyId,
                          "rec_status": userDetails.recStatus,
                        };


                        Provider.of<LostDetailsFormScreenViewModel>(context,
                            listen: false)
                            .getMediaUpload(_image!.path, data, context);

                        /*if(widget.data == null){
                          Provider.of<PackageExpectedFormScreenViewModel>(context,
                              listen: false)
                              .createExpectedPackage(data, context);
                        } else {
                          Provider.of<PackageExpectedFormScreenViewModel>(context,
                              listen: false)
                              .updateExpectedPackage(data, items.id, context);
                        }*/

                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
          _selectedDateTime = DateTime(selected.year, selected.month, selected.day, selectedTime.hour, selectedTime.minute);
          controller.text = DateFormat('yyyy-MM-dd hh:mm a').format(_selectedDateTime!);
        });
      }
    }
  }

  Future getImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

}
