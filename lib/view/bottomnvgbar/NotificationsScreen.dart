import 'package:flutter/material.dart';
import 'package:poms_app/view/announcements/AnnouncementScreen.dart';

import '../notifications/AnnouncementsListingsScreen.dart';
import '../notifications/NotificationsListingsScreen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedButton = 'Notifications';

  Widget _getSelectedScreen() {
    switch (_selectedButton) {
      case 'Notifications':
        return NotificationsListingsScreen();
      case 'Announcements':
        return AnnouncementsScreen();

      default:
        return Container(); // Return a default screen
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


          leadingWidth: 90,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text(
            'Notificatons',
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
                                style: TextStyle(fontSize: 14, color: _selectedButton == 'Notifications' ?Colors.black :Colors.white),
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
            ])
    );
  }
}
