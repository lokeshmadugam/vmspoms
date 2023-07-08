// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import '../model/SignInModel.dart';
// import '../data/respose/Status.dart';
// import '../data/AppException.dart';
// // import '../model/signinmodel.dart';
// // import '../utils/routes/routes_name.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../utils/routes/routes_name.dart';
//
//
// class UserViewModel with ChangeNotifier {
//
//
//   Future<void> saveUserDetails(SignInModel? loggedUserDetails, BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String details = jsonEncode(loggedUserDetails);
//     prefs.setString('userDetails', details);
//
//     // if (loggedUserDetails?.status == 200) {
//     //   // Navigator.of(context).pushReplacement(CupertinoPageRoute(
//     //   //   builder: (context) {
//     //   //     return HomeScreen();
//     //   //   },
//     //   // ));
//     // }
//   }
//   Future<SignInModel> getUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? details = prefs.getString('userDetails');
//
//
//     if(details !=null){
//       Map<String, dynamic> jsonData = jsonDecode(details);
//       SignInModel userDetails = SignInModel.fromJson(jsonData);
//       return userDetails;
//       }
//      else {
//  return   throw FetchDataException(message: "No details found");;
//     }
//   }
//
//
//   Future<void> saveLogin1Data(Map<String, dynamic>SignInModel) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('SignInModel', json.encode(SignInModel));
//   }
//
//
//
//
//
//
//
//
//
//   //Get the user value using shared preferences
//
//
//
//   Future<bool> removeUser(BuildContext context) async {
//     final SharedPreferences sp = await SharedPreferences.getInstance();
//     sp.remove("accessToken");
//     sp.remove("message");
//     sp.remove("status");
//     sp.remove("userDetails");
//     sp.clear();
//     Navigator.pushNamed(context, RoutesName.login);
//     return true;
//   }
// }
/*
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/SignInModel.dart';
import '../data/respose/Status.dart';
import '../data/AppException.dart';

// import '../model/signinmodel.dart';
// import '../utils/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/routes/routes_name.dart';
import '../view/LoginScreen.dart';

class UserViewModel with ChangeNotifier {
  Future<void> saveUserDetails(
      SignInModel? loggedUserDetails, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String details = jsonEncode(loggedUserDetails);
    prefs.setString('userDetails', details);

    // if (loggedUserDetails?.status == 200) {
    //   // Navigator.of(context).pushReplacement(CupertinoPageRoute(
    //   //   builder: (context) {
    //   //     return HomeScreen();
    //   //   },
    //   // ));
    // }
  }

  Future<SignInModel> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');

    if (details != null) {
      Map<String, dynamic> jsonData = jsonDecode(details);
      SignInModel userDetails = SignInModel.fromJson(jsonData);
      return userDetails;
    } else {
      return throw FetchDataException(message: "No details found");
      ;
    }
  }

  Future<void> saveLogin1Data(Map<String, dynamic> SignInModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('SignInModel', json.encode(SignInModel));
  }

  //Get the user value using shared preferences

  Future<bool> removeUser(BuildContext context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("accessToken");
    sp.remove("message");
    sp.remove("status");
    sp.remove("userDetails");
    //sp.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    return true;
  }
}*/
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/SignInModel.dart';
import '../data/respose/Status.dart';
import '../data/AppException.dart';

// import '../model/signinmodel.dart';
// import '../utils/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/routes/routes_name.dart';
import '../view/LoginScreen.dart';

class UserViewModel with ChangeNotifier {
  Future<void> saveUserDetails(
      SignInModel? loggedUserDetails, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String details = jsonEncode(loggedUserDetails);
    prefs.setString('userDetails', details);
    prefs.setInt('roundsId', 0);

    // if (loggedUserDetails?.status == 200) {
    //   // Navigator.of(context).pushReplacement(CupertinoPageRoute(
    //   //   builder: (context) {
    //   //     return HomeScreen();
    //   //   },
    //   // ));
    // }
  }

  Future<SignInModel> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? details = prefs.getString('userDetails');

    if (details != null) {
      Map<String, dynamic> jsonData = jsonDecode(details);
      SignInModel userDetails = SignInModel.fromJson(jsonData);
      return userDetails;
    } else {
      return throw FetchDataException(message: "No details found");
      ;
    }
  }

  Future<void> saveLogin1Data(Map<String, dynamic> SignInModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('SignInModel', json.encode(SignInModel));
  }

  //Get the user value using shared preferences

  Future<bool> removeUser(BuildContext context) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove("accessToken");
    sp.remove("message");
    sp.remove("status");
    sp.remove("userDetails");
    //sp.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    return true;
  }
}
