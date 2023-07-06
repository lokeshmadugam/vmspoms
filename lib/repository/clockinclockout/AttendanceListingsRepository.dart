import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/DeleteResponse.dart';
import '../../model/clockinclockout/AttendanceListings.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../resources/AppUrl.dart';

class AttendanceListingsRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getAttendanceListings(var employeeId, var startDate, var endDate,
      var propertyId) async {

    try {
      Map<String, String> queryParameters = {
        'employee_id': employeeId.toString(),
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'property_id': propertyId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitClockIn);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = AttendanceListings.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
  // Delete Visitor Data
  Future<dynamic> deleteAttendanceDetails(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.submitClockIn;
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