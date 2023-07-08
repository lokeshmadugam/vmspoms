import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/SignInModel.dart';
import '../../view/securityrounds/SecurityDetailsMapScreen.dart';
import '../../view/securityrounds/SecurityViewDetailsListingsScreen.dart';
import '../../view/securityrounds/SecurityChecksScreen.dart';

class SecurityTabsScreen extends StatefulWidget {
  var data;

  SecurityTabsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _SecurityTabsScreenState createState() => _SecurityTabsScreenState();
}

class _SecurityTabsScreenState extends State<SecurityTabsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedButton = 'Security Checks';

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
      case 'Security Checks':
        return SecurityChecksScreen(
          permisssions: permissions,
        );
      case 'View Details':
        return SecurityViewDetailsListingsScreen(
          permisssions: permissions,
        );

      default:
        return Container(); // Return a default screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double? fontSize;
    if (width < 411 || height < 707) {
      fontSize = 14;
    } else {
      fontSize = 16;
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
          title: Text('Security Rounds',
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
        ),
        body: Column(children: [
          Container(
              color: Color(0xFF036CB2),
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _selectedButton == 'Security Checks'
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
                          _selectedButton = 'Security Checks';
                        });
                      },
                      child: Text(
                        "Security Checks",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: fontSize,
                                color: _selectedButton == "Security Checks"
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
                          primary: _selectedButton == 'View Details'
                              ? Colors.white
                              : Color(0xFF1883BD),
                          // Color(0xFF54C9F3)
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
                            _selectedButton = 'View Details';
                          });
                        },
                        child: Text("View Details",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontSize: fontSize,
                                  color: _selectedButton == "View Details"
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
