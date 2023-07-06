import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poms_app/view/houseRules/ReadFacilityRulesScreen.dart';
import 'package:poms_app/viewmodel/facility/FacilityBookingViewModel.dart';
import 'package:poms_app/viewmodel/houserules/HouseRulesViewModel.dart';

import '../../model/SignInModel.dart';
import '../../model/facility/FacilityTypeModel.dart';
import '../../model/houserules/HouseRulesModel.dart';
import '../../model/houserules/RulesModel.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import 'ReadRulesScreen.dart';

class HouseRulesScreen extends StatefulWidget {
  var data;

  HouseRulesScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<HouseRulesScreen> createState() => _HouseRulesScreenState();
}

class _HouseRulesScreenState extends State<HouseRulesScreen> {
  var userVM = UserViewModel();
  var viewModel = HouseRulesViewModel();
  var facilityviewModel = FacilityBookingViewModel();
  int propertyId = 0;
  int userId = 0;

  String unitNumber = " ";
  List<HouseRulesItems> _houseRulesList = [];
  List<FacilityTypes> _facilityTypes = [];
  List<RulesItems> _rulesItems = [];
  var _itemscount;

  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  bool isprint = false;
  bool isdownload = false;

  void initState() {
    super.initState();
    getUserDetails();
    permissions = widget.data;
    actionPermissions();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;
      userId = userid ?? 0;

      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";

      fetchHouseRules();
      fetchFacilityType();
    });
  }

  void actionPermissions() async {
    setState(() {
      for (var item in permissions) {
        if ((item.moduleDisplayNameMobile == "House Rules") &&
            (item.action != null && item.action!.isNotEmpty)) {
          var actions = item.action ?? [];
          for (var act in actions) {
            if (act.actionName == "Add" || act.actionId == 1) {
              iscreate = true;
              print("addbutton = $iscreate");
            } else if (act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");
            } else if (act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");
            } else if (act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");
            } else if (act.actionName == "Print" || act.actionId == 5) {
              isprint = true;
              print("print = $isprint");
            } else if (act.actionName == "Download files" ||
                act.actionId == 6) {
              isdownload = true;
              print("download = $isdownload");
            } else if (act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");
            }
          }
        }
      }
    });
  }

  Future<void> fetchHouseRules() async {
    viewModel
        .getHouseRulesList("ASC", "id", 1, 500, propertyId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _houseRulesList = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  Future<void> fetchRules(var documentId) async {
    viewModel
        .getRules("ASC", "id", 1, 500, propertyId, documentId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var count = response.data!.result!.itemCounts;
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _itemscount = count;
              _rulesItems = data;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("failed", context);
    });
  }

  void fetchFacilityType() async {
    facilityviewModel
        .getFacilityType("ASC", "id", 1, 25, propertyId)
        .then((response) {
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    if (width < 411 || height < 707) {
      fontSize = 12;
      print("SmallSize = $fontSize");
    } else {
      fontSize = 15;
      print("BigSize = $fontSize");
    }

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
                    child: Text('Back',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'House Rules',
            style: Theme.of(context).textTheme.headlineLarge,
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
                            child: Text("House Rules",
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                          ),
                        ),
                        ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _houseRulesList!.length,
                          itemBuilder: (context, index) {
                            var item = _houseRulesList![index];

                            return InkWell(
                              child: Card(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.rule_folder,
                                        color: Color(0xFF036CB2),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Text("${item.documentName}",
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                              fontSize: fontSize,
                                              color: Colors.black,
                                            ),
                                          )),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(Icons.keyboard_arrow_right),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                // fetchRules(item.id);
                                if (isview) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReadRulesScreen(
                                        data: item.id,
                                        ruleName: item.documentName,
                                        view: isview,
                                      ),
                                    ),
                                  );
                                }
                                // else {
                                //   print('Item count is zero. Cannot navigate to ReadRulesScreen.');
                                //   // Utils.flushBarErrorMessage("Item count is zero", context);
                                // }
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                                // height: MediaQuery.of(context).size.height * 0.01,
                                );
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
                            child: Text("Facility Rules",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          ),
                        ),
                        ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _facilityTypes!.length,
                          itemBuilder: (context, index) {
                            var item = _facilityTypes![index];
                            var showcard = item.facilityRulebook.toString();
                            return Column(
                              children: [
                                if (showcard.isNotEmpty && showcard != null)
                                  InkWell(
                                    child: Card(
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Image.network(
                                                "${item.facilityThumbnailImb}",
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: Text("${item.facilityName}",
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.black,
                                                  ),
                                                )),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                                Icons.keyboard_arrow_right),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      if (isview) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReadFacilityRulesScreen(
                                                        data: item
                                                            .facilityRulebook,
                                                        facilityname: item
                                                            .facilityName)));
                                      }
                                    },
                                  ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                                // height: MediaQuery.of(context).size.height * 0.01,
                                );
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ],
                    )))));
  }
}
