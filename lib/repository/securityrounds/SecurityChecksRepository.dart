import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/securityrounds/SecurityCheckPoint.dart';
import '../../model/securityrounds/SecurityRoundsLogsRequest.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';
import '../../resources/AppUrl.dart';
import 'package:http/http.dart' as http;

class SecurityChecksRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getSecurityCheckPoints(var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'propertyId': propertyId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.securityCheckPoint);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = SecurityCheckPoint.fromJson(response);
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

  Future<dynamic> submitSecurityChecks(var data) async {

    var json = data.map((e) => e.toJson()).toList();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.securityRoundLogs);

      dynamic response =
      await apiServices.postApiResponsewithtoken(url, token, json);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitSecurityChecksTemp(var data) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.securityRoundLogsTemp);

      dynamic response =
      await apiServices.postApiResponsewithtoken(url, token, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSecurityCheckTempLogs(var id, var roundsId) async {
    try {
      Map<String, String> queryParameters = {
        'checkin_officer_userid': id.toString(),
        'rounds_id': roundsId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.securityRoundLogsTemp);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = SecurityViewDetails.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }



}