import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/eforms/DynamicList.dart';
import '../../model/eforms/EPollUserData.dart';
import '../../repository/eforms/EFormRepository.dart';
import '../../Model/PostApiResponse.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/ServiceType.dart';
import '../../model/eforms/EFormCategoryName.dart';
import '../../model/eforms/EFormUserData.dart';
import '../../model/eforms/EPollCategoryName.dart';
import '../../model/eforms/EPollDynamicList.dart';
import '../../utils/Utils.dart';

class EFormsViewModel with ChangeNotifier {
  final _myRepo = EFormRepository();

  Future<ApiResponse<EFormCategoryName>> fetchEFormCategoryNameList(
      var propertyId) async {
    ApiResponse<EFormCategoryName> categoryNameListResponse =
        ApiResponse.loading();

    try {
      final value = await _myRepo.getEFormCategoryNameList(propertyId);
      categoryNameListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        categoryNameListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return categoryNameListResponse;
  }

  Future<ApiResponse<DynamicList>> fetchDynamicFormList(
      var categoryId, var propertyId) async {
    ApiResponse<DynamicList> dynamicFormListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getDynamicFormList(categoryId, propertyId);
      dynamicFormListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        dynamicFormListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return dynamicFormListResponse;
  }

  Future<ApiResponse<ServiceType>> fetchApprovalStatus(var serviceType) async {
    ApiResponse<ServiceType> serviceListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getServiceTypes(serviceType);
      serviceListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        serviceListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return serviceListResponse;
  }

  Future<ApiResponse<EFormUserData>> fetchEFormUserDataList(var userId,
      var propertyId) async {
    ApiResponse<EFormUserData> eFormUserDataListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getEFormUserDataList(userId, propertyId);
      eFormUserDataListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        eFormUserDataListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return eFormUserDataListResponse;
  }

  Future<ApiResponse<PostApiResponse>> submitEForm(
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.submitEFormList(data);
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

  Future<ApiResponse<PostApiResponse>> updateEForm(var id,
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.updateEFormList(id, data);
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



  ////E Pollsss



  Future<ApiResponse<EPollUserData>> fetchEPollsUserDataList(var userId,
      var propertyId) async {
    ApiResponse<EPollUserData> ePollUserDataListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getEPollsUserDataList(userId, propertyId);
      ePollUserDataListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        ePollUserDataListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return ePollUserDataListResponse;
  }

  Future<ApiResponse<EPollCategoryName>> fetchEPollCategoryNameList(
      var propertyId) async {
    ApiResponse<EPollCategoryName> categoryNameListResponse =
    ApiResponse.loading();

    try {
      final value = await _myRepo.getEPollCategoryNameList(propertyId);
      categoryNameListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        categoryNameListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return categoryNameListResponse;
  }

  Future<ApiResponse<EPollDynamicList>> fetchEPollDynamicFormList(
      var categoryId, var propertyId, var userId) async {
    ApiResponse<EPollDynamicList> dynamicFormListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getEPollDynamicFormList(categoryId, propertyId,
      userId);
      dynamicFormListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        dynamicFormListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return dynamicFormListResponse;
  }

  Future<ApiResponse<PostApiResponse>> submitEPoll(
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.submitEPollList(data);
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

  Future<ApiResponse<PostApiResponse>> updateEPoll(var id,
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.updateEPollList(id, data);
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
