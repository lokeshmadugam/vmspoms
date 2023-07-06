import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/clockinclockout/ClockInClockOutByEmployeeId.dart';
import '../../model/clockinclockout/ClockInClockOutRequest.dart';
import '../../model/clockinclockout/ClockInRequestTimeConfigItem.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../resources/AppUrl.dart';
import 'package:http/http.dart' as http;

class ClockInClockOutRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getConfigItems() async {
    try {
      Map<String, String> queryParameters = {
        'configKey': 'CIOActivity'
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.configItemsUrl);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = ClockInRequestTimeConfigItem.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getClockInClockOutByEmployeeId(var clockInOutDate,
      var employeeId, var propertyId) async {

    String query = "/$propertyId/$clockInOutDate/$employeeId";
    try {
      Map<String, String> queryParameters = {};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.clockInClockOutByEmployeId);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, query);

      final jsonData = ClockInClockOutByEmployeeId.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> mediaUpload(var imagePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      final url = (AppUrl.mediaUpload);
      final request = http.MultipartRequest('POST', Uri.parse(url));

      final image = await http.MultipartFile.fromPath('fileToUpload', imagePath);
      request.files.add(image);

      dynamic response = await request.send();
      dynamic responseString = await response.stream.bytesToString();

      dynamic responseJson = jsonDecode(responseString);

      final jsonData = MediaUpload.fromJson(responseJson);
      return jsonData;

    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitClockIn(ClockInClockOutRequest request) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitClockIn);

      dynamic response =
      await apiServices.postApiResponsewithtoken(url, token, request.toJson());

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateClockOut(var propertyId, ClockInClockOutRequest request) async {

    String propertyID = propertyId.toString();

    String id = propertyID.toString();
    String query = "/$id";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.updateClockOut);

      dynamic response =
      await apiServices.putApiResponsewithtoken(url, token, request.toJson(),query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitRequestTimeOff(ClockInClockOutRequest request) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitRequestTime);

      dynamic response =
      await apiServices.postApiResponsewithtoken(url, token, request.toJson());

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

}