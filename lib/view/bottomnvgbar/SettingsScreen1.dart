import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:poms_app/view/bottomnvgbar/EmergencyServicesScreen.dart';
import 'package:poms_app/view/intercom/IntercomListingScreen.dart';
import 'package:poms_app/view/trustednbgh/TrustedNeighbourScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/SignInModel.dart';
import '../../model/PermissionModel.dart';
import '../../view/PublicServicesScreen.dart';
import '../../view/clockinclockout/AttendanceTabsScreen.dart';
import '../../view/facility/FacilityBookingTabsScreen.dart';
import '../../view/greylist/GreyListingsScreen.dart';
import '../../view/lostfound/LostFoundTabsScreen.dart';
// import '../../view/managementservices/ManagementServicesTabScreen.dart';
// import '../../view/packages/PackageTabsScreen.dart';
import '../../view/securityrounds/SecurityTabsScreen.dart';
import '../../view/visitorreg/InvitationsScreen.dart';
import '../managementservices/ManagementServicesTabScreen.dart';
import '../packages/PackageTabsScreen.dart';
import '../visitorreg/ContactsScreen.dart';
import 'Home4.dart';

// import '../model/PermissionModel.dart';

class HomeScreen3 extends StatefulWidget {
  const HomeScreen3({Key? key}) : super(key: key);

  @override
  _HomeScreen3State createState() => _HomeScreen3State();
}

class _HomeScreen3State extends State<HomeScreen3> {

  final List<String> _sliderImages = [
    'https://cdn.naturettl.com/wp-content/uploads/2017/02/22014001/top-tips-improve-landscapes-ross-hoddinott-11-1200x675-cropped.jpg',
    'https://www.photographytalk.com/images/articles/2018/12/03/articles/2017_8/mountain-landscape-ponta-delgada-island-azores-picture-id944812540.jpg',
    'https://www.networkrail.co.uk/wp-content/uploads/2022/11/Ribblehead-Viaduct-1024x683.jpg',
  ];

  UserDetails userDetails = UserDetails();
  List<PermissionModel> _permissionsList = [];
  bool visitor = false;
  bool packages = false;
  bool security = false;
  bool attendance = false;
  bool greylisted = false;
  bool facility = false;
  bool lostfound = false;
  bool intercom = false;
  bool notifications = false;
  bool announcements = false;
  bool newsbulletin = false;
  bool houserules = false;
  bool billinginvoice = false;
  bool settings = false;

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

    if(userDetails.permissions!=null){
      var data = userDetails.permissions;
      for(int i=0;i<data!.length;i++){
        if(data[i].moduleDisplayNameMobile.toString().trim() == 'Visitor Registration' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Visitors'){
          visitor = true;
          greylisted = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Packages'){
          packages = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Security Rounds' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Security Logs'){
          security = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Attendance' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Attendance Details' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Clock-in/Clock-out'){
          attendance = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Grey listed' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Visitors'){
          greylisted = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'facility bookings' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Facility Booking' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Facilities'){
          facility = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Lost & Found'){
          lostfound = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Intercom'){
          intercom = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Announcements & Notifications' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Notification' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Notifications'){
          announcements = true;
          notifications = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'News Bulletin'){
          newsbulletin = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'House Rules'){
          houserules = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Invoice'){
          billinginvoice = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Configuration'){
          settings = true;
        }
      }
    }

