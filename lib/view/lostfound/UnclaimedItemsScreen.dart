import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/respose/Status.dart';
import '../../model/lostfound/UnclaimedItems.dart';
import '../../utils/CardData.dart';
import '../../utils/Popup.dart';
import '../../utils/Utils.dart';
import '../../view/lostfound/EditLostDetailsFormScreen.dart';
import '../../view/lostfound/EditUnclaimedItemsFormScreen.dart';
import '../../view/lostfound/LostDetailsFormScreen.dart';
import '../../viewmodel/lostfound/LostItemsScreenViewModel.dart';
import '../../viewmodel/lostfound/UnclaimedItemsScreenViewModel.dart';
import '../../model/SignInModel.dart';
import '../../utils/MyTextfield.dart';

class UnclaimedItemsScreen extends StatefulWidget {
  var permisssions;
  UnclaimedItemsScreen({Key? key,required this.permisssions}) : super(key: key);

  @override
  State<UnclaimedItemsScreen> createState() => _UnclaimedItemsScreenState();
}

class _UnclaimedItemsScreenState extends State<UnclaimedItemsScreen> {

  UserDetails userDetails = UserDetails();
  var token;
var viewModel = UnclaimedItemsScreenViewModel();
  List<Items>? _items = [];
  List<Items>? _searchResults = [];
  final _searchController = TextEditingController();
String firstName = '';
String lastName = '';
  List<Permissions> permissions = [];
  bool iscreate = false;
  bool isupdate = false;
  bool isdelete = false;
  bool isview = false;
  bool isupload = false;
  @override
  void initState() {
    super.initState();
    _getUserDetails();
    permissions = widget.permisssions;
    actionPermissions();
  }

  void _getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');
    Map<String, dynamic> jsonData = jsonDecode(details!);
    userDetails = SignInModel.fromJson(jsonData).userDetails!;
    token = SignInModel.fromJson(jsonData).accessToken!;
setState(() {
  firstName = userDetails.firstName ?? '';
  lastName = userDetails.lastName ?? '';
});
    Provider.of<UnclaimedItemsScreenViewModel>(context, listen: false)
        .fetchUnclaimedItemsList(userDetails.propertyId, userDetails.id);
  }
  void actionPermissions () async {

    setState(() {
      for (var item in permissions){

        if( (item.moduleDisplayNameMobile == "Lost & Found") && (item.action != null && item.action!.isNotEmpty)){
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          controller: _searchController,
                          onChanged: (value) {_runSearch(value);
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
                              builder: (context) =>
                                  EditUnclaimedItemsFormScreen(data: null, upload: isupload,)));
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Consumer<UnclaimedItemsScreenViewModel>(
                  builder: (context, model, child) {
                    if (model.unclaimedItems.data != null) {
                      //var data = model.packageReceipt.data!.result!.items;

                      _items = model.unclaimedItems.data!.result!.items;

                      if(_searchController.text.toString().isEmpty){
                        _searchResults = model.unclaimedItems.data!.result!.items;
                      }


                      return ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _searchResults!.length,
                        itemBuilder: (context, index) {
                          var item = _searchResults![index];
// if(isdelete) {
  return Dismissible(key: Key(item.id.toString()),
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
                  child: Popup(title: 'Unclaimed Items',
                    message: ' Are you sure you want to delete this id?',
                    negativeButtonText: "No",
                    onNegativePressed: () {
                      Navigator.pop(context);
                    },
                    positiveButtonText: "Yes",
                    onPositivePressed: () async {
                    if(isdelete) {
                      final response = await viewModel
                          .deletetUnclaimedItemsDetails(
                          item.id, context);

                      if (response.data!.status ==
                          200) {
                        // Update local state of widget
                        setState(() {
                          _items?.removeAt(index);
                        });
                      } else if (response.data!.result ==
                          Status.error) {
                        // Show error message to user
                        Utils.flushBarErrorMessage(
                            response.message!, context);
                      }
                    }else{
                      Utils.flushBarErrorMessage("Unable to delete the  Details", context);
                    }
                    },)
              );
            }
        );
      },
      child: buildInkWell(context, item));
// }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            // height: MediaQuery.of(context).size.height * 0.01,
                          );
                        },
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildInkWell(BuildContext context, Items item) {
    return InkWell(
                              child: Card(
                                color: Colors.grey.shade100,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.01,
                                    ),
                                    ContainerValue(
                                      text: "Found Item Name",
                                      value: ": ${item.lostUnitNo ?? ""}",
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                    ),
                                    ContainerValue(
                                      text: "Name",
                                      value: ": ${userDetails.firstName} ${userDetails.lastName}",
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                    ),
                                    ContainerValue(
                                      text: "Found Date",
                                      value: ": ${item.foundDateTime != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(item.foundDateTime ?? '')) : ''}",
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                    ),
                                    ContainerValue(
                                      text: "Location",
                                      value: ": ${item.foundLocation ?? ""}",
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.01,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if(isupdate || isview) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditUnclaimedItemsFormScreen(data: item, upload: isupload,)),
                                  );
                                }
                              },
                            );
  }




  void _runSearch(String searchTerm) {
    List<Items> results = [];
    for (var item in _items!) {
      if (item.lostLocation!.toLowerCase().contains(searchTerm.toLowerCase())
          || item.lostUnitNo!.toLowerCase().contains(searchTerm.toLowerCase())) {
        results.add(item);
      }
    }
    setState(() {
      _searchResults = results;
    });
  }

}
