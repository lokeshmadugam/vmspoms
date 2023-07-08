import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../view/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/SignInModel.dart';
import '../../view/bottomnvgbar/BottomNavigationBarScreen.dart';

class SplashServices {
  Future<void> getUserDetails(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');

    if (details != null) {
      Map<String, dynamic> jsonData = jsonDecode(details);
      SignInModel userDetails = SignInModel.fromJson(jsonData);
      if (userDetails.accessToken != null) {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationBarScreen()),
        );
      }
    } else {
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
