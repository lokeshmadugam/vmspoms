import 'package:flutter/material.dart';
import 'package:poms_app/utils/CardData.dart';
import 'package:provider/provider.dart';

import '../../model/visitorreg/GetAllParkings.dart';
import '../../model/visitorreg/ParkingTypeModel.dart';
import '../../utils/MyDropdown.dart';
import '../../utils/Utils.dart';
import '../../viewmodel/UserViewModel.dart';
import '../../viewmodel/visitorregistration/ParkingViewModel.dart';



class ParkingScreen extends StatefulWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  var userVM = UserViewModel();

  var parkingVM = ParkingViewModel();
  String blockName = "";
  int userId = 0;
  int propertyId = 0;
  int unitDeviceCnt = 0;
  String unitNumber = " ";
  int userTypeId = 0;
  int appusagetypeId = 0;
  String firstName = "";
  String lastName = "";
  List<ParkingTypeItems> parkingTypeItems = [];


  var selectedBayTypeName;
  var selectedBayId ;
  bool _isBayTypeVisible = false;
  bool _isParkingStatus = false;
  // List<dynamic> combinedData = [];
  String selectedOption = '';
  List<String> filteredNames = [];
  List<ParkingTypeItems> filteredBayTypes = [];
  bool isSelected = false;
  var selectedStatus;
  List <dynamic> originalFilteredData = [];
  List<dynamic> filteredData = [];
  bool showFullListView = false;
  @override
  void initState() {

    super.initState();
    getUserDetails();

  }
  Future<void> getUserDetails() async {
    userVM.getUserDetails().then((value) {
      final userid = value.userDetails?.id;

      userId = userid ?? 0;
      final propertyid = value.userDetails?.propertyId;
      propertyId = propertyid ?? 0;
      final unitdevicecnt = value.userDetails?.unitDeviceCnt;
      unitDeviceCnt = unitdevicecnt ?? 0;
      final unitnmb = value.userDetails?.unitNumber;
      unitNumber = unitnmb ?? " ";
      final blockname = value.userDetails?.blockName;
      blockName = blockname ?? "";
      final usertypeId = value.userDetails?.userType;
      userTypeId = usertypeId ?? 0;
      final appusagetypeid = value.userDetails?.appUsageTypeId;
      appusagetypeId = appusagetypeid ?? 0;
      final name = value.userDetails?.firstName;
      final userType = value.userDetails?.appUserTypeName;
      firstName = name ?? '';

      final lastname = value.userDetails?.lastName;
      lastName = lastname ?? '';

      fetchParkingData();
      fetchAllParkingData(" ");
    });
  }
  Future <void>  fetchParkingData() async {
    parkingVM
        .getParkingType(
      "ASC",
      "id",
      1,
      50,
      propertyId,

    )
        .then((response) async {
      if (response.data?.status == 200) {
        if (response.data?.result != null) {
          var data = response.data!.result!.items;
          if (data != null) {

            setState(() {
              parkingTypeItems = data;
              for (var item in data) {
                String bayTypeNames = item.bayTypeName ?? '';
                var types = (bayTypeNames == "Managment Parking" ||
                    bayTypeNames == "Shops / offices Parking" ||
                    bayTypeNames == "Visitors Parking");

                int bayid = item.bayType ?? 0;
                var id = (bayid == 257 || bayid == 259 || bayid == 260);

                if (types && id) {
                  filteredBayTypes.add(item);
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

  Future <void>  fetchAllParkingData(var bayId) async {
    parkingVM
        .getAllParkings(
      bayId,
      "ASC",
      "id",
      1,
      50,
      propertyId,

    )
        .then((response) async {
      if (response.data?.status == 200) {
        if (response.data?.unOccupied != null || response.data?.occupied != null) {
          var unOccupiedItems = response.data?.unOccupied ?? [];
          var occupiedItems = response.data?.occupied ?? [];
setState(() {

  originalFilteredData = [...unOccupiedItems, ...occupiedItems];
});


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
          'Available Parking',
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

            child:


              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(_isBayTypeVisible ? Icons.filter_list : Icons.filter_list),
                  color: _isParkingStatus ? Colors.green : Colors.red,
                  onPressed: () {
                    setState(() {
                      _isParkingStatus = !_isParkingStatus;
                      _isBayTypeVisible = !_isBayTypeVisible;

                      if (!_isParkingStatus && !_isBayTypeVisible) {
                        // Both Bay Type and Parking Status are not visible, show the full filtered data list view
                        showFullListView = true;
                      } else {
                        // Update the filtered data based on the selected status and bay type
                        showFullListView = false;
                        fetchAllParkingData(" ");
                      }

                    });
                  },
                ),
                if (_isBayTypeVisible)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Par.Status',
                        labelText: 'Par.Status',
                      ),
                      value: selectedStatus, // Set the value to the currently selected value
                      onChanged: (newValue) {
                        setState(() {
                          selectedStatus = newValue!;

                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Occupied',
                          child: Text('Occupied'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Unoccupied',
                          child: Text('Unoccupied'),
                        ),
                      ],
                    ),
                  ),
                if (!_isBayTypeVisible)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: MyDropDown(
                      hintText: 'Bay Type',
                      labelText: 'Bay Type',
                      value: null,
                      items: filteredBayTypes
                          .map((item) => item.bayTypeName)
                          .map((deliveryServName) => DropdownMenuItem<String>(
                        key: ValueKey(deliveryServName),
                        value: deliveryServName,
                        child: Text(deliveryServName!),
                      ))
                          .toList(),
                      onchanged: (value) {
                        for (int i = 0; i < filteredBayTypes.length; i++) {
                          if (value == filteredBayTypes[i].bayTypeName) {
                            selectedBayId = filteredBayTypes[i].bayType;
                            final Id = selectedBayId.toString();
                            if (Id.isNotEmpty) {
                              setState(() {
                                fetchAllParkingData(Id);
                              });
                            }
                            break;
                          }
                        }
                      },
                    ),
                  ),
              ],
            )


            ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child:

                  ListView.builder(
                    itemCount: originalFilteredData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (showFullListView || selectedStatus == null) {
                        // Show the full filtered data list view or no status is selected, show all items
                        var item = originalFilteredData[index];

                        if (item is UnOccupied) {
                          return buildCardUnoccupied(item, context);
                        } else if (item is Occupied) {
                          return buildCardOccupied(item, context);
                        }
                      } else {
                        // A status is selected, show items based on the selected status
                        var filteredList = selectedStatus == 'Unoccupied'
                            ? originalFilteredData.whereType<UnOccupied>().toList()
                            : originalFilteredData.whereType<Occupied>().toList();

                        if (index >= 0 && index < filteredList.length) {
                          var filteredItem = filteredList[index];

                          if (selectedStatus == 'Unoccupied' && filteredItem is UnOccupied) {
                            return buildCardUnoccupied(filteredItem, context);
                          } else if (selectedStatus == 'Occupied' && filteredItem is Occupied) {
                            return buildCardOccupied(filteredItem, context);
                          }
                        }
                      }

                      // Return an empty SizedBox if the item does not match the selected status or filtered list is empty
                      if (index == 0 && (showFullListView || originalFilteredData.isEmpty)) {
                        return Center(child: Text('No items found'));
                      }
                      return SizedBox();
                    },

                  )


                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card buildCardOccupied(item, BuildContext context) {
    return Card(
                        child: Column(
                          children: [
                            ContainerValue(
                              text: "Unit No.",
                              value: ": ${item.unitNo ?? ""}",
                            ),
                            Divider(
                              color: Colors.grey.shade400,
                            ),
                            ContainerValue(
                              text: "Parking Bay",
                              value: ": ${item.lotNumber ?? ''}",
                            ),
                            Divider(
                              color: Colors.grey.shade400,
                            ),
                            ContainerValue(
                              text: "Parking Status",
                              value: ": ${item.bayStatusName ?? ''}",
                            ),

                            Divider(
                              color: Colors.grey.shade400,
                            ),
                            ContainerValue(
                              text: "BayTypeName",
                              value: ": ${item.bayTypeName ?? ''}",
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                          ],
                        ),
                      );
  }

  Card buildCardUnoccupied(item, BuildContext context) {
    return
      Card(
                        child: CheckboxListTile(
                          title: Column(
                            children: [
                              ContainerValue(
                                text: "Unit No.",
                                value: ": ${item.unitNo ?? ""}",
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              ContainerValue(
                                text: "Parking Bay",
                                value: ": ${item.bayNumber ?? ''}",
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                              ContainerValue(
                                text: "Parking Location",
                                value: ": ${item.bayLocation ?? ''}",
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height * 0.01,
                              // ),

                            ],
                          ),

                          value: isSelected,
      dense: true,

                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),

                          activeColor: Colors.grey.shade50,
                          // contentPadding: EdgeInsets.all(0),
                          onChanged: (bool? value) {
                            setState(() {
                              isSelected = value ?? false;
                              if (isSelected) {
                                Navigator.pop(context, {
                                  'bayNumber': item.bayNumber,
                                  'bayType': item.bayType,
                                });
                              } else {
                                // Handle the case when the checkbox is unchecked
                              }
                            });
                          },
                        ),
                      );
  }

}
class CenteredCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CenteredCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: value
              ? Icon(
            Icons.check,
            size: 16,
            color: Colors.grey.shade400,
          )
              : SizedBox(),
        ),
      ),
    );
  }
}
