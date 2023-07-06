import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/DeleteResponse.dart';
import '../../model/lostfound/LostItems.dart';
import '../../model/lostfound/UnclaimedItems.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../resources/AppUrl.dart';

class UnclaimedItemsRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getUnclaimedItemsList(var propertyId, var userID) async {
    try {
      Map<String, String> queryParameters = {
        'property_id': propertyId.toString(),
        'collected_by': userID.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.unclaimed);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = UnclaimedItems.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
  // Delete Unclaimed Items Data
  Future<dynamic> deleteUnclaimedDetails(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.unclaimed;
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