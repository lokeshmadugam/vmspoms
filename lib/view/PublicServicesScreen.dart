import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/ServiceType.dart';
import '../../viewmodel/EmergencyServiceViewModel.dart';

import '../../Model/SignInModel.dart';
import '../../model/EmergencyService.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';
import '../utils/MyDropdown.dart';

class PublicServiceScreen extends StatefulWidget {
  const PublicServiceScreen({Key? key}) : super(key: key);

  @override
  State<PublicServiceScreen> createState() => _PublicServiceScreenState();
}

class _PublicServiceScreenState extends State<PublicServiceScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = EmergencyServcieViewModel();

  List<EmergencyItems> _emergencyItemsList = [];
  List<EmergencyItems>? _items = [];

  List<ServiceItems>? _subServiceItems = [];

  final _searchController = TextEditingController();

  var serviceTypeId;
  var subServiceTypeId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
    // fetchServiceTypeItems('OtherUsefulServices');
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    setState(() {
      fetchServiceTypeItems('OtherUsefulServices');
    });
  }

  Future<void> fetchServiceTypeItems(var serviceType) async {
    viewmodel.fetchServiceType(serviceType).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              for (int i = 0; i < data.length; i++) {
                if (data[i].keyValue == 'OtherUsefulServices') {
                  serviceTypeId = data[i].id;
                  break;
                }
              }
              fetchEmergencyServicesList(
                  userDetails.countryCode, serviceTypeId, '');
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchEmergencyServicesList(
      var countryCode, var serviceTypeId, var subServiceTypeId) async {
    viewmodel
        .fetchEmergencyServiceList(countryCode, serviceTypeId, subServiceTypeId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _emergencyItemsList = data;
              if (_searchController.text.toString().isEmpty) {
                _items = data;
              }
              fetchSubServiceTypeItems('OtherUsefulSubServices');
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchSubServiceTypeItems(var serviceType) async {
    viewmodel.fetchServiceType(serviceType).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _subServiceItems = data;
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

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
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
                      style: Theme.of(context).textTheme.headlineMedium
                      // TextStyle(
                      //   fontSize: 16, // reduce the font size
                      //   color: Colors.white,
                      //   fontWeight: FontWeight.bold,
                      // ),
                      ),
                ),
              ),
            ),
          ],
        ),
        title: Text('Service Providers',
            style: Theme.of(context).textTheme.headlineLarge
            // TextStyle(
            //     fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
                MyDropDown(
                    value: null,
                    hintText: 'Service Type',
                    items: _subServiceItems!
                        .map((item) => item.displayName)
                        .map((displayName) => DropdownMenuItem<String>(
                              value: displayName,
                              child: Text(displayName!),
                            ))
                        .toList(),
                    onchanged: (value) {
                      for (int i = 0; i < _subServiceItems!.length; i++) {
                        if (value == _subServiceItems![i].displayName) {
                          subServiceTypeId = _subServiceItems![i].id;
                          break;
                        }
                      }
                      fetchEmergencyServicesList(userDetails.countryCode,
                          serviceTypeId, subServiceTypeId);
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _emergencyItemsList.length,
                    itemBuilder: (context, index) {
                      var item = _emergencyItemsList[index];
                      List<String> separatedNumbers =
                          separateMobileNumbers(item.dialNumber.toString());

                      return Card(
                        color: Colors.grey.shade100,
                        //colors[index % colors.length],
                        elevation: 4.0,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            containerValue(
                                icon: Icons.ac_unit,
                                value: item.serviceName.toString()),
                            Divider(
                              color: Colors.grey,
                            ),
                            for (String number in separatedNumbers)
                              Column(
                                children: [
                                  InkWell(
                                    child: containerValue(
                                        icon: Icons.phone, value: number),
                                    onTap: () {
                                      _launchPhoneDialer(number);
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            InkWell(
                              child: containerValue(
                                  icon: Icons.web,
                                  value: item.serviceProviderUrl.toString()),
                              onTap: () {
                                _launchInBrowser(
                                    item.serviceProviderUrl.toString());
                              },
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            containerValue(
                                icon: Icons.map, value: item.state.toString()),
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

  List<String> separateMobileNumbers(String numbersString) {
    if (numbersString.contains(',')) {
      return numbersString.split(',');
    } else if (numbersString.contains('/')) {
      return numbersString.split('/');
    } else {
      return [numbersString];
    }
  }

  void _runSearch(String searchTerm) {
    List<EmergencyItems> results = [];
    for (var item in _items!) {
      if (item.serviceName!.toLowerCase().contains(searchTerm.toLowerCase()) ||
          item.state!.toLowerCase().contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _emergencyItemsList = results;
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
              icon,
              color: Color(0xFF036CB2),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Expanded(
              child: Text(value, style: Theme.of(context).textTheme.bodySmall
                  // TextStyle(
                  //   color: Colors.black,
                  //   fontSize: 14,
                  // ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
