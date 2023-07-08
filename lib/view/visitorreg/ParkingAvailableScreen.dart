import 'package:flutter/material.dart';
import '/utils/CardData.dart';

import '../../model/visitorreg/ParkingModel.dart';

class ParkingAvailableScreen extends StatefulWidget {
  var data;

  ParkingAvailableScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ParkingAvailableScreen> createState() => _ParkingAvailableScreenState();
}

class _ParkingAvailableScreenState extends State<ParkingAvailableScreen> {
  @override
  List<ParkingItem> parkingItems = [];
  bool isSelected = false;

  void initState() {
    // _tabController = TabController(length: 2, vsync: this);
    super.initState();
    if (widget.data != null) {
      parkingItems = widget.data;
    }
  }

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
                  child: Text('Back',
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ),
            ),
          ],
        ),
        title: Text('Parking Available',
            style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: Color(0xFF036CB2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: ListView.builder(
                      itemCount: parkingItems.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var item = parkingItems[index];
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
                        return Card(
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
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                // Divider(
                                //   color: Colors.grey.shade400,
                                // ),
                                // containerValue(
                                //   text: "Status",
                                //   value: ": Available ",
                                // )
                              ],
                            ),
                            value: isSelected,
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            activeColor: Colors.grey.shade50,
                            contentPadding: EdgeInsets.all(0),
                            onChanged: (bool? value) {
                              setState(() {
                                isSelected = value ?? false;
                                if (isSelected) {
                                  Navigator.pop(context, {
                                    'bayNumber': item.bayNumber,
                                    'bayType': item.bayType
                                  });
                                } else {
                                  // Handle the case when the checkbox is unchecked
                                }
                              });
                            },
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
