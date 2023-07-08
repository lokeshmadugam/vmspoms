import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/greylist/GreyList.dart';
import '../../resources/AppUrl.dart';

class GreyListingsRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getGreyListingsList(var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'propertyId': propertyId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.greyListings);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, '');

      final jsonData = GreyList.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
