import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/ManagementSecurity.dart';
import '../../model/EmergencyService.dart';
import '../../model/ServiceType.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../resources/AppUrl.dart';

class ManagementSecurityRepo {
  final BaseApiServices _apiService = NetworkApiService();

  Future<dynamic> getManagementContactList(
      var mgmtInHouseId, var propertyId) async {
    try {
      Map<String, String> queryParameters = {
        'mgmt_inhouse_services_id': mgmtInHouseId.toString(),
        'propertyId': propertyId.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.managementSecurity;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = ManagementSecurity.fromJson(response);
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
