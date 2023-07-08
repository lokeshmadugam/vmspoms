import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/DeleteResponse.dart';
import '../../model/lostfound/LostItems.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../resources/AppUrl.dart';

class LostItemsRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getLostItemsList(var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'property_id': propertyId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.lostItems);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = LostItems.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // Delete lost Items Data
  Future<dynamic> deleteLostDetails(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.lostItems;
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
