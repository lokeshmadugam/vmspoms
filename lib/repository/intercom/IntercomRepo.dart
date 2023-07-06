

import 'dart:convert';

import 'package:poms_app/model/intercom/IntercomListingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/PostApiResponse.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/DeleteResponse.dart';
import '../../resources/AppUrl.dart';
class IntercomRepository {

  final BaseApiServices _apiService = NetworkApiService();
  // Intercom List
  Future<dynamic> getIntercomList(String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,
      int propertyId,String unitNo) async {
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
        'unit_no':unitno,

      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.intercomListUrl;

      dynamic response = await _apiService.getQueryResponse(
          url, token, queryParameters, '');

      final jsonData = IntercomListModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }

//Intercom Registrtion
  Future<dynamic> intercomRegistration(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.intercomListUrl;
    dynamic response =
    await _apiService.postApiResponsewithtoken(url, token, data);
    try {
      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

  // Update Visitor Details
  Future<dynamic> updateIntercomDetails(dynamic data,int id) async {

    String intercomId = id.toString();

    String query = "/$intercomId";
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);
      var url =   AppUrl.intercomListUrl;
      // var url =   "https://ap-04.eezapps.com/vms/api/Intercom/$id";
      dynamic response = await _apiService.putApiResponsewithtoken(
          url, token,data,query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
  // Delete Visitor Data
  Future<DeleteResponse> deleteIntecomDetails(dynamic data) async {
    // String vistorId = id.toString();
    // Map<String, String> data ={
    //   'id':vistorId,
    // };

    String id = data.toString();

    String query = "/$id";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    // var url = "https://ap-04.eezapps.com/vms/api/Itercom/$id";
    var url = AppUrl.intercomListUrl;
    dynamic response =
    await _apiService.deleteApiResponsewithtoken(url,token, query);
    try {
      final jsonData = DeleteResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}