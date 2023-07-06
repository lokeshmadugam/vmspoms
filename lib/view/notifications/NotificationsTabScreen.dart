import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../view/notifications/AnnouncementsListingsScreen.dart';
import '../../view/notifications/NotificationsListingsScreen.dart';


class NotificationsTabScreen extends StatefulWidget {
  @override
  _NotificationsTabScreenState createState() => _NotificationsTabScreenState();
}

class _NotificationsTabScreenState extends State<NotificationsTabScreen> with SingleTickerProviderStateMixin {

  String _selectedButton = 'Notifications';

  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case 'Notifications':
        return NotificationsListingsScreen();
      case 'Announcements':
        return AnnouncementsListingsScreen();

      default:
        return Container(); // Return a default screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                      style: TextStyle(
                        fontSize: 16, // reduce the font size
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'Notifications',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF036CB2),
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
                                  backgroundColor: _selectedButton == 'Notifications'
                                      ? Colors.white
                                      : Color(0xFF1883BD),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(35),
                                          bottomLeft: Radius.circular(0.0)))),
                              onPressed: () async {
                                setState(() {
                                  _selectedButton = 'Notifications';
                                });
                              },
                              child: Text(
                                "Notifications", softWrap: true, textAlign: TextAlign.center,
                                style: TextStyle(fontSize: fontSize, color: _selectedButton == 'Notifications' ?Colors.black :Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedButton == 'Announcements'
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
                                    _selectedButton = 'Announcements';
                                  });
                                },
                                child: Text(
                                  "Announcements", softWrap: true, textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: _selectedButton == 'Announcements' ?Colors.black :Colors.white),
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