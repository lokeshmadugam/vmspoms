import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/MediaUpload.dart';
import '../../repository/ProfileRepo.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/PostApiResponse.dart';
import '../../utils/utils.dart';

import '../model/UpdateModel.dart';

class ProfileViewModel extends ChangeNotifier {
  final _myRepo = ProfileRepo();

  // Future<ApiResponse<dynamic>> updateProfileDetails1(int id,
  //     var data, BuildContext context) async {
  //   ApiResponse<PostApiResponse> response = ApiResponse.loading();
  //   notifyListeners();
  //   try {
  //     PostApiResponse value = await _myRepo.updateProfileDetails(id, data);
  //     response = ApiResponse.success(value);
  //     if (value.status == 200){
  //     print('response = ${value.message}');
  //     Utils.flushBarErrorMessage("${value.message}", context);
  //     final result = value.result;
  //
  //
  //     } else {
  //       Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
  //     }
  //   } catch (error) {
  //     Utils.flushBarErrorMessage(error.toString(), context);
  //     response = ApiResponse.error(error.toString());
  //   }
  //
  //   if (kDebugMode) {
  //     print(response.toString());
  //   }
  //
  //   return response;
  // }
  Future<ApiResponse<PostApiResponse>> updateProfileDetails(int id,var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    // PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.updateProfileDetails(id,data);
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
  Future<ApiResponse<MediaUpload>> mediaUpload(var imagePath, BuildContext context) async {
    ApiResponse<MediaUpload> response = ApiResponse.loading();
    notifyListeners();
    try {
      MediaUpload value = await _myRepo.mediaUpload(imagePath);
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