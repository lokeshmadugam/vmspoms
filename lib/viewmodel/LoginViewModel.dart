

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/Model/LoginUserModel.dart';

import '../Model/LoginUserModel.dart';
import '../model/PostApiResponse.dart';
import '../data/respose/ApiResponse.dart';
import '../model/SignInModel.dart';

import '../repository/LoginRepo.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

import '../view/bottomnvgbar/BottomNavigationBarScreen.dart';
import '../viewmodel/UserViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final _myRepo = LoginRepository();
  String? message;
  ApiResponse<SignInModel> userDetails = ApiResponse.loading();

  void _setUserDetails(
      ApiResponse<SignInModel> response, BuildContext context) {
    if (response.data != null) {
      userDetails = response;
      saveUserDetails(userDetails.data, context);
      notifyListeners();
    }
  }

  Future<void> fetchUserDetails(var data, BuildContext context) async {
    _setUserDetails(ApiResponse.loading(), context);
    _myRepo
        .loginApi(data)
        .then((value) => _setUserDetails(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
        _setUserDetails(ApiResponse.error(error.toString()), context));
  }


  Future<ApiResponse<SignInModel>> fetchUserDetails1(var data, BuildContext context) async {
    ApiResponse<SignInModel> response = ApiResponse.loading();


    try {
      SignInModel value = await _myRepo.loginApi(data);
      response = ApiResponse.success(value);

      if (value.status == 201){
        if(value.userDetails != null){
          userDetails = response;
          saveUserDetails(userDetails.data, context);
          notifyListeners();
          Utils.flushBarErrorMessage("${value.mobMessage}", context);
        }
      }
        else {
        Utils.flushBarErrorMessage(" ${value.mobMessage}".toString(), context);
      }
    } catch (error) {
      Utils.flushBarErrorMessage(" ${response.data!.mobMessage}".toString(), context);
      // Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
      // Utils.flushBarErrorMessage("${response.data?.mobMessage}", context);
    }

    if (kDebugMode) {
      print(response.data!.mobMessage.toString());
    }

    return response;
  }

  Future<void> saveUserDetails(
      SignInModel? loggedUserDetails, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String details = jsonEncode(loggedUserDetails);
    prefs.setString('userDetails', details);
    String token = jsonEncode(loggedUserDetails?.accessToken);
    prefs.setString('token', token);

    // if (loggedUserDetails?.accessToken == 200) {
    // message = loggedUserDetails;
    // print(message);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => BottomNavigationBarScreen()),
    // );
    // }
  }

  Future<ApiResponse<LoginUserModel>> getLoginUserDetails(int id) async {
    ApiResponse<LoginUserModel> response = ApiResponse.loading();
    try {
      var value = await _myRepo.getLoginUserDetails(id);
      response = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        response = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return response;
  }

  Future<ApiResponse<PostApiResponse>> submitEmail(
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.submitEmail(data);
      response = ApiResponse.success(value);
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
    }

    if (kDebugMode) {
      print(response.toString());
    }

    return response;
  }
}
