import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/DeleteResponse.dart';
import '../../model/packages/PackageExpected.dart';
import '../../model/packages/PackageReceived.dart';
import '../../resources/AppUrl.dart';

class PackageExpectedRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getPackageExpectedList(var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'property_id': propertyId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.packageExpectedList);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = PackageExpected.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
  // Delete Expected Data
  Future<dynamic> deleteExpectedDetails(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.packageExpectedList;
    String id = data.toString();
    String query = "/$id";
    // String query = "/$data";
    // var url1 = url+"/$data";
    dynamic response =
    await apiServices.deleteApiResponsewithtoken(url,token, query);
    try {
      final jsonData = DeleteResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }


}