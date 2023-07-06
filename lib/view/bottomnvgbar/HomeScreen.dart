import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view/announcements/AnnouncementScreen.dart';

import '../../view/bottomnvgbar/SliderFullTextScreen.dart';
import '../../view/houseRules/HouseRulesScreen.dart';
import '../../view/intercom/IntercomListingScreen.dart';
import '../../view/newsbulletin/NewsBulletinScreen.dart';
import '../../view/trustednbgh/TrustedNeighbourScreen.dart';
import '../../viewmodel/AddsViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/SignInModel.dart';
import '../../model/AddsSliderModel.dart';
import '../../model/PermissionModel.dart';
import '../../utils/Utils.dart';
import '../../view/PublicServicesScreen.dart';
import '../../view/clockinclockout/AttendanceTabsScreen.dart';
import '../../view/facility/FacilityBookingTabsScreen.dart';
import '../../view/greylist/GreyListingsScreen.dart';
import '../../view/lostfound/LostFoundTabsScreen.dart';
// import '../../view/managementservices/ManagementServicesTabScreen.dart';
// import '../../view/packages/PackageTabsScreen.dart';
import '../../view/securityrounds/SecurityTabsScreen.dart';
import '../../view/visitorreg/InvitationsScreen.dart';
import '../damagescomplaints/ComplaintsListingScreen.dart';
import '../e-document/EDocumentTabsScreen.dart';
import '../managementservices/ManagementServicesTabScreen.dart';
import '../notifications/NotificationsTabScreen.dart';
import '../packages/PackageTabsScreen.dart';
import '../visitorreg/ContactsScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  UserDetails userDetails = UserDetails();
  List<PermissionModel> _permissionsList = [];
  var viewModel = AddsViewModel();
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
  bool trustedNeighbour = false;
  bool billing = false;
  bool edocument = false;
  bool complaints = false;
  bool contacts = false;
  List<AddItems> _addItems =[];
  List<AddItems> filteredItems =[];
  List<dynamic> list = [];
