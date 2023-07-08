import 'dart:convert';
import '/model/DeleteResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/PostApiResponse.dart';
import '../../model/trustednbgh/TrustedNbghListModel.dart';
import '../../model/trustednbgh/TrustedNeighboursModel.dart';
import '../../resources/AppUrl.dart';

class TrustedNeighbourRepository {
  final BaseApiServices _apiService = NetworkApiService();

// Get Trusted Neighbours List
  Future<TrustedNeighbourListModel> getTrustedNeighbours(
      String orderBy,
      String orderByPropertyName,
      int pageNumber,
      int pageSize,
      int propertyId,
      int userId) async {
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();
    String userid = userId.toString();
    try {
      Map<String, String> queryParameters = {
        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'property_id': propertyid,
        'user_id': userid
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.trustedNbghByUserIdUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = TrustedNeighbourListModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // Get Trusted Neighbours
  Future<TrustedNeighboursModel> getAllTrustedNeighbour(
      String orderBy,
      String orderByPropertyName,
      int pageNumber,
      int pageSize,
      int propertyId,
      String serach) async {
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();
    String sear = serach;
    try {
      Map<String, String> queryParameters = {
        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'propertyId': propertyid,
        'serach': sear
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.getAllTrustedNbghUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = TrustedNeighboursModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // Add Trusted Neighbours
  Future<PostApiResponse> addTrustedNeighbours(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.trustednbghUrl;
    dynamic response =
        await _apiService.postApiResponsewithtoken(url, token, data);
    try {
      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

  // Update Trusted Neighbours data
  // Future<PostApiResponse> updateTrustedNeighbours(dynamic data) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? bearerToken = prefs.getString('token');
  //   String token = jsonDecode(bearerToken!);
  //   // var url = "https://ap-04.eezapps.com/vms/api/TrustedNeigbours/$id";
  //   var url =  "https://ap-04.eezapps.com/vms/api/TrustedNeigbours";
  //   dynamic response =
  //   await _apiService.putApiResponsewithtoken(url,token, data);
  //   try {
  //     final jsonData = PostApiResponse.fromJson(response);
  //     return jsonData;
  //   } catch (e) {
  //     throw e;
  //   }
  // }
  // Delete Trusted Neighbours Data
  Future<DeleteResponse> deleteTrustedNeighbours(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    String id = data.toString();
    String query = "/$id";
    var url = AppUrl.trustedNbghById;
    dynamic response =
        await _apiService.deleteApiResponsewithtoken(url, token, query);
    try {
      final jsonData = DeleteResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
