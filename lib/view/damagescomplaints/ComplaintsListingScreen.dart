import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/respose/Status.dart';
import '../../main.dart';
import '../../model/damagescomplaints/Complaints.dart';
import '../../utils/CardData.dart';
import '../../utils/Popup.dart';
import '../../view/damagescomplaints/CreateComplaintFormScreen.dart';
import '../../view/damagescomplaints/EditComplaintFormScreen.dart';
import '../../viewmodel/damagescomplaints/ComplaintsViewModel.dart';
import '../../model/SignInModel.dart';
import '../../model/EmergencyService.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';

class ComplaintsListingScreen extends StatefulWidget {
  var data;
  ComplaintsListingScreen({Key? key,required this.data}) : super(key: key);

  @override
  State<ComplaintsListingScreen> createState() =>
      _ComplaintsListingScreenState();
}

class _ComplaintsListingScreenState extends State<ComplaintsListingScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = ComplaintsViewModel();
  List<ComplaintItems> _complaintItemsList = [];
  List<ComplaintItems>? _items = [];
  final _searchController = TextEditingController();
  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  bool isprint = false;
  bool isdownload = false;
  @override
  void initState() {
    // TODO: implement initState
    if(DeviceUtil.isTablet) {
      SystemChrome.setPreferredOrientations([
        // DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        // DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ]);
    }
    super.initState();
    _getUserDetails();
    permissions = widget.data;
    actionPermissions();
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;

    fetchComplaintsList(userDetails.propertyId, '');
  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "Complaints") && (item.action != null && item.action!.isNotEmpty)){
          var actions = item.action ?? [];
          for (var act in actions){
            if( act.actionName == "Add" || act.actionId == 1){
              iscreate = true;
              print("addbutton = $iscreate");

            }
            else if ( act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");

            }
            else if ( act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");

            }
            else if ( act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");

            }
            else if ( act.actionName == "Print" || act.actionId == 5) {
              isprint = true;
              print("print = $isprint");

            }
            else if ( act.actionName == "Download files" || act.actionId == 6) {
              isdownload = true;
              print("download = $isdownload");

            }
            else if ( act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");

            }
          }
        }
      }
    });
  }
  Future<void> fetchComplaintsList(var propertyId, var userId) async {
    viewmodel
        .fetchComplaintsList(propertyId, userId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _complaintItemsList = data;
              if (_searchController.text.toString().isEmpty) {
                _items = data;
              }
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
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
            'Damages & Complaints',
            style: Theme.of(context).textTheme.headlineLarge
            // TextStyle(
            //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          child: MyTextField(
                            hintText: 'Search',
                            controller: _searchController,
                            onChanged: (value) {
                              _runSearch(value);
                            },
                            textInputType: TextInputType.text,
                            suffixIcon: Icons.search,
                          )),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    if(iscreate)
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF036CB2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateComplaintFormScreen(upload: isupload,)));
                        },
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                  ],
                ),
          ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _complaintItemsList.length,
            itemBuilder: (context, index) {
              var item = _complaintItemsList[index];

                return Dismissible(
                  key: Key(item.id.toString()),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) async {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return Dialog(
                              shape:
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius
                                      .circular(
                                      10)),
                              elevation: 16,
                              child: Popup(title: 'Complaints',
                                message: ' Are you sure you want to delete this id?',
                                negativeButtonText: "No",
                                onNegativePressed: () {
                                  Navigator.pop(context);
                                },
                                positiveButtonText: "Yes",
                                onPositivePressed: () async {
    if(isdelete) {
      final response = await viewmodel
          .deletetComplaintDetails(
          item.id, context);

      if (response.data!.status ==
          200) {
        // Update local state of widget
        setState(() {
          _complaintItemsList.removeAt(index);
        });
      } else if (response.data!.result ==
          Status.error) {
        // Show error message to user
        Utils.flushBarErrorMessage(
            response.message!, context);
      }

    }else{
      Utils.flushBarErrorMessage("Unable to delete the  Details", context);
    }
                                },)
                          );
                        }
                    );
                  },
                  child: buildInkWell(context, item),
                );

            },

            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                // height: MediaQuery.of(context).size.height * 0.01,
              );
            },
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildInkWell(BuildContext context, ComplaintItems item) {
    return InkWell(
              child: Card(
                color: Colors.grey.shade100,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ContainerValue(
                      text: "Complaint Type",
                      value: ": ${item.complaintTypeName ?? ""}",
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                    ),
                    ContainerValue(
                      text: "Description",
                      value: ": ${item.complaintDescription ?? ""}",
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                    ),
                    ContainerValue(
                      text: "Complaint Status",
                      value: ": ${item.complaintStatusName ?? ''}",
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                  ],
                ),
              ),
              onTap: () {
                if(isview||isupdate)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditComplaintFormScreen(data: item, update: isupdate,)),
                );
              },
            );
  }

  void _runSearch(String searchTerm) {
    List<ComplaintItems> results = [];
    for (var item in _items!) {
      if (item.complaintTypeName!
              .toLowerCase()
              .contains(searchTerm.toLowerCase()) ||
          item.complaintStatusName!
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _complaintItemsList = results;
    });
  }


}
