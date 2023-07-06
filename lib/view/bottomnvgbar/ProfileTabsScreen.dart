
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/view/bottomnvgbar/DigitalScreen.dart';
import '/view/bottomnvgbar/ProfileScreen.dart';

class ProfileTabsScreen extends StatefulWidget {
  final bool showAppBar;

  ProfileTabsScreen({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  State<ProfileTabsScreen> createState() => _ProfileTabsScreenState();
}

class _ProfileTabsScreenState extends State<ProfileTabsScreen> {
  String _selectedButton = 'My QR Code';
  bool showAppBar = false;

  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case 'My QR Code':
        return DigitalScreen();
      case 'My Profile':
        return ProfileScreen();

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
      print("SmallSize = $fontSize");
    }else {
      fontSize = 16;
      print("BigSize = $fontSize");
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: widget.showAppBar,
          leadingWidth: 90,
          leading: widget.showAppBar
              ? Row(
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
          )
              : null,
          centerTitle: true,
          title: Text(
            'My Profile',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
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
                          primary: _selectedButton == 'My QR Code'
                              ? Colors.white
                              : Color(0xFF1883BD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35.0),
                                bottomLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                              ))),
                      onPressed: () async {
                        setState(() {
                          _selectedButton = 'My QR Code';
                        });
                      },
                      child: Text(
                        "My QR Code",
                        style: GoogleFonts.roboto(textStyle: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                          color: _selectedButton == "My QR Code"
                              ? Colors.black
                              : Colors.white,
                        ),)
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: _selectedButton == 'My Profile'
                                ? Colors.white
                                : Color(0xFF1883BD),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(35),
                                    bottomLeft: Radius.circular(0.0)))),
                        onPressed: () async {
                          setState(() {
                            _selectedButton = 'My Profile';
                          });
                        },
                        child: Text(
                          "My Profile",
                          style: GoogleFonts.roboto(textStyle:TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: _selectedButton == "My Profile"
                                ? Colors.black
                                : Colors.white,
                          ),
                          )
                        ),
                      ),
                    ),
                  ),
                ]),
              )),
          Expanded(child: _getSelectedScreen()),
        ]));
  }
}
