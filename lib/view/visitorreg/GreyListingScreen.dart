import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/utils/CardData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/SignInModel.dart';
import '../../model/greylist/GreyList.dart';
import '../../utils/MyTextField.dart';
import '../../utils/NegativeButton.dart';
import '../../utils/PositiveButton.dart';
import '../../viewmodel/greylist/GreyListingsScreenViewModel.dart';

class GreyListingScreen extends StatefulWidget {
  const GreyListingScreen({Key? key}) : super(key: key);

  @override
  State<GreyListingScreen> createState() => _GreyListingScreenState();
}

class _GreyListingScreenState extends State<GreyListingScreen> {
  UserDetails userDetails = UserDetails();
  var token;

  List<Items>? _items = [];
  List<Items>? _searchResults = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserDetails();
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
        title:
            Text('Grey List', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
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
                                      // color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                    ),
                                  ),
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
                        'GreyListed User',
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
                    style: TextStyle(fontSize: 14, color: Colors.black),
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
                      NegativeButton(
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
