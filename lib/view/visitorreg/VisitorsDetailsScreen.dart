import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/model/visitorreg/FavoriteVisitors.dart';
import 'package:poms_app/view/visitorreg/AddVisitorInGreyList.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/intercom/IntercomListingModel.dart';
import '../../model/visitorreg/VisitorsListModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/intercom/IntercomViewModel.dart';
import '../../viewmodel/visitorregistration/InviteVisitorViewModel.dart';
import 'CalltoVisitorScreen.dart';

class VisitorsDetailsScreen extends StatefulWidget {
  VistorsListItems item;

  VisitorsDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<VisitorsDetailsScreen> createState() => _VisitorsDetailsScreenState();
}

class _VisitorsDetailsScreenState extends State<VisitorsDetailsScreen> {
  int selectedIndex = 0;

  bool isSelected = false;
  var viewModel = InviteVisitorViewModel();
  var userVM = UserViewModel();
  var intercomViewModel = IntercomViewModel();
  List<IntercomItems> _intercomList = [];
  List<FavoriteVisitorsItems> favoriteVisitorsList = [];
  int userId = 0;
  int propertyId = 0;
  String firstName = "";
  String unitNumber = '';
  String blockName = "";
  String appusagetypeName = "";
  String mobileNumber = '';
  String roleName = '';
  var checkIn;
var checkOut;
  @override
  void initState() {
    super.initState();
    getUserDetails();
if (widget.item.visitorCheckInOutDate.toString().isNotEmpty || widget.item.visitorCheckInOutDate != null  ){
  var data = widget.item.visitorCheckInOutDate ?? [];
  for (var i in data)   {
    if(i.visitorCheckinDate.toString().isNotEmpty || i.visitorCheckinDate != null) {
      checkIn = i.visitorCheckinDate.toString();
    }
    if (i.visitorCheckoutDate.toString().isNotEmpty || i.visitorCheckoutDate != null){
      checkOut = i.visitorCheckoutDate.toString();
    }
  }
}
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;

      userId = userid ?? 0;
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      // unitDeviceCnt = unitdevicecnt ?? 0 ;
      final unitnmb = value.userDetails?.unitNumber;

      final blockname = value.userDetails?.blockName;

      final usertypeId = value.userDetails?.userType;
      // userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeName;
      appusagetypeName = appusagetypeid ?? " ";
      final firstname= value.userDetails?.firstName ?? '';
final rolename = value.userDetails?.roleName.toString();
      setState(() {
        firstName = firstname;
        blockName = blockname ?? "";
        unitNumber = unitnmb ?? " ";
        roleName = rolename ?? "";
      });
    });

  }
  Future<void> fetchIntercomList() async {
    intercomViewModel
        .getIntercomList( "ASC", "id", 1, 500, propertyId,unitNumber)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _intercomList = data;
              // _filteredintercomList = _intercomList;
              for (var item in data) {
                final priorityCount = item.priority ?? 0;
                if (priorityCount == 1){
                  mobileNumber= item.phoneNumber ?? '';
                  // mobileNumber = phoneno
                  _launchPhoneDialer(item.phoneNumber ?? '');
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
  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  Future<void> submitFavoriteVisitorDetails() async {



      Map<String, dynamic> data ={
        "block_name": widget.item.blockName,
        "created_by": userId,
        "id_driving_license_no": widget.item.idDrivingLicenseNo,
        "is_parking_required": widget.item.isParkingRequired,
        "is_preregistered": widget.item.isPreregistered,
        "no_of_visitor": widget.item.noOfVisitor,
        "property_id": widget.item.propertyId,
        "rec_status": widget.item.recStatus,
        "remarks": widget.item.remarks,
        "unit_number": widget.item.unitNumber,
        "user_id": widget.item.userId,
        "user_type_id": widget.item.userTypeId,
        "vehicle_plate_no": widget.item.vehiclePlateNo,
        "visit_reason_id": widget.item.visitReasonId,
        "visit_type_id": widget.item.visitTypeId,
        "visitor_mobile_no": widget.item.visitorMobileNo,
        "visitor_name": widget.item.visitorName,
        "visitor_registr_date": widget.item.visitorRegistrDate,
        "visitor_transport_mode": widget.item.visitorTransportMode
      };

      viewModel.addFavoriteVisitor(data, context).then((value) {
        if (value.data!.status == 201) {
          print('msg = ${value.data!.mobMessage}');
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);

        } else {
          Utils.flushBarErrorMessage("${value.data!.mobMessage}", context);
        }
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          Utils.flushBarErrorMessage(error.toString(), context);
          print(error.toString());
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    double? fontSize1;
    double? fontSize2;
    if(width < 411 || height < 707){
      fontSize = 11;
      fontSize1 = 14;
      fontSize2 = 21;

    }else {
      fontSize = 14;
      fontSize1 = 16;
      fontSize2 = 24;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 90,
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
            'Visitor Details',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //   color: Color(0xff6c1ad0),
              //   border: Border.all(color: Colors.grey.shade300, width: 1.0),
              // ),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 0, right: 0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Host : $firstName",
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize1,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF002449)), )
                              ),
                              IconButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => CalltoVisitorScreen(
                                  //
                                  //     ),
                                  //   ),
                                  // );
                                  fetchIntercomList();
                                },
                                icon: Icon(Icons.phone_forwarded, color: Color(0xFF036CB2),size: 20,),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.004,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Block : $blockName",
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize1,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF002449)),
                              )),
                              SizedBox(
                                width: 10,
                              ),

                              Text(
                                "Unit No. : $unitNumber",
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize1,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF002449)),
                              )),
                              // Text(lastName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 1.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child:
                                  Text("Name", style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize))),
                            ),
                            Text(':'),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.item.visitorName}",
                                 style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 1.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Text("ID/Dl NO. ",
                                  style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize))),
                            ),
                            Text(':'),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('${widget.item.idDrivingLicenseNo}',
                                    style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize))),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300, width: 1.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Text("Vehicle No. ",
                                  style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize))),
                            ),
                            Text(':'),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${widget.item.vehiclePlateNo}',
                                      style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Text("Registration date",
                                  style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize))),
                            ),
                            Text(':'),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.item.visitorRegistrDate != null
                                        ? DateFormat('yyyy-MM-dd hh:mm a')
                                            .format(DateTime.parse(widget
                                                .item.visitorRegistrDate
                                                .toString()))
                                        : '',
                                    style:GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize)),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 0.0, right: 24),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade200,
