import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/SignInModel.dart';
import '../../model/facility/FacilityTypeModel.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/facility/FacilityBookingViewModel.dart';
import 'BookFacilityScreen.dart';
import 'RuleBook.dart';

class FacilityScreen extends StatefulWidget {
  var permisssions;
  FacilityScreen({Key? key,required this.permisssions}) : super(key: key);

  @override
  State<FacilityScreen> createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {
  var userVM = UserViewModel();
  var viewModel = FacilityBookingViewModel();
  int facilityId = 0;
  String facilityName = '';
  var finalvalue;
  var image;

  String firstName = "";
  String lastName = "";
  int propertyId = 0;
  List<FacilityTypes> _facilityTypes = [];

  @override
  void initState() {
    super.initState();
    getUserDetails();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.firstName;
      firstName = userid ?? '';
      print(firstName);
      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      print(lastName);
      setState(() {
        firstName = userid ?? '';
        print(firstName);
        lastName = lastname ?? '';
        print(lastName);
      });
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      // unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      // blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      // userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      // appusagetypeId = appusagetypeid ?? 0;
      setState(() {
        fetchFacilityType();
      });

    });

  }

  void fetchFacilityType() async {
    viewModel.getFacilityType("ASC", "id", 1, 25, propertyId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          final data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _facilityTypes = data;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: _facilityTypes.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              var item = _facilityTypes[index];

              if (item == null) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    bottom: 5,
                  ),
                  child: Text(
                    "No data found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return buildNewCard(context, item,) ;

            }),
      ),
    );
  }
  Card buildNewCard(BuildContext context, FacilityTypes item) {
    return Card(
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              children: [
                
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.14,
                  child: Image.network(
                    "${item.facilityThumbnailImb ?? ""}",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  // height: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                    child: Text(
                      "${item.facilityName ?? ""}",
                      style:
    GoogleFonts.roboto(textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(item.facilityRulebook!.isNotEmpty)
                  Visibility(visible:true,child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RuleBookScreen(
                                  facilityName: item.facilityRulebook ?? '',
                                )));
                      },
                      icon: Icon(
                        Icons.info_outline,
                        color: Color(0xFF036CB2),
                      )),),


                IconButton(
                    onPressed: () {
                      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookFacilityScreen(
                                          facilityName: item.facilityName ?? '',
                                          facilityId: item.facilityId ?? 0,
                                          image: item.facilityThumbnailImb ?? '', permisssions: widget.permisssions,)));
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Color(0xFF036CB2),
                    )),

              ],
            ),
          ),
        ],
      ),
    );
  }
  // Card buildCard(FacilityTypes item, BuildContext context) {
  //   return Card(
  //                 color: Colors.white,
  //                 child: Column(
  //
  //
  //                   children: [
  //
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               SizedBox(
  //                                 width: 30,
  //                                 child: Icon(
  //                                   Icons.keyboard_arrow_right,
  //                                   size: 30,
  //                                   color: Color(0xFF036CB2),
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 width: 30,
  //                                 child: Icon(
  //                                   Icons.keyboard_arrow_right,
  //                                   size: 30,
  //                                   color: Color(0xFF036CB2),
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ));
  // }


}
