import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodel/ManagementSecurityViewModel.dart';
import '../../utils/Utils.dart';
import '../../view/clockinclockout/AttendanceListingsScreen.dart';
import '../../view/clockinclockout/ClockInClockOutScreen.dart';
import '../../view/managementservices/ManagementOfficeListingsScreen.dart';
import '../../view/managementservices/SecurityOfficeListingsScreen.dart';

class ManagementServicesTabScreen extends StatefulWidget {
  @override
  _ManagementServicesTabScreenState createState() =>
      _ManagementServicesTabScreenState();
}

class _ManagementServicesTabScreenState
    extends State<ManagementServicesTabScreen>
    with SingleTickerProviderStateMixin {
  String _selectedButton = 'Management Office';

  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case 'Management Office':
        return ManagementOfficeListingsScreen();
      case 'Security Office':
        return SecurityOfficeListingsScreen();

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
          title: Text('Management Services',
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
                              backgroundColor:
                                  _selectedButton == 'Management Office'
                                      ? Colors.white
                                      : Color(0xFF1883BD),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      bottomLeft: Radius.circular(0.0)))),
                          onPressed: () async {
                            setState(() {
                              _selectedButton = 'Management Office';
                            });
                          },
                          child: Text(
                            "Management Office",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: fontSize,
                                    color:
                                        _selectedButton == "Management Office"
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
                                    _selectedButton == 'Security Office'
                                        ? Colors.white
                                        : Color(0xFF1883BD),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(35.0),
                                  bottomRight: Radius.circular(0.0),
                                ))),
                            onPressed: () async {
                              setState(() {
                                _selectedButton = 'Security Office';
                              });
                            },
                            child: Text("Security Office",
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: fontSize,
                                      color:
                                          _selectedButton == "Security Office"
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
