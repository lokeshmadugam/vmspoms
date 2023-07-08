import 'dart:convert';

import '/model/visitorreg/GetAllParkings.dart';
import '/model/visitorreg/ParkingTypeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/visitorreg/ParkingModel.dart';
import '../../resources/AppUrl.dart';

class ParkingRepository {
  final BaseApiServices _apiService = NetworkApiService();

  // ParkingRepo
  Future<dynamic> getParking(String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId, String unitNo) async {
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();
    String unitno = unitNo;

    try {
      Map<String, String> queryParameters = {
        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'property_id': propertyid,
        'unit_no': unitno,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.parkingUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = ParkingModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // ParkingTypeRepo
  Future<dynamic> getParkingType(
    String orderBy,
    String orderByPropertyName,
    int pageNumber,
    int pageSize,
    int propertyId,
  ) async {
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
        'property_id': propertyid,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.parkingTypeUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = ParkingType.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // GetAllParkingsRepo
  Future<dynamic> getAllParkings(
    String baytype,
    String orderBy,
    String orderByPropertyName,
    int pageNumber,
    int pageSize,
    int propertyId,
  ) async {
    String bayType = baytype;
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();

    try {
      Map<String, String> queryParameters = {
        'bay_type': bayType,
        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'property_id': propertyid,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.getAllParkings;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = GetAllParkings.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
