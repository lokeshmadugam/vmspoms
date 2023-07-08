import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/PostApiResponse.dart';
import '../../model/greylist/VehicleType.dart';
import '../../model/greylist/VisitType.dart';
import '../../resources/AppUrl.dart';

class GreyListFormRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getVisitType() async {
    try {
      Map<String, String> queryParameters = {};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.visitTypeUrL);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VisitType.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getVehicleType() async {
    try {
      Map<String, String> queryParameters = {};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.vehicleTypeUrl);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VehicleType.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitGreyListForm(var data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitGreyList);

      dynamic response =
          await apiServices.postApiResponsewithtoken(url, token, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateGreyListForm(var id, var data) async {
    String greyListId = id.toString();
    // String query = "/$greyListId";
    Map<String, String> query = {
      'id': greyListId,
    };
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.updateGreyList);

      dynamic response =
          await apiServices.putApiResponsewithtoken(url, token, query, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
