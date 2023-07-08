import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/SignInModel.dart';
import '../../view/lostfound/LostItemsScreen.dart';
import '../../view/lostfound/UnclaimedItemsScreen.dart';
import '../../view/securityrounds/SecurityChecksScreen.dart';
import '../../view/securityrounds/SecurityViewDetailsScreen.dart';

class LostFoundTabsScreen extends StatefulWidget {
  var data;

  LostFoundTabsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _LostFoundTabsScreenState createState() => _LostFoundTabsScreenState();
}

class _LostFoundTabsScreenState extends State<LostFoundTabsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedButton = 'Lost Items';
  List<Permissions> permissions = [];

  void initState() {
    super.initState();

    permissions = widget.data;
    // for (var item in permissions){
    //   print(item.moduleDisplayNameMobile);
    // }
  }

  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case 'Lost Items':
        return LostItemsScreen(
          permisssions: widget.data,
        );
      case 'Unclaimed Items':
        return UnclaimedItemsScreen(
          permisssions: widget.data,
        );

      default:
        return Container(); // Return a default screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print("Wid = $width");
    print("hei = $height");
    double? fontSize;
    if (width < 411 || height < 707) {
      fontSize = 14;
      print("SmallSize = $fontSize");
    } else {
      fontSize = 16;
      print("BigSize = $fontSize");
    }
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 90,
          elevation: 0.0,
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
          title: Text('Lost & Found',
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
        ),
        body: Column(children: [
          Container(
              alignment: Alignment.bottomCenter,
              color: Color(0xFF036CB2),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedButton == 'Lost Items'
                                ? Colors.white
                                : Color(0xFF1883BD),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(35),
                                    bottomLeft: Radius.circular(0.0))),
                            // side: BorderSide(width: 1.0,color: Colors.grey),
                          ),
                          onPressed: () async {
                            setState(() {
                              _selectedButton = 'Lost Items';
                            });
                          },
                          child: Text(
                            "Lost Items",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: fontSize,
                                    color: _selectedButton == "Lost Items"
                                        ? Colors.black
                                        : Colors.white)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width / 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _selectedButton == 'Unclaimed Items'
                                      ? Colors.white
                                      : Color(0xFF1883BD),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0),
                                topRight: Radius.circular(35.0),
                                bottomRight: Radius.circular(0.0),
                              )),
                              // side: BorderSide(width: 1.0,color: Colors.grey),
                            ),
                            onPressed: () async {
                              setState(() {
                                _selectedButton = 'Unclaimed Items';
                              });
                            },
                            child: Text("Unclaimed Items",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: fontSize,
                                      color:
                                          _selectedButton == "Unclaimed Items"
                                              ? Colors.black
                                              : Colors.white),
                                )),
                          ),
                        ),
                      )
                    ]),
              )),
          Expanded(child: _getSelectedScreen()),
        ]));
  }
}
