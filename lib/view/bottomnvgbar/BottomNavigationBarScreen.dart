import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/view/bottomnvgbar/NotificationsScreen.dart';

import 'EmergencyServiceTabsScreen.dart';
import 'HomeScreen.dart';
import 'ProfileTabsScreen.dart';
import 'SettingsScreen.dart';
import 'NotificationsScreen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;
  final List<Color> colors = [
    Color(0xFF036CB2),
    Color(0xFF036CB2),
    Color(0xFF036CB2),
    // Colors.greenAccent,
    Color(0xFF036CB2),
    Color(0xFF036CB2),
  ];
  final List pages = [
    HomeScreen(),
    EmergencyServiceScreen(),
    NotificationsScreen(),
    ProfileTabsScreen(
      showAppBar: false,
    ),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
          child: pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          // type: BottomNavigationBarType.shifting,
          backgroundColor: colors[_selectedIndex],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue.shade100,
          unselectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.red),
          selectedLabelStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          unselectedIconTheme: IconThemeData(color: Colors.white),
          // Set the color for the selected icon

          iconSize: 25,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage(
                  'assets/images/help.png',
                ),
                color: Colors.white,
              ),
              label: 'Emergency Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notification_add,
                color: Colors.white,
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
