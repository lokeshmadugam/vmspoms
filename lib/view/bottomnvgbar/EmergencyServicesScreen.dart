import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/SignInModel.dart';
import '../../model/EmergencyService.dart';
import '../../model/ServiceType.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/EmergencyServiceViewModel.dart';


class EmergenncyServicesScreen extends StatefulWidget {
  const EmergenncyServicesScreen({Key? key}) : super(key: key);

  @override
  State<EmergenncyServicesScreen> createState() =>
      _EmergenncyServicesScreenState();
}

class _EmergenncyServicesScreenState extends State<EmergenncyServicesScreen> {
  UserDetails userDetails = UserDetails();
  var viewmodel = EmergencyServcieViewModel();
  List<EmergencyItems> _emergencyItemsList = [];
  //List<ServiceItems> _serviceTypeList = [];

  List<EmergencyItems>? _items = [];
  final _searchController = TextEditingController();

  var serviceTypeId;

  final List<Color> colors = [
    Colors.red,
    Colors.purple,
  ];

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

    //fetchEmergencyServicesList('');
    setState(() {
    fetchServiceTypeItems('EmergencyServices');
    });

  }

  Future<void> fetchEmergencyServicesList(var countryCode, var serviceTypeId, var subServiceTypeId) async {
    viewmodel.fetchEmergencyServiceList(countryCode, serviceTypeId, subServiceTypeId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _emergencyItemsList = data;
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

  Future<void> fetchServiceTypeItems(var serviceType) async {
    viewmodel.fetchServiceType(serviceType).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              for(int i=0;i<data.length;i++){
                if(data[i].keyValue == 'EmergencyServices'){
                  serviceTypeId = data[i].id;
                  break;
                }
              }
              fetchEmergencyServicesList(userDetails.countryCode, serviceTypeId, '');
              // _serviceTypeList = data;
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
                /*MyDropDown(
                    value: null,
                    hintText: 'Emergency Services',
                    items: _serviceTypeList
                        .map((item) => item.displayName)
                        .map((displayName) => DropdownMenuItem<String>(
                      value: displayName,
                      child: Text(displayName!),
                    ))
                        .toList(),
                    onchanged: (value) {
                      *//*for(int i=0;i<_emergencyItemsList.length;i++){
                        if(value == _emergencyItemsList[i].serviceTypeName){

                        }
                      }//
                    }
                ),*/
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _emergencyItemsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey.shade100,
                        //colors[index % colors.length],
                        elevation: 4.0,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            containerValue(icon: Icons.ac_unit, value: _emergencyItemsList[index].serviceTypeName.toString()),
                            Divider(
                              color: Colors.grey,
                            ),
                            InkWell(
                              child: containerValue(
                                  icon: Icons.phone,
                                  value: _emergencyItemsList[index].dialNumber.toString()),
                              onTap: () {
                                _launchPhoneDialer(_emergencyItemsList[index].dialNumber.toString());
                              },
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            InkWell(
                              child: containerValue(
                                  icon: Icons.web,
                                  value: _emergencyItemsList[index].serviceProviderUrl.toString()),
                              onTap: () {
                                _launchInBrowser(_emergencyItemsList[index].serviceProviderUrl.toString());
                              },
                            ),
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
    List<EmergencyItems> results = [];
    for (var item in _items!) {
      if (item.serviceTypeName!.toLowerCase().contains(searchTerm.toLowerCase()) ||
          item.serviceProviderUrl!
              .toLowerCase()
              .contains(searchTerm.toLowerCase())) {
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
              icon, color: Color(0xFF036CB2),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall
            ),
          ],
        ),
      ),
    );
  }
}