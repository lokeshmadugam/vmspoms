import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/newsbulletin/NewsBulletinModel.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../resources/AppUrl.dart';

class NewsBulletinRepository {
  final BaseApiServices _apiService = NetworkApiService();

  // News and Announcements
  Future<dynamic> getNewsandAnnouncements(
      String orderBy,
      String orderByPropertyName,
      int pageNumber,
      int pageSize,
      String appUseage,
      String configKey) async {
    String appuseage = appUseage;
    String configkey = configKey;
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    try {
      Map<String, String> queryParameters = {
        'appUseage': appuseage,
        'configKey': configkey,
        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.configItemsUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VisitorsStatusModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // get News List
  Future<dynamic> getNewsList(String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, String propertyId, int Id) async {
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId;
    String id = Id.toString();
    try {
      Map<String, String> queryParameters = {
        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'property_ids': propertyid,
        'announcement_newbulletin_id': id
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.newsBulletinUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = NewsBulletinModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
