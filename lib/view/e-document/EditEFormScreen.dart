import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/eforms/EFormUserData.dart';
import '../../model/eforms/FieldDataModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/eforms/EFormsViewModel.dart';
import '../../Model/SignInModel.dart';
import '../../model/ServiceType.dart';
import '../../model/eforms/DynamicList.dart';
import '../../model/eforms/EFormCategoryName.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';

class EditEFormScreen extends StatefulWidget {
  var data;

  EditEFormScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<EditEFormScreen> createState() => _EditEFormScreenState();
}

class _EditEFormScreenState extends State<EditEFormScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = EFormsViewModel();
  List<PropertyEformsCategoryFieldsRest> fieldsList = [];
  var commentContoller = TextEditingController();
  int statusId = 0;
  DateTime? _selectedDateTime;

  UserDataItems items = UserDataItems();
  String headerName = '';

  List<TextEditingController> _controllers = [];

  List<FieldDataModel> newFieldList = [];
  List<FieldDataModel> fieldListWithData = [];
  List<ServiceItems> statusItems = [];
  List<Remarks> remarksList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    if (widget.data != null) {
      items = widget.data;
    }

    List<dynamic> fieldData = jsonDecode(items.fiedData.toString());
    fieldListWithData =
        fieldData.map((json) => FieldDataModel.fromJson(json)).toList();

    setState(() {
      headerName = items.eformName.toString();
    });

    remarksList = items.remarks!;

    fetchDynamicFormsList(items.eformcatGroupId, userDetails.propertyId);
    fetchApprovalStatusItems('ApprovalStatus');
  }

  Future<void> fetchApprovalStatusItems(var serviceType) async {
    viewmodel.fetchApprovalStatus(serviceType).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              statusItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchDynamicFormsList(var categoryId, var propertyId) async {
    viewmodel.fetchDynamicFormList(categoryId, propertyId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.propertyEformsRest;
          if (data!.isNotEmpty) {
            setState(() {
              fieldsList = data[0].propertyEformsCategoryFieldsRest!;

              // selectedRadioItem = [];
              // for (int i = 0; i < (fieldsList?.length ?? 0); i++) {
              //   selectedRadioItem.add("");
              // }
            });
          } else {
            setState(() {
              fieldsList.clear();
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage(error, context);
    });
  }

  void _addController() {
    // add a new controller to the list
    TextEditingController controller = TextEditingController();
    _controllers.add(controller);
  }

  void _getAllDataFromController() {
    newFieldList.clear();

    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].value.text.isNotEmpty) {
        FieldDataModel model = FieldDataModel();
        model.id = fieldsList[i].id;
        model.fldDatatypeId = fieldsList[i].fieldId;
        model.fieldDispName = fieldsList[i].fieldDispName;
        model.fldValue = _controllers[i].text;
        newFieldList.add(model);
      }
    }
    submitData();
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
          headerName,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.separated(
                    itemCount: fieldsList.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final fieldType = fieldsList[index].fieldKeyValue;
                      final fieldName = fieldsList[index].fieldDispName;

                      if (fieldType == 'Text') {
                        _addController();
                        _controllers[index].text =
                            fieldListWithData[index].fldValue!;
                        return MyTextField(
                            controller: _controllers[index],
                            hintText: fieldName,
                            preffixIcon: Icons.text_snippet,
                            labelText: fieldName,
                            textInputType: TextInputType.text);
                      } else if (fieldType == 'Date') {
                        _addController();
                        _controllers[index].text =
                            fieldListWithData[index].fldValue!;
                        return MyDateField(
                            labelText: fieldName.toString(),
                            controller: _controllers[index],
                            preffixIcon: Icons.calendar_month,
                            onPressed: () {
                              _pickDateTime(_controllers[index]);
                            });
                      } else if (fieldType == 'Dropdown') {
                        _addController();
                        _controllers[index].text =
                            fieldListWithData[index].fldValue!;
                        return MyDropDown(
                            value: _controllers[index].text,
                            hintText: fieldName,
                            items: fieldsList[index]
                                .propertyEformsDropdownFieldsRest
                                ?.map((item) => item.fieldDispName)
                                .map((displayName) => DropdownMenuItem<String>(
                                      value: displayName,
                                      child: Text(
                                        displayName!,
                                      ),
                                    ))
                                .toList(),
                            onchanged: (value) {
                              _controllers[index].text = value;
                            });
                      } else if (fieldType == 'RadioButton') {
                        _addController();
                        //selectedRadioItem[index] = fieldListWithData[index].fldValue!;
                        var data =
                            fieldsList[index].propertyEformsDropdownFieldsRest;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 8),
                              child: Text(
                                "$fieldName :",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            GridView.builder(
                              itemCount: data!.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, childAspectRatio: 2),
                              itemBuilder: (context, i) {
                                return ListTile(
                                  title: Text(
                                    data[i].fieldDispName.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  leading: Radio(
                                    value: data[i].fieldDispName,
                                    groupValue:
                                        (fieldListWithData[index].fldValue ??
                                            ""),
                                    //selectedRadioItem[index],
                                    onChanged: (value) {
                                      setState(() {
                                        setSelectedRadioItem(value!, index);
                                      });
                                      //setSelectedRadioItem(value!, index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else if (fieldType == 'CheckBox') {
                        _addController();
                        _controllers[index].text =
                            fieldListWithData[index].fldValue!;
                        var data =
                            fieldsList[index].propertyEformsDropdownFieldsRest;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 8),
                              child: Text(
                                "$fieldName :",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            GridView.builder(
                              itemCount: data!.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 2.5),
                              itemBuilder: (context, i) {
                                List<String> words =
                                    _controllers[index].text.split(",");

                                for (int j = 0; j < words.length; j++) {
                                  if (words[j] == data[i].fieldDispName) {
                                    data[i].checked = true;
                                  }
                                }

                                return CheckboxListTile(
                                  title: Text(
                                    data[i].fieldDispName.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: data[i].checked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      data[i].checked = value;
                                      List<String> selectedItems = [];
                                      for (int i = 0; i < data.length; i++) {
                                        if (data[i].checked != null &&
                                            data[i].checked!) {
                                          selectedItems.add(
                                              data[i].fieldDispName.toString());
                                        }
                                      }
                                      _controllers[index].text =
                                          selectedItems.join(',');
                                      fieldListWithData[index].fldValue =
                                          selectedItems.join(',');
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      } else if (fieldType == 'TextEditor') {
                        _addController();
                        _controllers[index].text =
                            fieldListWithData[index].fldValue!;
                        return MyTextField(
                            controller: _controllers[index],
                            hintText: fieldName,
                            preffixIcon: Icons.featured_play_list_outlined,
                            maxLines: 3,
                            labelText: fieldName,
                            textInputType: TextInputType.multiline);
                      }

                      return SizedBox();
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                          //height: MediaQuery.of(context).size.height * 0.01,
                          );
                    }),
                MyDropDown(
                    value: null,
                    hintText: 'Select Status',
                    labelText: 'Status',
                    items: statusItems
                        .map((item) => item.keyValue)
                        .map((displayName) => DropdownMenuItem<String>(
                              value: displayName,
                              child: Text(
                                displayName!,
                                style: TextStyle(fontSize: 12),
                              ),
                            ))
                        .toList(),
                    onchanged: (value) {
                      for (int i = 0; i < statusItems.length; i++) {
                        if (value == statusItems[i].keyValue) {
                          statusId = statusItems[i].id!;
                          break;
                        }
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Comments Section :',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListView.separated(
                          itemCount: remarksList.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${remarksList[index].userName} - ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(remarksList[index].createdOn.toString()))}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      remarksList[index].comment.toString(),
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.justify,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            );
                          }),
                    ),
                  ),
                ),
                MyTextField(
                    controller: commentContoller,
                    hintText: 'Enter your comment',
                    preffixIcon: Icons.comment,
                    maxLines: 3,
                    labelText: 'Comment',
                    textInputType: TextInputType.multiline),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.70,
                      child: PositiveButton(
                          text: 'Submit',
                          onPressed: () {
                            _getAllDataFromController();
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // List<String> selectedRadioItem = [];

  setSelectedRadioItem(String value, int index) {
    setState(() {
      fieldListWithData[index].fldValue = value;
      _controllers[index].text = value;
      //selectedRadioItem[index] = value;
      //_controllers[index].text = selectedRadioItem[index];
      // selectedRadioItem = value;
      // _controllers[index].text = selectedRadioItem;
    });
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    setState(() {
      _selectedDateTime =
          DateTime(selected!.year, selected.month, selected.day);
      controller.text = DateFormat('yyyy-MM-dd').format(_selectedDateTime!);
    });
  }

  void submitData() {
    int? approveReviewBy = 0;

    if (userDetails.appUsageTypeName.toString().trim() ==
        'VMS Management modules') {
      approveReviewBy = userDetails.id;
    } else {
      approveReviewBy = 0;
    }

    Map<String, dynamic> data = {
      "adm_module_id": fieldsList[0].admModuleId,
      "approved_by": items.approvedBy,
      "approved_on": items.approvedOn,
      "attachment_id": "",
      "eformcat_group_id": fieldsList[0].eformcatGroupId,
      "eforms_id": fieldsList[0].eformsId,
      "eforms_status": statusId,
      "fied_data": jsonEncode(newFieldList),
      "hide_for_all": true,
      "property_id": userDetails.propertyId,
      "rec_status": userDetails.recStatus,
      "remark": "",
      "remarks": [
        {
          "approved_review_by": approveReviewBy,
          "comment": commentContoller.text,
          "created_by": userDetails.id,
          "eform_id": fieldsList[0].eformsId,
          "eform_userdata_id": items.id,
          "property_id": userDetails.propertyId,
          "rec_status": userDetails.recStatus,
          "unit_no": userDetails.unitNumber,
          "user_id": userDetails.id
        }
      ],
      "updated_by": userDetails.id,
      "user_id": userDetails.id
    };

    viewmodel.updateEForm(items.id, data, context).then((value) {
      if (value.data!.status == 200) {
        print('msg = ${value.data!.mobMessage}');
        Navigator.pop(context);
        Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
      } else {
        Utils.flushBarErrorMessage(" Update failed".toString(), context);
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    });
  }
}