String profileImg = '';
  int activeIndex = 0;
 var data;
  PermissionModel model = PermissionModel();
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
    fetchAddsType();
    if(userDetails.permissions!=null){
       data = userDetails.permissions;
      for(int i=0;i<data!.length;i++){
        if(data[i].menuDisplayNameMobile.toString().trim() == 'Visitor Registration'){
          visitor = true;
          greylisted = true;

          // model.name = data[i].menuDisplayNameMobile.toString();
          // model.image = data[i].menuIconMobile.toString();
          // _permissionsList.add(model);
        } else if((data[i].moduleDisplayNameMobile.toString().trim() == 'Package Receipts') ||
            (data[i].moduleDisplayNameMobile.toString().trim() == 'Package Received')){
          packages = true;
        }
        // else if(data[i].moduleDisplayName.toString().trim() == 'Package Receipts'){
        //   packages = true;
        // }
        else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Security & patrols' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Security Logs' || data[i].moduleDisplayNameMobile.toString().trim() == 'Security Rounds'){
          security = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Attendance' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Attendance Details' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Clock-in/Clock Out'){
          attendance = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Grey List' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Visitors'){

            greylisted = true;

        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Facility Booking' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Facility Booking' ||
            data[i].moduleDisplayNameMobile.toString().trim() == 'Facility Booking'){
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
        } else if((data[i].moduleDisplayNameMobile.toString().trim() == 'Payment and Invoices') ||
            (data[i].moduleDisplayNameMobile.toString().trim() == 'Invoice')){
          billinginvoice = true;
        } else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Configuration'){
          settings = true;
        }
        else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Trusted Neighbour'){
          trustedNeighbour = true;
        }
        else if((data[i].moduleDisplayNameMobile.toString().trim() == 'My Billing') ||(data[i].moduleDisplayNameMobile.toString().trim() == 'Billing')){
          billing = true;
        }
        else if((data[i].moduleDisplayNameMobile.toString().trim() == 'e-Document')){
          edocument = true;
        }
        else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Complaints'){
          complaints = true;
        }
        else if(data[i].moduleDisplayNameMobile.toString().trim() == 'Important Contacts'){
          contacts = true;
        }

      }
    }

    setState(() {
      if(visitor){
        PermissionModel model = PermissionModel();
        model.name = 'Visitor Registration';
        model.image = 'assets/images/visitors.png';

        _permissionsList.add(model);
      }

      if(packages){
        PermissionModel model = PermissionModel();
        model.name = 'Packages';
        model.image = 'assets/images/Home4package.png';
        // model.icon = Icon(Icons.gif_box_rounded,size: 50,color: Colors.white,);
        _permissionsList.add(model);
      }

      if(security){
        PermissionModel model = PermissionModel();
        model.name = 'Security Rounds';
        model.image = 'assets/images/security.png';
        _permissionsList.add(model);
      }

      if(attendance){
        PermissionModel model = PermissionModel();
        model.name = 'Attendance';
        model.image = 'assets/images/newattendance.png';
        _permissionsList.add(model);
        // package_blue.png
      }
      if(userDetails.roleName != "Resident User" && greylisted) {
        // if (greylisted) {
          PermissionModel model = PermissionModel();
          model.name = 'Grey List';
          model.image = 'assets/images/ban-user.png';
          _permissionsList.add(model);
        // }
      }
      if(facility){
        PermissionModel model = PermissionModel();
        model.name = 'Facility Bookings';
        model.image = 'assets/images/booking.png';
        _permissionsList.add(model);
        // package_10.png
      }

      if(lostfound){
        PermissionModel model = PermissionModel();
        model.name = 'Lost & Found';
        model.image = 'assets/images/lost-and-found.png';
        _permissionsList.add(model);
      }

      if(intercom){
        PermissionModel model = PermissionModel();
        model.name = 'Intercom';
        model.image = 'assets/images/intercomnew.png';
        _permissionsList.add(model);
      }

      // if(notifications){
      //   PermissionModel model = PermissionModel();
      //   model.name = 'Notifications';
      //   model.image = 'assets/images/newNotifications.png';
      //   _permissionsList.add(model);
      // }

      // if(announcements){
      //   PermissionModel model = PermissionModel();
      //   model.name = 'e-Documents';
      //   model.image = 'assets/images/folder-1.png';
      //   _permissionsList.add(model);
      // }

      if(newsbulletin){
        PermissionModel model = PermissionModel();
        model.name = 'News Bulletin';
        model.image = 'assets/images/folders.png';
        _permissionsList.add(model);
      }

      if(houserules){
        PermissionModel model = PermissionModel();
        model.name = 'House Rules';
        model.image = 'assets/images/regulation.png';
        _permissionsList.add(model);
      }

      if(billinginvoice){
        PermissionModel model = PermissionModel();
        model.name = 'Invoice';
        model.image = 'assets/images/invoice.png';
        _permissionsList.add(model);
      }
      if(billing){
        PermissionModel model = PermissionModel();
        model.name = 'My Billing';
        model.image = 'assets/images/invoice.png';
        _permissionsList.add(model);
      }

      // if(settings){
      //   PermissionModel model = PermissionModel();
      //   model.name = 'Settings';
      //   model.image = 'assets/images/settings.png';
      //   _permissionsList.add(model);
      // }
      // userDetails.appUsageTypeName == 'VMS Management modules ' ||
      //     userDetails.appUsageTypeName == 'Unit users'
      if(trustedNeighbour){
        PermissionModel model = PermissionModel();
        model.name = 'Trusted Neighbour';
        model.image = 'assets/images/neighborhood.png';
        _permissionsList.add(model);
      }
      if(edocument){
        PermissionModel model = PermissionModel();
        model.name = 'e-Document';
        model.image = 'assets/images/folder-1.png';
        _permissionsList.add(model);
      }
      // PermissionModel model = PermissionModel();
      // model.name = 'Mgmt-Security';
      // model.image = 'assets/images/mgmt.png';
      // _permissionsList.add(model);

      // PermissionModel model1 = PermissionModel();
      // model1.name = 'Emerg. Phone no.';
      // model1.image = 'assets/images/book.png';
      // _permissionsList.add(model1);

      if(complaints){
        PermissionModel model = PermissionModel();
        model.name = 'Complaints';
        // complaint.png
        model.image = 'assets/images/businessman.png';
        _permissionsList.add(model);
      }
        // profileImg = userDetails.profileImg ?? '';

    });


  }
  void fetchAddsType() async {
    viewModel.getAdds("ASC", "id", 1, 100, userDetails.propertyId ?? 0).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {

            setState(() {

              _addItems = data;
            filteredItems = _addItems.where((item) {
                final sliderimage = item.sliderImg?.toString();
                final slidertext = item.sliderText?.toString();
                return (sliderimage != null && sliderimage.isNotEmpty) || (slidertext != null && slidertext.isNotEmpty);
              }).toList();



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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double? fontSize;
    double? fontSize1;
    double? fontSize2;
    if(width < 411 || height < 707){
      fontSize = 11;
      fontSize1 = 14;
      fontSize2 = 18;

    }else {
      fontSize = 14;
      fontSize1 = 16;
      fontSize2 = 20;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(

        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF036CB2),
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
                            style:GoogleFonts.roboto(textStyle: TextStyle(

                                fontSize: fontSize2,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),)
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
                      border: Border.all(color: Color(0xFF036CB2), width: 1),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),

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
                        color:Color(0xFF036CB2),
                        border:
                        Border.all(color: Color(0xFF036CB2), width: 1),

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
                                "${userDetails.unitNumber} | ${userDetails.firstName} ${userDetails.lastName}",
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize1,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700), )
                              ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.01,
                              ),
                              // const Text(
                              //   'Payment due on 15th June', softWrap: true,
                              //   style: TextStyle(
                              //     fontSize: 16,
                              //     color: Colors.white,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.01,
                              ),
                            ],
                          ),
                          const Spacer(),
                          if(userDetails.profileImg  != null)
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
                                onTap: () {},
                              ),
                            ),
                        ],
                      ),
                    )),
              ),
              if(_permissionsList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 6.0,right: 6.0,top: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                        // Border.all(color: Colors.white, width: 3),
                        Border.all(color:Colors.white, width: 1),
                        // Color(0xFF036CB2)
                        // color: Color(0xFF3F9AE5),
                        color: Colors.white,
                        // color: Color(0xFF6EB8FA),
                        borderRadius: BorderRadius.circular(20)),
                    child: GridView.builder(
                        padding: const EdgeInsets.only(top: 5.0,bottom: 0.0),
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
                          // mainAxisSpacing: 0


                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            child: InkWell(
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      _permissionsList[index].image.toString(),
                                      height: MediaQuery.of(context).size.height *
                                          0.05,
                                      width:
                                      MediaQuery.of(context).size.width * 0.11,
                                      fit: BoxFit.contain,

                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      _permissionsList[index].name.toString(), softWrap: true, textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodySmall
                                      // TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                var module = _permissionsList[index].name;
                                if (module == 'Visitor Registration') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InvitationsScreen(contact: null, data: data,)));
                                } else if (module == 'Packages') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PackageTabsScreen(data: data,)));
                                } else if (module == 'Security Rounds') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SecurityTabsScreen(data: data,)));
                                } else if (module == 'Attendance') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AttendanceTabsScreen(data: data,)));
                                } else if (module == 'Grey List') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GreyListingsScreen(data: data,)));
                                } else if (module == 'Lost & Found') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LostFoundTabsScreen(data: data,)));
                                } else if (module == 'Facility Bookings') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FacilityBookingTabsScreen(data: data,)));
                                }  else if (module == 'Intercom') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IntercomListingScreen(data: data,)));

                                }
                                else if (module == 'Notifications') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsTabScreen()));
                                }
                                else if (module == 'Trusted Neighbour') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TrustedNeighnourScreen(data: data,)));

                                }
                                // else if (module == 'Announcement) {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               AnnouncementsScreen()));
                                //
                                // }
                                else if (module == 'News Bulletin') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsBulletinScreen(data: data,)));

                                }
                                else if (module == 'House Rules') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HouseRulesScreen(data: data,)));

                                }
                                else if (module == 'e-Document') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EDocumentTabsScreen(data: data,)));

                                }
                                // else if (module == 'Mgmt-Security') {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               ManagementServicesTabScreen()));
                                //
                                // } else if (module == 'Emerg. Phone no.') {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               PublicServiceScreen()));
                                // }
                                else if (module == 'Complaints') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ComplaintsListingScreen(data: data,)));
                                }
                              },
                            ),
                          );
                        }),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF036CB2), width: 3),
                    borderRadius: BorderRadius.circular(20),
                    //color: Colors.grey
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index, int) {
                        if (index >= filteredItems.length) {
                          return Container(); // Return an empty container if the index is out of range
                        }
                        var items = filteredItems[index];
                        var sliderimage = items.sliderImg?.toString();
                        var slidertext = items.sliderText?.toString();

                        // Check if both sliderImg and sliderText are empty
                        if ((sliderimage == null || sliderimage.isEmpty) && (slidertext == null || slidertext.isEmpty)) {
                          return SizedBox.shrink(); // Return a zero-sized SizedBox to skip displaying empty items
                        }

                        return InkWell(
                          onTap: () {
                            if (slidertext != null && slidertext.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SliderFullText(data: slidertext),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (sliderimage != null && sliderimage.isNotEmpty)
                                    SizedBox(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        sliderimage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  if (slidertext != null && slidertext.isNotEmpty)
                                    HtmlWidget(
                                      slidertext,
                                      textStyle: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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