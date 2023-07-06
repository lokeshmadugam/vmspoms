import 'dart:convert';

import 'package:poms_app/model/houserules/HouseRulesModel.dart';
import 'package:poms_app/model/houserules/RulesModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../resources/AppUrl.dart';

class HouseRulesRepository {

  final BaseApiServices _apiService = NetworkApiService();

  // House Rules List
  Future<dynamic> getHouseRulesList(String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,
      int propertyId) async {
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();

    try {
      Map<String, String> queryParameters = {

        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'propertyId': propertyid,


      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.houserulesUrl;

      dynamic response = await _apiService.getQueryResponse(
          url, token, queryParameters, '');

      final jsonData = HouseRulesModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
  // Get Rules
  Future<dynamic> getRules(String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,
      int propertyId, int documentId) async {
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();
String documentid = documentId.toString();
    try {
      Map<String, String> queryParameters = {

        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'propertyId': propertyid,
        'document_type_id':documentid


      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.getRulesUrl;

      dynamic response = await _apiService.getQueryResponse(
          url, token, queryParameters, '');

      final jsonData = RulesModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
}