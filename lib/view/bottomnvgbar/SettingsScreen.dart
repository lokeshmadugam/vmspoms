import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../view/bottomnvgbar/CompanyPolicyHtmlScreen.dart';
import '../../view/bottomnvgbar/ProfileScreen.dart';
import '../../view/bottomnvgbar/ProfileTabsScreen.dart';
import '../../view/clockinclockout/CommonClockInClockOutScreen.dart';
import '../../viewmodel/SettingsScreenViewModel.dart';

import '../../model/SignInModel.dart';
import '../../model/CompanyPolicies.dart';
import '../../utils/Utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserDetails userDetails = UserDetails();
  String? profileName;
  var viewmodel = SettingsScreenViewModel();
  List<PolicyItems> policyItems = [];

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

    setState(() {
      profileName =
          "${userDetails.unitNumber} | ${userDetails.firstName} ${userDetails.lastName}";
      fetchCompanyPoliciesList(userDetails.propertyId);
    });
  }

  Future<void> fetchCompanyPoliciesList(var propertyId) async {
    viewmodel.fetchCompanyPolicyList(propertyId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              policyItems = data;
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
        automaticallyImplyLeading: false,
        leadingWidth: 90,
        elevation: 0.0,
        title: Text(
          'Settings',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xFF036CB2),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      "My Profile",
                      style: TextStyle(fontSize: 18, color: Colors.white
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                InkWell(
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.home,
                            color: Color(0xFF036CB2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            profileName.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileTabsScreen(
                                  showAppBar: true,
                                )));
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF036CB2)),
                  //color: Colors.indigo[300],
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      "App Info",
                      style: TextStyle(fontSize: 18, color: Colors.white
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Card(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.info_outline,
                          color: Color(0xFF036CB2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(
                          'App version',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          '3.0.5',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF036CB2)),
                  //color: Colors.indigo[300],
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      "e - Neighbourhood",
                      style: TextStyle(fontSize: 18, color: Colors.white
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                ListView.separated(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: policyItems.length,
                  itemBuilder: (context, index) {
                    var item = policyItems[index];

                    return InkWell(
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.group,
                                color: Color(0xFF036CB2),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              child: Text(
                                item.dispName.toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompanyPolicyHtmlScreen(data: item),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF036CB2)),
                    //color: Colors.indigo[300],
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child: Text(
                        "Public Clock-In Clock-Out",
                        style: TextStyle(fontSize: 18, color: Colors.white
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommonClockInClockOutScreen(),
                      ),
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
}
