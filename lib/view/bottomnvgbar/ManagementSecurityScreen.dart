import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/SignInModel.dart';
import '../../model/ManagementSecurity.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/ManagementSecurityViewModel.dart';


class ManagementSecurityScreen extends StatefulWidget {
  const ManagementSecurityScreen({Key? key}) : super(key: key);

  @override
  State<ManagementSecurityScreen> createState() => _ManagementSecurityScreenState();
}

class _ManagementSecurityScreenState extends State<ManagementSecurityScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = ManagementSecurityViewModel();

  List<MgmtSecurityItems> _managementContactsList = [];
  List<MgmtSecurityItems>? _items = [];

  final _searchController = TextEditingController();
  var serviceTypeId;


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

    fetchServiceTypeItems('MgmtInHouseServices');
  }

  Future<void> fetchServiceTypeItems(var serviceType) async {
    viewmodel.fetchServiceType(serviceType).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              for(int i=0;i<data.length;i++){
                if(data[i].keyValue == 'ManagementOffice'){
                  serviceTypeId = data[i].id;
                  break;
                }
              }
              fetchManagementContactItems(serviceTypeId, userDetails.propertyId);
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchManagementContactItems(var managementInHouseId,
      var propertyId) async {
    viewmodel.fetchManagementContactList(managementInHouseId, propertyId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _managementContactsList = data;
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

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                MyTextField(
                  hintText: 'Search',
                  controller: _searchController,
                  onChanged: (value) {
                    _runSearch(value);
                  },
                  textInputType: TextInputType.text,
                  suffixIcon: Icons.search,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _managementContactsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey.shade100,
                        //colors[index % colors.length],
                        elevation: 2.0,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            containerValue(icon: Icons.person, value: _managementContactsList[index].contactName.toString()),
                            Divider(
                              color: Colors.grey,
                            ),
                            InkWell(
                              child: containerValue(
                                  icon: Icons.phone,
                                  value: _managementContactsList[index].phoneNo.toString()),
                              onTap: () {
                                _launchPhoneDialer(_managementContactsList[index].phoneNo.toString());
                              },
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            containerValue(
                                icon: Icons.ac_unit,
                                value: _managementContactsList[index].serviceTypeName.toString()),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _runSearch(String searchTerm) {
    List<MgmtSecurityItems> results = [];
    for (var item in _items!) {
      if (item.serviceTypeName!.toLowerCase().contains(searchTerm.toLowerCase()) ||
          item.contactName!
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _managementContactsList = results;
    });
  }

  Container containerValue({
    required var icon,
    required String value,
  }) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Icon(
                icon, color: Color(0xFF036CB2)
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
