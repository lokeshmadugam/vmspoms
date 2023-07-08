import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/DeleteResponse.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';
import '../../resources/AppUrl.dart';

class SecurityViewDetailsRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getSecurityViewDetails(var userId, var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'property_id': propertyId.toString(),
        'pageSize': '500',
        'checkin_officer_userid': userId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.securityViewDetails);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = SecurityViewDetails.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // Delete Security Rounds
  Future<dynamic> deleteSecurityRounds(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.securityViewDetails;
    String id = data.toString();
    String query = "/$id";
    // String query = "/$data";
    // var url1 = url+"/$data";
    dynamic response =
    await apiServices.deleteApiResponsewithtoken(url, token, query);
    try {
      final jsonData = DeleteResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

}
