import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/DeleteResponse.dart';
import '../../model/damagescomplaints/Complaints.dart';
import '../../model/damagescomplaints/ManagementOffice.dart';
import '../../Model/PostApiResponse.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/ServiceType.dart';
import '../../resources/AppUrl.dart';

class ComplaintsRepo {
  final BaseApiServices _apiService = NetworkApiService();

  Future<dynamic> getComplaintsList(var propertyId, var userId) async {
    try {
      Map<String, String> queryParameters = {
        'propertyId': propertyId.toString(),
        'user_id': userId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.complaints;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = Complaints.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getComplaintTypes(var configKey) async {
    try {
      Map<String, String> queryParameters = {
        'configKey': configKey.toString(),
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

  Future<dynamic> getComplaintAssignedToItems(var appUserTypeId, var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'app_user_id': appUserTypeId.toString(),
        'property_id': propertyId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.managementOffice;

      dynamic response =
      await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = ManagementOffice.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitComplaint(var data) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitComplaints);

      dynamic response = await _apiService.postApiResponsewithtoken(url,
          token, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateComplaint(var data, var complaintid) async {

    String id = complaintid.toString();
    String query = "/$id";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitComplaints);

      dynamic response =
      await _apiService.putApiResponsewithtoken(url, token, data, query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
  // Delete Visitor Data
  Future<DeleteResponse> deleteComplaintDetails(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.complaints;
    String id = data.toString();
    String query = "/$id";
    // String query = "/$data";
    // var url1 = url+"/$data";
    dynamic response =
    await _apiService.deleteApiResponsewithtoken(url,token, query);
    try {
      final jsonData = DeleteResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

}
