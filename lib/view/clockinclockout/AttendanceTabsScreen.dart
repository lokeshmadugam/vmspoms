import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/SignInModel.dart';
import '../../view/clockinclockout/AttendanceListingsScreen.dart';
import '../../view/clockinclockout/ClockInClockOutScreen.dart';


class AttendanceTabsScreen extends StatefulWidget {
  var data;
  AttendanceTabsScreen({Key? key,required this.data}) : super(key: key);
  @override
  _AttendanceTabsScreenState createState() => _AttendanceTabsScreenState();
}

class _AttendanceTabsScreenState extends State<AttendanceTabsScreen> with SingleTickerProviderStateMixin {

  String _selectedButton = 'Clock-In/Clock-Out';
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
      case 'Clock-In/Clock-Out':
        return ClockInClockOutScreen(permissions: permissions,);
      case 'Attendance':
        return AttendanceListingsScreen(permissions: permissions,);

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
      fontSize = 14;

    }else {
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
            'Clock-In/Clock-Out',
            style: Theme.of(context).textTheme.headlineLarge
            // TextStyle(
            //     fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedButton == 'Clock-In/Clock-Out'
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
                          _selectedButton = 'Clock-In/Clock-Out';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Clock-In/Clock-Out", softWrap: true, textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize, color: _selectedButton == "Clock-In/Clock-Out" ? Colors.black : Colors.white, ),)
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedButton == 'Attendance'
                                ? Colors.white
                                : Color(0xFF1883BD),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  bottomLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(35.0),
                                  bottomRight: Radius.circular(0.0),
                                ),


                            ),
                          // side: BorderSide(width: 1.0,color: Colors.grey),
                        ),
                        onPressed: () async {
                          setState(() {
                            _selectedButton = 'Attendance';
                          });
                        },
                        child: Text(
                          "Attendance", softWrap: true, textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: fontSize, color: _selectedButton == "Attendance" ? Colors.black : Colors.white,),)
                        ),
                      ),
                    ),
                  )
                ]),
              )),
          Expanded(child: _getSelectedScreen()),
        ]));
  }
}