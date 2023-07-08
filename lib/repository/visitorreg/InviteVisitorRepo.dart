import 'dart:convert';
import '/model/visitorreg/FavoriteVisitors.dart';
import '/model/visitorreg/ParkingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/DeleteResponse.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/PostApiResponse.dart';
import '../../model/visitorreg/VehicleTypeModel.dart';
import '../../model/visitorreg/VisitReasonModel.dart';
import '../../model/visitorreg/VisitorDetailsModel.dart';
import '../../model/visitorreg/VisitorTypeModel.dart';
import '../../model/visitorreg/VisitorsListModel.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../resources/AppUrl.dart';

class InviteVisitorRepository {
  final BaseApiServices _apiService = NetworkApiService();

  @override
  Future<dynamic> getVisitorTypes() async {
    // String orderby = orderBy;
    // String orderByPN= orderByPropertyName;
    // String pagenumber = pageNumber.toString();
    // String pagesize = pageSize.toString();
    try {
      Map<String, String> queryParameters = {
        // 'orderBy':orderby,
        // 'orderByPropertyName':orderByPN,
        // 'pageNumber': pagenumber,
        // 'pageSize': pagesize,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);
      print(token);
      var url = AppUrl.visitTypeUrL;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VisitorTypeModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getVisitReasons() async {
    // String orderby = orderBy;
    // String orderByPN= orderByPropertyName;
    // String pagenumber = pageNumber.toString();
    // String pagesize = pageSize.toString();
    try {
      Map<String, String> queryParameters = {
        // 'orderBy':orderby,
        // 'orderByPropertyName':orderByPN,
        // 'pageNumber': pagenumber,
        // 'pageSize': pagesize,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.visitReasonUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VisitReasonModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getVehicleType() async {
    // String orderBy,
    //     String orderByPropertyName, int pageNumber, int pageSize
    // String orderby = orderBy;
    // String orderByPN= orderByPropertyName;
    // String pagenumber = pageNumber.toString();
    // String pagesize = pageSize.toString();
    try {
      Map<String, String> queryParameters = {
        // 'orderBy':orderby,
        // 'orderByPropertyName':orderByPN,
        // 'pageNumber': pagenumber,
        // 'pageSize': pagesize,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.vehicleTypeUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VehicleTypeModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<VisitorsStatusModel> getVisitorStatus(
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

  Future<VisitorsListModel> getVisitList(
      String orderBy,
      String orderByPropertyName,
      int pageNumber,
      int pageSize,
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

      var url = AppUrl.visitorRegistrationUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VisitorsListModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  //Visitor Registrtion
  Future<PostApiResponse> visitorregistration(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.visitorRegistrationUrl;
    dynamic response =
        await _apiService.postApiResponsewithtoken(url, token, data);
    try {
      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

//  Get Visitor Details

  Future<VisitorDetailsModel> getVisitorDetails(int id) async {
    String vistorId = id.toString();

    String query = "/$vistorId";
    try {
      Map<String, String> queryParameters = {
        'id': vistorId,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      // var url =   AppUrl.visitorRegistrationUrl;
      var url = "https://ap-04.eezapps.com/vms/api/VisitorRegistrationReq/$id";

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = VisitorDetailsModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // Update Visitor Details
  Future<PostApiResponse> updateVisitorDetails(dynamic data, int id) async {
    String vistorId = id.toString();

    String query = "/$vistorId";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);
      var url = AppUrl.visitorRegistrationUrl;
      // var url =   "https://ap-04.eezapps.com/vms/api/VisitorRegistrationReq/$id";
      dynamic response =
          await _apiService.putApiResponsewithtoken(url, token, data, query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  // Delete Visitor Data
  Future<DeleteResponse> deleteVisitorDetails(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.visitorRegistrationUrl;
    String id = data.toString();
    String query = "/$data";
    // String query = "/$data";
    // var url1 = url+"/$data";
    print("url = $url");
    dynamic response =
        await _apiService.deleteApiResponsewithtoken(url, token, query);
    try {
      final jsonData = DeleteResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

//Favorite Visitor Registrtion
  Future<PostApiResponse> addFavoriteVisitorRegistration(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerToken = prefs.getString('token');
    String token = jsonDecode(bearerToken!);
    var url = AppUrl.addFavoriteUrl;
    dynamic response =
        await _apiService.postApiResponsewithtoken(url, token, data);
    try {
      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

  // Get Favorite List
  Future<dynamic> getFavoriteVisitorList(
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
        'user_id': userid,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.addFavoriteUrl;

      dynamic response =
          await _apiService.getQueryResponse(url, token, queryParameters, '');

      final jsonData = FavoriteVisitorModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
