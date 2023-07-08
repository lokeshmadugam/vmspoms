import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/utils/CardData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/NegativeButton.dart';
import '../../view/greylist/GreyListFormScreen.dart';
import '../../viewmodel/greylist/GreyListingsScreenViewModel.dart';
import '../../model/SignInModel.dart';
import '../../model/greylist/GreyList.dart';
import '../../utils/MyTextField.dart';
import '../../utils/PositiveButton.dart';

class GreyListingsScreen extends StatefulWidget {
  var data;

  GreyListingsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<GreyListingsScreen> createState() => _GreyListingsScreenState();
}

class _GreyListingsScreenState extends State<GreyListingsScreen> {
  UserDetails userDetails = UserDetails();
  var token;

  List<Items>? _items = [];
  List<Items>? _searchResults = [];
  final _searchController = TextEditingController();
  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    permissions = widget.data;
    actionPermissions();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    token = SignInModel.fromJson(jsonData).accessToken!;

    Provider.of<GreyListingsScreenViewModel>(context, listen: false)
        .fetchGreyListings(userDetails.propertyId);
  }

  void actionPermissions() async {
    setState(() {
      for (var item in permissions) {
        if ((item.moduleDisplayNameMobile == "Grey List") &&
            (item.action != null && item.action!.isNotEmpty)) {
          var actions = item.action ?? [];
          for (var act in actions) {
            if (act.actionName == "Add" || act.actionId == 1) {
              iscreate = true;
              print("addbutton = $iscreate");
            } else if (act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");
            } else if (act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");
            } else if (act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");
            } else if (act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");
            }
          }
        }
      }
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
                    child: Text('Back',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ),
              ),
            ],
          ),
          title: Text('Grey List',
              style: Theme.of(context).textTheme.headlineLarge
              // TextStyle(
              //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2)),
      body: SingleChildScrollView(
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
                  // InkWell(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Color(0xFF036CB2),
                  //         borderRadius: BorderRadius.circular(5)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(4.0),
                  //       child: Icon(
                  //         Icons.add,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => GreyListFormScreen(
                  //                   data: null,
                  //                 )));
                  //   },
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Consumer<GreyListingsScreenViewModel>(
                  builder: (context, model, child) {
                if (model.greyList.data != null) {
                  //var data = model.packageReceipt.data!.result!.items;

                  _items = model.greyList.data!.result!.items;

                  if (_searchController.text.toString().isEmpty) {
                    _searchResults = model.greyList.data!.result!.items;
                  }

                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _searchResults!.length,
                    itemBuilder: (context, index) {
                      var item = _searchResults![index];

                      return Card(
                        color: Colors.grey.shade100,
                        elevation: 4.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  ContainerValue(
                                    text: 'Name',
                                    value: ": ${item.visitorName}",
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  ContainerValue(
                                    text: 'Vehicle Plate',
                                    value: ": ${item.vehiclePlateNo}",
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  ContainerValue(
                                    text: 'Vehicle Type',
                                    value: ": ${item.vehicleType}",
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  ContainerValue(
                                    text: 'Block Reason',
                                    value: ": ${item.blockReason}",
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                ],
                              ),
                            ),
                            if (item.createdBy == userDetails.id)
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                      child: Image.asset(
                                    'assets/images/ban-user.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                  )),
                                ),
                                onTap: () {
                                  popUp(index);
                                },
                              ),
                          ],
                        ),
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
            ],
          ),
        ),
      ),
    );
  }

  void _runSearch(String searchTerm) {
    List<Items> results = [];
    for (var item in _items!) {
      if (item.visitorName!.toLowerCase().contains(searchTerm.toLowerCase()) ||
          item.vehiclePlateNo!
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _searchResults = results;
    });
  }

  void popUp(var index) {
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
              mainAxisSize: MainAxisSize.min,
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
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        'Grey List',
                        // style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 16, color: Colors.white) ),
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Are you sure you want to whitelist this user?',
                    softWrap: true,
                    style: GoogleFonts.roboto(
                        textStyle:
                            TextStyle(fontSize: 14, color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PositiveButton(
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      PositiveButton(
                          text: 'Submit',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
