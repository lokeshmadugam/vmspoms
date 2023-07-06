import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/SignInModel.dart';
import '../../model/visitorreg/FavoriteVisitors.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/visitorregistration/InviteVisitorViewModel.dart';
import 'InvitationsScreen.dart';


class FavoriteVisitorsScreen extends StatefulWidget {
  const FavoriteVisitorsScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteVisitorsScreen> createState() => _FavoriteVisitorsScreenState();
}

class _FavoriteVisitorsScreenState extends State<FavoriteVisitorsScreen> {
  var viewModel = InviteVisitorViewModel();
  var userVM = UserViewModel();

  List<FavoriteVisitorsItems> favoriteVisitorsList = [];
  int userId = 0;
  int propertyId = 0;
  String firstName = "";
  String unitNumber = '';
  String blockName = "";
  String appusagetypeName = "";
  String mobileNumber = '';
  String roleName = '';
  bool isSelected = false;
  var checkIn;
  var checkOut;
  List<FavoriteVisitorsItems> selectedItem = [];
  List<int> selectedItems = [];
  List<Permissions> permissions = [];
  @override
  void initState() {
    super.initState();
    getUserDetails();

  }
  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;


      final propertyid = value.userDetails?.propertyId;

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
        userId = userid ?? 0;
        propertyId = propertyid ?? 0;
      });
      fetchFavoriteVisitorList();
    });

  }
  //Favorite Visitors
  void fetchFavoriteVisitorList() async {
    viewModel.getFavoriteVisitors("ASC", "id", 1, 500, propertyId,userId).then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              favoriteVisitorsList = data;

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
          'Favorite Visitors',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
        body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListView.builder(
                itemCount: favoriteVisitorsList.length,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = favoriteVisitorsList[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300,
                            width: 1.0), // Add a bottom border to separate contacts
                      ),
                    ),
                    child:CheckboxListTile(
                      title: Text(
                        item.visitorName.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: selectedItems.contains(index),
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedItems.add(index); // Add the item's index to the selectedItems list
                          } else {
                            selectedItems.remove(index); // Remove the item's index from the selectedItems list
                          }
                        });
                      },
                    ),
                    // CheckboxListTile(
                    //   title: Text(
                    //     item.visitorName.toString(),
                    //     style: Theme.of(context).textTheme.bodySmall,
                    //   ),
                    //   value: selectedItems.contains(index),
                    //   checkboxShape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   onChanged: (bool? value) {
                    //     if (value == true) {
                    //       setState(() {
                    //         selectedItems.add(item); // Add the entire item object to the selectedItems list
                    //       });
                    //     } else {
                    //       setState(() {
                    //         selectedItems.remove(item); // Remove the entire item object from the selectedItems list
                    //       });
                    //     }
                    //   },
                    // ),

    //                 CheckboxListTile(
    //                     title: Text(item.visitorName.toString(), style: Theme
    //                         .of(context)
    //                         .textTheme
    //                         .bodySmall),
    //
    //                 value:isSelected,
    //                 checkboxShape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(15),
    //                 ),
    //                 onChanged: (bool? value) {
    //                   if (value == true) {
    //                     setState(() {
    //                      isSelected = true; // Select the contact
    //                     });
    //
    //                   } else {
    //
    //                   }
    //                 },
    // )

                  );
                }
                  ),

]

                  )


          ),
          ),
        ),
        floatingActionButton: SizedBox(
    height: MediaQuery.of(context).size.height * 0.04,
    width: MediaQuery.of(context).size.width * 0.20,
    child: FloatingActionButton(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25)),
    backgroundColor:Color(0xFF036CB2),
    // onPressed:selectedItems.isNotEmpty ? ()  {
    // Navigator.push(
    // context,
    // MaterialPageRoute(
    // builder: (context) => InvitationsScreen(
    // contact: null, data: permissions,favoritevisitor: selectedItems,
    // ),
    // ),
    // );
    //
    // }
    //     : null,
      onPressed: selectedItems.isNotEmpty ? () {
        List<FavoriteVisitorsItems> selectedItemsData = selectedItems
            .map((index) => favoriteVisitorsList[index])
            .toList();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InvitationsScreen(contact: null, data: permissions,favoritevisitor: selectedItemsData)),
        );

      } : null,

      child: Text('select'),
    ),
    ),
        );

  }
}
