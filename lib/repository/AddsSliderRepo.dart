
import 'dart:convert';

import 'package:poms_app/model/AddsSliderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiServices.dart';
import '../resources/AppUrl.dart';

class AddsRepository {

  final BaseApiServices _apiService = NetworkApiService();
  // AddsRepo
  Future<dynamic> getAdds(String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,int propertyId) async {
    String orderby = orderBy;
    String orderByPN= orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();


    try {
      Map<String, String> queryParameters ={

        'orderBy':orderby,
        'orderByPropertyName':orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'property_id':propertyid,



      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url =   AppUrl.addsUrl;

      dynamic response = await _apiService.getQueryResponse(
          url, token, queryParameters,'');

      final jsonData = AddsSliderModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
}