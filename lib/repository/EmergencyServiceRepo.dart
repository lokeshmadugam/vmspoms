import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/EmergencyService.dart';
import '../../model/ServiceType.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../resources/AppUrl.dart';

class EmergencyServiceRepo {
  final BaseApiServices _apiService = NetworkApiService();

  Future<dynamic> getEmergencyServices(
      var countryCode, var serviceTypeId, var subServiceType) async {
    try {
      Map<String, String> queryParameters = {
        'country_name': countryCode.toString(),
        'pageSize': '500',
        'service_type': serviceTypeId.toString(),
        'subservice_type': subServiceType.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.emergencyService;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = EmergencyService.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getServiceTypes(var serviceType) async {
    try {
      Map<String, String> queryParameters = {
        'configKey': serviceType.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.configItemsUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = ServiceType.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
