import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/eforms/EPollCategoryName.dart';
import '../../model/eforms/EPollDynamicList.dart';
import '../../model/eforms/FieldDataModel.dart';
import '../../utils/MyDateField.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/eforms/EFormsViewModel.dart';
import '../../Model/SignInModel.dart';
import '../../model/eforms/DynamicList.dart';
import '../../model/eforms/EFormCategoryName.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';

class EPollDynamicListScreen extends StatefulWidget {
  EPollDynamicListScreen({Key? key}) : super(key: key);

  @override
  State<EPollDynamicListScreen> createState() => _EPollDynamicListScreenState();
}

class _EPollDynamicListScreenState extends State<EPollDynamicListScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = EFormsViewModel();
  List<EPollCategoryItems> categoryItems = [];
  List<PropertyEpollingCategoryFieldsRest>? fieldsList = [];
  var commentContoller = TextEditingController();
  int categoryId = 0;
  int statusId = 0;
  DateTime? _selectedDateTime;

  List<TextEditingController> _controllers = [];

  List<FieldDataModel> newFieldList = [];

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

    fetchEPollCategoryNameList(userDetails.propertyId);
    fetchApprovalStatusItems('ApprovalStatus');
  }

  Future<void> fetchApprovalStatusItems(var serviceType) async {
    viewmodel.fetchApprovalStatus(serviceType).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              for (int i = 0; i < data.length; i++) {
                if (data[i].keyValue == 'Open') {
                  statusId = data[i].id!;
                  break;
                }
              }
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchEPollCategoryNameList(var propertyId) async {
    viewmodel.fetchEPollCategoryNameList(propertyId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              categoryItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage(error, context);
    });
  }

  Future<void> fetchEPollDynamicFormsList(
      var categoryId, var propertyId, var userId) async {
    viewmodel
        .fetchEPollDynamicFormList(categoryId, propertyId, userId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.propertyEpollingRest;
          if (data!.isNotEmpty) {
            setState(() {
              _controllers.clear();
              commentContoller.clear();
              //selectedRadioItem = '';

              fieldsList = data[0].propertyEpollingCategoryFieldsRest;
              selectedRadioItem = [];

              for (int i = 0; i < (fieldsList?.length ?? 0); i++) {
                selectedRadioItem.add("");
              }
            });
          } else {
            setState(() {
              fieldsList?.clear();
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
        model.id = fieldsList?[i].id;
        model.fldDatatypeId = fieldsList?[i].fieldId;
        model.fieldDispName = fieldsList?[i].fieldDispName;
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
          'e Polls',
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
                MyDropDown(
                    value: null,
                    hintText: 'Select Category Type',
                    items: categoryItems
                        .map((item) => item.epollingCategoryName)
                        .map((displayName) => DropdownMenuItem<String>(
                              value: displayName,
                              child: Text(
                                displayName!,
                                style: TextStyle(fontSize: 12),
                              ),
                            ))
                        .toList(),
                    onchanged: (value) {
                      for (int i = 0; i < categoryItems.length; i++) {
                        if (value == categoryItems[i].epollingCategoryName) {
                          categoryId = categoryItems[i].id!;
                          break;
                        }
                      }
                      fetchEPollDynamicFormsList(
                          categoryId, userDetails.propertyId, userDetails.id);
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                if (fieldsList!.isNotEmpty)
                  ListView.separated(
                      itemCount: fieldsList!.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final fieldType = fieldsList?[index].fieldKeyValue;
                        final fieldName = fieldsList?[index].fieldDispName;

                        if (fieldType == 'Text') {
                          _addController();
                          return MyTextField(
                              controller: _controllers[index],
                              hintText: fieldName,
                              preffixIcon: Icons.text_snippet,
                              labelText: fieldName,
                              textInputType: TextInputType.text);
                        } else if (fieldType == 'Date') {
                          _addController();
                          return MyDateField(
                              labelText: fieldName.toString(),
                              controller: _controllers[index],
                              preffixIcon: Icons.calendar_month,
                              onPressed: () {
                                _pickDateTime(_controllers[index]);
                              });
                        } else if (fieldType == 'Dropdown') {
                          _addController();
                          return MyDropDown(
                              value: null,
                              hintText: fieldName,
                              items: fieldsList?[index]
                                  .propertyEpollingDropdownFieldsRest
                                  ?.map((item) => item.fieldDispName)
                                  .map(
                                      (displayName) => DropdownMenuItem<String>(
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
                          var data = fieldsList?[index]
                              .propertyEpollingDropdownFieldsRest;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 8),
                                child: Text(
                                  "$fieldName ",
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
                                  return RadioListTile(
                                    title: Text(
                                      data[i].fieldDispName.toString(),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    value: data[i].fieldDispName,
                                    //groupValue: selectedRadioItem,
                                    groupValue: selectedRadioItem[index],
                                    onChanged: (value) {
                                      setState(() {
                                        setSelectedRadioItem(value!, index);
                                      });
                                    },
                                  ); /*ListTile(
                                    title: Text(
                                      data[i].fieldDispName.toString(),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    leading: Radio(
                                      value: data[i].fieldDispName,
                                      groupValue: selectedRadioItem,
                                      onChanged: (value) {
                                        setSelectedRadioItem(value!, index);
                                      },
                                    ),
                                  );*/
                                },
                              ),
                            ],
                          );
                        } else if (fieldType == 'CheckBox') {
                          _addController();
                          var data = fieldsList?[index]
                              .propertyEpollingDropdownFieldsRest;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 8),
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
                                  return CheckboxListTile(
                                    title: Text(
                                      data[i].fieldDispName.toString(),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    value: data[i].checked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        data[i].checked = value!;
                                        List<String> selectedItems = [];
                                        for (int i = 0; i < data.length; i++) {
                                          if (data[i].checked != null) {
                                            selectedItems.add(data[i]
                                                .fieldDispName
                                                .toString());
                                          }
                                        }
                                        _controllers[index].text =
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
                if (fieldsList!.isNotEmpty)
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

  //String selectedRadioItem = '';
  /*setSelectedRadioItem(String value, int index) {
    setState(() {
      selectedRadioItem = value;
      _controllers[index].text = selectedRadioItem;
    });
  }*/
  List<String> selectedRadioItem = [];

  setSelectedRadioItem(String value, int index) {
    setState(() {
      selectedRadioItem[index] = value;
      _controllers[index].text = selectedRadioItem[index];
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
    Map<String, dynamic> data = {
      "adm_module_id": fieldsList?[0].admModuleId,
      "attachment_id": "",
      "created_by": userDetails.id,
      "epollingcat_group_id": fieldsList?[0].epollingcatGroupId,
      "epolling_id": fieldsList?[0].epollingId,
      "epolling_status": statusId,
      "fied_data": jsonEncode(newFieldList),
      "hide_for_all": true,
      "property_id": userDetails.propertyId,
      "rec_status": userDetails.recStatus,
      "remark": commentContoller.text,
      "user_id": userDetails.id
    };

    viewmodel.submitEPoll(data, context).then((value) {
      if (value.data!.status == 201) {
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