boxShadow:  [BoxShadow(
  color: Colors.grey.withOpacity(0.5),
  spreadRadius: 0.5,
  // changes position of shadow
),]
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 0.0, right: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.subdirectory_arrow_left_rounded),
                              Text(
                                'Check-In',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize, color: Color(0xFF003470))),
                              ),
                              Text(
                                checkIn != null
                                    ? DateFormat('yyyy-MM-dd hh:mm a').format(
                                        DateTime.parse(
                                            checkIn
                                            .toString()))
                                    : '',
                                style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize)),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                      ),
                    ),
                    // SizedBox()
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade200,
                            boxShadow:  [BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              // changes position of shadow
                            ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 0.0, right: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.subdirectory_arrow_right_rounded),
                              Text(
                                'Check-Out',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize, color: Color(0xFF003470))),
                              ),
                              Text(
                                checkOut != null
                                    ? DateFormat('yyyy-MM-dd hh:mm a').format(
                                        DateTime.parse(checkOut
                                            .toString()))
                                    : '',
                                style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize)),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 0.0, right: 24),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade200,
                            boxShadow:  [BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              // changes position of shadow
                            ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 0.0, right: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_pin_rounded,
                                size: 20,
                              ),
                              Text(
                                'Purpose of Visit',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize, color: Color(0xFF003470))),
                              ),
                              Text(
                                '${widget.item.vistReason ?? ''}',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade200,
                            boxShadow:  [BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              // changes position of shadow
                            ),]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.people_rounded),
                            Text(
                              'No. of Visitors',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style:
                              GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize, color: Color(0xFF003470)),
                            )),
                            Text(
                              '${widget.item.noOfVisitor ?? ''}',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize),
                            )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 0.0, right: 24),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade200,
                            boxShadow:  [BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              // changes position of shadow
                            ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 0.0, right: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.grading_sharp),
                              Text(
                                'Mode of Transport',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize, color: Color(0xFF003470))),
                              ),
                              Text(
                                '${widget.item.vehicleType ?? ''}',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade200,
                            boxShadow:  [BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.5,
                              // changes position of shadow
                            ),]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 0.0, right: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.car_crash_sharp),
                              Text(
                                'Parking Required',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(
                                    fontSize: fontSize, color: Color(0xFF003470))),
                              ),
                              Text(
                                '${widget.item.parkingRequired ?? ''}',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.shade200,
                  boxShadow:  [BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    // changes position of shadow
                  ),]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Remarks',
                            style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize))
                        ),
                        Text(
                          ':',
                        ),
                        Text(
                          '${widget.item.remarks ?? ''}',
                            style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize))
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      children: [
                        Text(
                          'Notes',
                            style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize))
                        ),
                        Text(
                          ':',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xFF6F9302),

              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Visit Status :',
                        style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize,color: Colors.white)),

                    ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        ' ${ widget.item.visitorRegistrstionStatus ?? ''}',
                          style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize,color: Colors.white),)
                   ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Not My Visitor',
                          style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize,color: Colors.white,fontWeight: FontWeight.w500),)

                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF7E450B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddVisitorInGreyList(
                                  data: widget.item,
                                ),
                              ),
                            );
                          },
                          icon: Image.asset(
                            'assets/images/ban-user.png',
                            // color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          label: Text('Grey List',textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize,color: Colors.white,fontWeight: FontWeight.w500),)
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange.shade900,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          submitFavoriteVisitorDetails();
                        },
                        icon: Icon(Icons.add),
                        label: Text('Favorite Visitor',
                            style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize,color: Colors.white,fontWeight: FontWeight.w500),)
                      ,textAlign: TextAlign.center,),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF227C03),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ))));
  }

  // Container containerValue({
  //   required var text,
  //   required String value,
  // }) {
  //   return Container(
  //     child: Padding(
  //       padding: const EdgeInsets.all(2.0),
  //       child: Row(
  //         children: [
  //           SizedBox(
  //             width: MediaQuery.of(context).size.width / 3,
  //             child: Text(
  //               text,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //           //VerticalDivider(width: 1,),
  //           Expanded(
  //             child: Text(
  //               value,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
