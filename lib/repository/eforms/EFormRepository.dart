import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/DeleteResponse.dart';
import '../../model/eforms/DynamicList.dart';
import '../../model/eforms/EFormCategoryName.dart';
import '../../model/eforms/EFormUserData.dart';
import '../../model/eforms/EPollDynamicList.dart';
import '../../Model/PostApiResponse.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/ServiceType.dart';
import '../../model/eforms/EPollCategoryName.dart';
import '../../model/eforms/EPollUserData.dart';
import '../../resources/AppUrl.dart';

class EFormRepository {
  final BaseApiServices _apiService = NetworkApiService();

  Future<dynamic> getEFormCategoryNameList(var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'propertyId': propertyId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.eFormCategoryNames;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = EFormCategoryName.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getDynamicFormList(var categoryId, var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'category_id': categoryId.toString(),
        'property_id': propertyId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.dynamicFormList;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = DynamicList.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getEFormUserDataList(var userId, var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'propertyId': propertyId.toString(),
        //'user_id': userId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.EFormUserData;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = EFormUserData.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getServiceTypes(var serviceType) async {
    try {
      Map<String, String> queryParameters = {
        'configKey': serviceType.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.configItemsUrl;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = ServiceType.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitEFormList(var data) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitEForm);

      dynamic response = await _apiService.postApiResponsewithtoken(url,
          token, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateEFormList(var id, var data) async {

    String userFormId = id.toString();
    String query = "/$userFormId";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitEForm);

      dynamic response = await _apiService.putApiResponsewithtoken(url,
          token, data, query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }


  /////E Pollsss


  Future<dynamic> getEPollsUserDataList(var userId, var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'propertyId': propertyId.toString(),
        'user_id': userId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.EPollUserData;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = EPollUserData.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getEPollCategoryNameList(var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'propertyId': propertyId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.ePollCategoryNames;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = EPollCategoryName.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getEPollDynamicFormList(var categoryId, var propertyId,
      var userId) async {
    try {
      Map<String, String> queryParameters = {
        'category_id': categoryId.toString(),
        'property_id': propertyId.toString(),
        'user_id': userId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.ePollDynamicList;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = EPollDynamicList.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitEPollList(var data) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitEPoll);

      dynamic response = await _apiService.postApiResponsewithtoken(url,
          token, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateEPollList(var id, var data) async {

    String userFormId = id.toString();
    String query = "/$userFormId";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitEPoll);

      dynamic response = await _apiService.putApiResponsewithtoken(url,
          token, data, query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

}
