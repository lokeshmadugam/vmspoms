import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../resources/AppUrl.dart';
import '../model/CompanyPolicies.dart';

class SettingsRepo {
  final BaseApiServices _apiService = NetworkApiService();

  Future<dynamic> getCompanyPolicyList(var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'property_id': propertyId.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.companyPolicy;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = CompanyPolicies.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
