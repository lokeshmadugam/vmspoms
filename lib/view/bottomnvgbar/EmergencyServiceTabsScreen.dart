import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poms_app/view/PublicServicesScreen.dart';
import 'package:poms_app/view/bottomnvgbar/EmergencyServicesScreen.dart';
import 'package:poms_app/view/managementservices/ManagementServicesTabScreen.dart';

import '../managementservices/SecurityOfficeListingsScreen.dart';
import 'EmergencyPhoneNumbersScreen.dart';
import 'ManagementSecurityScreen.dart';
import 'dart:ui' as ui;
class EmergencyServiceScreen extends StatefulWidget {
  const EmergencyServiceScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyServiceScreen> createState() => _EmergencyServiceScreenState();
}

class _EmergencyServiceScreenState extends State<EmergencyServiceScreen> {


  String _selectedButton = 'Emergency Services';

  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case 'Emergency Services':
        return EmergenncyServicesScreen();
      case 'Important Phone no':
        return EmergencyPhoneNumbersScreen();
      case 'Mgmt. Office':
        return ManagementSecurityScreen();
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
    if(width < 411 || height < 707){
      fontSize = 11;
      print("SmallSize = $fontSize");
    }else {
      fontSize = 14;
      print("BigSize = $fontSize");
    }


    return Scaffold(
      appBar: AppBar(


          elevation: 0.0,
        automaticallyImplyLeading: false,

          title: AutoSizeText(
            'Emergency Services',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2)
      ),
        body: Column(
            children: [
              Container(
                  alignment: Alignment.bottomCenter,
                  color: Color(0xFF036CB2),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              // width: MediaQuery.of(context).size.width *0.30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedButton == "Emergency Services"
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
                                    _selectedButton = "Emergency Services";
                                  });
                                },
                                child: Text(
                                  "Emergency Services", softWrap: true, textAlign: TextAlign.center,maxLines: 2,

                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: fontSize,

                                      color: _selectedButton == "Emergency Services" ? Colors.black : Colors.white,
                                    ),
                                  ),
                                  // style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: _selectedButton == "Emergency Services" ? Colors.black : Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              // width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedButton == 'Important Phone no'
                                      ? Colors.white
                                      : Color(0xFF1883BD),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0),
                                        bottomRight: Radius.circular(0.0),
                                      )),
                                  // side: BorderSide(width: 1.0,color: Colors.grey),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _selectedButton = 'Important Phone no';
                                  });
                                },
                                child: Text(
                                  "Important Phone no", softWrap: true, textAlign: TextAlign.center,maxLines: 2,
                                  style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: _selectedButton == "Important Phone no" ? Colors.black : Colors.white) ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              // width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedButton == 'Mgmt. Office'
                                      ? Colors.white
                                      : Color(0xFF1883BD),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0.0),
                                        bottomLeft: Radius.circular(0.0),
                                        topRight: Radius.circular(0.0),
                                        bottomRight: Radius.circular(0.0),
                                      )),
                                  // side: BorderSide(width: 1.0,color: Colors.grey),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) =>ManagementServicesTabScreen() ));
                                    _selectedButton = 'Mgmt. Office';
                                  });
                                },
                                child: Text(
                                  "Mgmt. Office", softWrap: true, textAlign: TextAlign.center,maxLines: 2,
                                  style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: _selectedButton == "Mgmt. Office" ? Colors.black : Colors.white) ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              // width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedButton == 'Security Office'
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
                                    _selectedButton = 'Security Office';
                                  });
                                },
                                child: Text(
                                  "Security Office", softWrap: true, textAlign: TextAlign.center,maxLines: 2,
                                  style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: fontSize, color: _selectedButton == "Security Office" ? Colors.black : Colors.white) ),
                                ),
                              ),
                            ),
                          )
                        ]),
                  )),
              Expanded(child: _getSelectedScreen()),
            ])
    );
  }
}
