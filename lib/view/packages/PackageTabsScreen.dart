import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/SignInModel.dart';
import 'PackageExpectedScreen.dart';
import 'PackageReceivedScreen.dart';

class PackageTabsScreen extends StatefulWidget {
  var data;

  PackageTabsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _PackageTabsScreenState createState() => _PackageTabsScreenState();
}

class _PackageTabsScreenState extends State<PackageTabsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedButton = 'Expected';
  List<Permissions> permissions = [];
  bool package = false;
  bool packageReceived = false;
  var submenu;
  @override
  void initState() {
    super.initState();

    permissions = widget.data;
    actionPermissions();
  }
  void actionPermissions() async {
    setState(() {
      for (var item in permissions) {
        if ((item.moduleDisplayNameMobile == "Package Receipts") &&
            (item.parentSubMenu != null && item.parentSubMenu!.isNotEmpty)) {
          submenu = item.parentSubMenu ?? [];
          for (var item in submenu) {
            if (item.moduleDisplayNameMobile == "Package" ||
                item.moduleId == 133) {
              package = true;
              // if(item.moduleDisplayNameMobile == "EForms" || item.moduleId == 126 )
              print("Package = $package");
            } else if (item.moduleDisplayNameMobile == "Package Received" ||
                item.moduleId == 134) {
              packageReceived = true;
              print("packageReceived = $packageReceived");
            }
          }
        }
      }
    });
  }
  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case 'Expected':
        return PackageExpectedScreen(
          permissions: submenu,
        );
      case 'Received':
        return PackageReceivedScreen(
          permissions: submenu,
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
          title: Text('Packages',
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
        ),
        body: Column(children: [
          Container(
              // height: MediaQuery.of(context).size.height * 0.06,
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
                              backgroundColor: _selectedButton == 'Expected'
                                  ? Colors.white
                                  : Color(0xFF1883BD),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      bottomLeft: Radius.circular(0.0)))),
                          onPressed: () async {
                            setState(() {
                              _selectedButton = 'Expected';
                            });
                          },
                          child: Text(
                            "Expected",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: fontSize,
                                    color: _selectedButton == 'Expected'
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
                                backgroundColor: _selectedButton == 'Received'
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
                                _selectedButton = 'Received';
                              });
                            },
                            child: Text(
                              "Received",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: fontSize,
                                      color: _selectedButton == 'Received'
                                          ? Colors.black
                                          : Colors.white)),
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
