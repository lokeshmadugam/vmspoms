
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/DeleteResponse.dart';
import '../../model/facility/FacilityBookingModel.dart';
import '../../model/facility/FacilityTypeModel.dart';
import '../../model/PostApiResponse.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../resources/AppUrl.dart';

class FacilityBookingRepository {

  final BaseApiServices _apiService = NetworkApiService();
// Facility Bookings
  Future<dynamic> getFacilityBookings(int facilityId,String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,
      int propertyId,String fromDate,String toDate) async {
    String facilityid = facilityId.toString();
    String orderby = orderBy;
    String orderByPN = orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    String propertyid = propertyId.toString();
    String fromdate = fromDate;
    String todate = toDate;
    try {
      Map<String, String> queryParameters = {
        'facility_id':facilityid,
        'orderBy': orderby,
        'orderByPropertyName': orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
        'property_id': propertyid,
        'from_date':fromdate,
         'to_date':todate

      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.facilityBookingUrl;

      dynamic response = await _apiService.getQueryResponse(
          url, token, queryParameters,'');

      final jsonData = FacilityBookingModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
// FacilityTypes
  Future<dynamic> getFacilityTypes(String orderBy,
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

      var url = AppUrl.facilityTypeUrl;

      dynamic response = await _apiService.getQueryResponse(
          url, token, queryParameters,'');

      final jsonData = FacilityTypeModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
  // Create Facility Booking
  Future<dynamic> createFacilityBookings(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.facilityBookingUrl;
    dynamic response =
    await _apiService.postApiResponsewithtoken(url,token, data);
    try {
      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

  // Delete Facility Bookings Data
  Future<dynamic> deleteFacilityBookings(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    String id = data.toString();

    String query = "/$id";
    var url = AppUrl.facilityBookingUrl;
    dynamic response =
    await _apiService.deleteApiResponsewithtoken(url,token, query);
    try {
      final jsonData = DeleteResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
  // Fee Paid Status
  Future<dynamic>  getFeePaidStatus(String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,String appUseage,String configKey ) async {
    String appuseage = appUseage;
    String configkey = configKey;
    String orderby = orderBy;
    String orderByPN= orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    try {
      Map<String, String> queryParameters ={
        'appUseage':appuseage,
        'configKey':configkey,
        'orderBy':orderby,
        'orderByPropertyName':orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,



      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url =   AppUrl.configItemsUrl;

      dynamic response = await _apiService.getQueryResponse(
          url, token, queryParameters,'');

      final jsonData = VisitorsStatusModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
}