    setState(() {
      if(visitor){
        PermissionModel model = PermissionModel();
        model.name = 'Visitor Registration';
        model.image = 'assets/images/package_orn_r150 copy 2.png';
        _permissionsList.add(model);
      }

      if(packages){
        PermissionModel model = PermissionModel();
        model.name = 'Packages';
        model.image = 'assets/images/package_orn_r150 copy 2.png';
        // package.png
        _permissionsList.add(model);
      }

      if(security){
        PermissionModel model = PermissionModel();
        model.name = 'Security Rounds';
        model.image = 'assets/images/package_orn_r150 copy 2.png';
        // package_orange_150.png
        _permissionsList.add(model);
      }

      if(attendance){
        PermissionModel model = PermissionModel();
        model.name = 'Attendance';
        model.image = 'assets/images/package_orn_r150 copy 2.png';
        // package_light-orange_r150.png
        _permissionsList.add(model);
      }

      if(greylisted){
        PermissionModel model = PermissionModel();
        model.name = 'Grey List';
        model.image = 'assets/images/package_orn_r150 copy 2.png';
        _permissionsList.add(model);
      }

      if(facility){
        PermissionModel model = PermissionModel();
        model.name = 'Facility Bookings';
        model.image = 'assets/images/package_orn_r150 copy 2.png';
        _permissionsList.add(model);
      }

      if(lostfound){
        PermissionModel model = PermissionModel();
        model.name = 'Lost & Found';
        model.image = 'assets/images/package_b2_r150.png';
        _permissionsList.add(model);
      }

      if(intercom){
        PermissionModel model = PermissionModel();
        model.name = 'Intercom';
        model.image = 'assets/images/package_b2_r150.png';
        _permissionsList.add(model);
      }

      if(notifications){
        PermissionModel model = PermissionModel();
        model.name = 'Notifications';
        model.image = 'assets/images/package_b2_r150.png';
        _permissionsList.add(model);
      }

      if(announcements){
        PermissionModel model = PermissionModel();
        model.name = 'Announcements';
        model.image = 'assets/images/011-package_red_r150.png';
        _permissionsList.add(model);
      }

      if(newsbulletin){
        PermissionModel model = PermissionModel();
        model.name = 'News Bulletin';
        model.image = 'assets/images/announcements.png';
        _permissionsList.add(model);
      }

      if(houserules){
        PermissionModel model = PermissionModel();
        model.name = 'House Rules';
        model.image = 'assets/images/announcements.png';
        _permissionsList.add(model);
      }

      if(billinginvoice){
        PermissionModel model = PermissionModel();
        model.name = 'Invoice';
        model.image = 'assets/images/announcements.png';
        _permissionsList.add(model);
      }

      if(settings){
        PermissionModel model = PermissionModel();
        model.name = 'Settings';
        model.image = 'assets/images/announcements.png';
        _permissionsList.add(model);
      }

      if(userDetails.appUsageTypeName == 'VMS Management modules ' ||
          userDetails.appUsageTypeName == 'Unit users' ){
        PermissionModel model = PermissionModel();
        model.name = 'Trusted Neighbour';
        model.image = 'assets/images/announcements.png';
        _permissionsList.add(model);
      }

      PermissionModel model = PermissionModel();
      model.name = 'Management Services';
      model.image = 'assets/images/011-package_red_r150.png';
      _permissionsList.add(model);

      PermissionModel model1 = PermissionModel();
      model1.name = 'Other Service Providers';
      model1.image = 'assets/images/011-package_red_r150.png';
      _permissionsList.add(model1);
    });


  }
  final dummyContact = Contact(displayName: " ", phones: []);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF44336),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      //borderRadius: BorderRadius.circular(20)
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        if(userDetails.propertyDispName != null)
                          Text(
                            userDetails.propertyDispName.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ],
                    )),
              ),
              if(userDetails.propertyImg!=null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffF44336), width: 2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    //borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      userDetails.propertyImg.toString().trim(),
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: double.infinity,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFEED9),
                        border:
                        Border.all(color: Color(0xffF44336), width: 1),
                        /*borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),*/
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                "${userDetails.unitNumber} - ${userDetails.firstName} ${userDetails.lastName}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.01,
                              ),
                             TextButton(
                                child: Text('Payment due on 15th June', softWrap: true,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),) ,
                               onPressed: () {
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             HomeScreen4()));
                               },
                              ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.01,
                              ),
                            ],
                          ),
                          const Spacer(),
                          if(userDetails.profileImg!=null)
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  height:
                                  MediaQuery.of(context).size.height * 0.08,
                                  width: MediaQuery.of(context).size.width * 0.18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    image:  DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          userDetails.profileImg.toString().trim()),
                                    ),
                                  ),
                                ),
                                onTap: () {

                                },
                              ),
                            ),
                        ],
                      ),
                    )),
              ),
              if(_permissionsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        color: Color(0xFFFF6436),
                        borderRadius: BorderRadius.circular(20)),
                    child: GridView.builder(
                        padding: const EdgeInsets.only(top: 10.0),
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _permissionsList.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(

                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            childAspectRatio:1,
                            mainAxisExtent:100
                        ),
                        itemBuilder: (context, index) {
                          // return Column(
                          //   //mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     InkWell(
                          //       child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(10.0),
                          //         child: Image.asset(
                          //           _permissionsList[index].image.toString(),
                          //           height: MediaQuery.of(context).size.height *
                          //               0.06,
                          //           width:
                          //           MediaQuery.of(context).size.width * 0.13,
                          //           fit: BoxFit.cover,
                          //         ),
                          //       ),
                          //       onTap: () {
                          //         var module = _permissionsList[index].name;
                          //         if (module == 'Visitor Registration') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       InvitationsScreen(contact: null,)));
                          //         } else if (module == 'Packages') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       PackageTabsScreen()));
                          //         } else if (module == 'Security Rounds') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       SecurityTabsScreen()));
                          //         } else if (module == 'Attendance') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       AttendanceTabsScreen()));
                          //         } else if (module == 'Grey List') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       GreyListingsScreen()));
                          //         } else if (module == 'Lost & Found') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       LostFoundTabsScreen()));
                          //         } else if (module == 'Facility Bookings') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       FacilityBookingsScreen()));
                          //         }  else if (module == 'Intercom') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       IntercomListingScreen()));
                          //
                          //         }
                          //         else if (module == 'Trusted Neighbour') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       TrustedNeighnourScreen()));
                          //
                          //         }
                          //         else if (module == 'Management Services') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       ManagementServicesTabScreen()));
                          //
                          //         } else if (module == 'Other Service Providers') {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       PublicServiceScreen()));
                          //         }
                          //       },
                          //     ),
                          //     const SizedBox(height: 8),
                          //     Center(
                          //       child: Text(
                          //         _permissionsList[index].name.toString(), softWrap: true, textAlign: TextAlign.center,
                          //         style: TextStyle(color: Colors.white, fontSize: 12),
                          //       ),
                          //     ),
                          //   ],
                          // );
                        }),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lime.shade800, width: 3),
                    borderRadius: BorderRadius.circular(20),
                    //color: Colors.grey
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: _sliderImages.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final String imageUrl = entry.value;
                        return Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                              onTap: () {
                                /*if(index == 0){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GreyListingsScreen(),
                                    ),
                                  );
                                }*/
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



