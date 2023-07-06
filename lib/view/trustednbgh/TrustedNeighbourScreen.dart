import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poms_app/utils/PositiveButton.dart';

import '../../data/respose/Status.dart';

import '../../model/SignInModel.dart';
import '../../model/trustednbgh/TrustedNbghListModel.dart';
import '../../model/trustednbgh/TrustedNeighboursModel.dart';
import '../../utils/CardData.dart';
import '../../utils/Colors.dart';
import '../../utils/MyTextField.dart';
import '../../utils/Popup.dart';
import '../../utils/utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/trustednbgh/TrustedNbghViewModel.dart';
import 'TrustedNgbhFormScreen.dart';

class TrustedNeighnourScreen extends StatefulWidget {
  var data;
 TrustedNeighnourScreen({Key? key,required this.data}) : super(key: key);

  @override
  State<TrustedNeighnourScreen> createState() => _TrustedNeighnourScreenState();
}

class _TrustedNeighnourScreenState extends State<TrustedNeighnourScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController trustedNeighbourController = TextEditingController();
  var userVM = UserViewModel();
  var tnViewModel = TrustedNeighbourViewModel();
  String firstName = "";
  String lastName = "";
  int userId = 0;
  int propertyId = 0;
  List<TrustedNbghItems> _trustedNbghs = [];
  List<TrustedNbghItems> _filteredNbghs = [];

  List<NeighboursItems> _getNeighbours = [];
  var apiResponse = TrustedNeighbourListModel();
  String _searchTerm = "";
  bool _showList = false;
  var items;
  List<Permissions> permissions = [];

  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  void initState() {
    super.initState();
    getUserDetails();
    permissions = widget.data;
    actionPermissions ();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id ?? 0;
      userId = userid;
      print(userId);
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      print(propertyId);
      final devicecnt = value.userDetails?.unitDeviceCnt ?? 0;
      // unitdevicecnt = devicecnt;
      final usertypeid = value.userDetails?.userType ?? 0;
      // userTypeId = usertypeid;
      final firstname = value.userDetails?.firstName;

      firstName = firstname ?? '';
      print(firstName);
      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';
      final blkName = value.userDetails?.blockName;
      final unitNum = value.userDetails?.unitNumber;

      setState(() {
        firstName = firstname ?? '';

        lastName = lastname ?? '';
        final userid = value.userDetails?.id ?? 0;
        userId = userid;
        print(userId);
        final propertyid = value.userDetails?.propertyId;
        propertyId = propertyid ?? 0;
        print(propertyId);
      });
      fetchTrustedNeighbours();
    });
  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "Trusted Neighbour") && (item.action != null && item.action!.isNotEmpty)){
          var actions = item.action ?? [];
          for (var act in actions){
            if( act.actionName == "Add" || act.actionId == 1){
              iscreate = true;
              print("addbutton = $iscreate");

            }
            else if ( act.actionName == "Edit" || act.actionId == 2) {
              isupdate = true;
              print("edit = $isupdate");

            }
            else if ( act.actionName == "Delete" || act.actionId == 3) {
              isdelete = true;
              print("delete = $isdelete");

            }
            else if ( act.actionName == "View" || act.actionId == 4) {
              isview = true;
              print("view = $isview");

            }
            else if ( act.actionName == "Upload files" || act.actionId == 7) {
              isupload = true;
              print("upload = $isupload");

            }
          }
        }
      }
    });
  }
  void fetchTrustedNeighbours() async {
    tnViewModel
        .fetchTrustedNeighboursList("ASC", "id", 1, 500, propertyId, userId)
        .then((response) {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {
            setState(() {
              _trustedNbghs = data;
              _filteredNbghs = _trustedNbghs;
            });
          }
        }
      }
    }).catchError((error) {
      Utils.flushBarErrorMessage("", context);
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
                    style:  Theme.of(context).textTheme.headlineMedium
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Trusted Neighbours',
          style:  Theme.of(context).textTheme.headlineLarge
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        child: MyTextField(
                      hintText: 'Search',
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _filteredNbghs = _trustedNbghs;
                          }

                          else {
                            var searchWords = value.toLowerCase().split(' ');
                            _filteredNbghs = _trustedNbghs.where((item) {
                              var nameWords = (item.trustedNegihbourName ?? '')
                                  .toLowerCase()
                                  .split(' ');
                              // Search based on first position or second position
                              return searchWords.any((searchWord) =>
                                  nameWords[0].contains(searchWord) ||
                                  (nameWords.length > 1 &&
                                      nameWords[1].contains(searchWord)));
                            }).toList();
                          }

                        });
                      },
                      textInputType: TextInputType.text,
                      suffixIcon: Icons.search,
                    )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  if(iscreate)
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF036CB2),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrustedNeighbourFormScreen(
                            trustedNbgh: items ?? TrustedNbghItems(),
                            displayMode: DisplayMode.Add,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ListView.builder(
                  itemCount: _filteredNbghs.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var item = _filteredNbghs[index];
                    items = item;
                    var name = item.trustedNegihbourName ?? "";
                    List<String> parts = name.split(' / ');
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

  return GestureDetector(
    // onTap: () {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => TrustedNeighbourFormScreen(trustedNbgh: item,displayMode: DisplayMode.Edit,),
    //   ),
    // );
    // },
    child: Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) async {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return Dialog(
                  shape:
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius
                          .circular(
                          10)),
                  elevation: 16,
                  child: Popup(title: 'Trusted Neighbour',
                    message: ' Are you sure you want to delete this id?',
                    negativeButtonText: "No",
                    onNegativePressed: () {
                      Navigator.pop(context);
                    },
                    positiveButtonText: "Yes",
                    onPositivePressed: () async {
    if(isdelete) {
      final response = await tnViewModel
          .deleteTrustedNeighboursData(item.id, context);

      if (response.data!.status == 200) {
        // Update local state of widget
        setState(() {
          _trustedNbghs.removeAt(index);
        });
      } else if (response.data!.result == Status.error) {
        // Show error message to user
        Utils.flushBarErrorMessage(
            response.message!, context);
      }
    }
                    },)
              );
            }
        );

      },
      child: Card(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            SizedBox(
              height:
              MediaQuery
                  .of(context)
                  .size
                  .height * 0.01,
            ),
            ContainerValue(
              text: "Name",
              value: ": ${parts[0]}",
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            ContainerValue(
              text: "Unit Number",
              value: ": ${parts[1]}",
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            ContainerValue(
              text: "Contact No.",
              value: ": ${parts[3]}",
            ),
            Divider(
              color: Colors.grey.shade400,
            ),
            ContainerValue(
              text: "Date",
              value:
              ": ${item.trneigbourAddedDatetime != null ? DateFormat(
                  'yyyy-MM-dd hh:mm a').format(
                  DateTime.parse(item.trneigbourAddedDatetime ?? '')) : ''}",
            ),
            SizedBox(
              height:
              MediaQuery
                  .of(context)
                  .size
                  .height * 0.01,
            ),
          ],
        ),
      ),
    ),
  );

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Card buildCard(BuildContext context, TrustedNbghItems item) {
    var name = item.trustedNegihbourName ?? "";
    List<String> parts = name.split(' / ');
    return Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 0.0,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.32,
                            child: Text("Name")),
                        Text(": "),
                        Expanded(
                          flex: 1,
                          child: Text("${parts[0]}"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.32,
                            child: Text("Unit Number")),
                        Text(": "),
                        Expanded(
                          flex: 1,
                          child: Text("${parts[1]}"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.32,
                            child: Text("Contact No.")),
                        Text(": "),
                        Expanded(
                          flex: 1,
                          child: Text("${parts[3]}"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.03,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.32,
                            child: Text("Date")),
                        Text(": "),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(item.trneigbourAddedDatetime.toString()))}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
