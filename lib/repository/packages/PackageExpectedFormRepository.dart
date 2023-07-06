import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/packages/DeliveryServiceModel.dart';
import '../../model/PostApiResponse.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/packages/BlockUnitNumber.dart';
import '../../model/packages/PackageType.dart';
import '../../resources/AppUrl.dart';

class PackageExpectedFormRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getDeliveryServiceList(var countryCode) async {
    try{
      Map<String, String> queryParameters = {
        'countryCode': countryCode
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.deliveryService);

      dynamic response = await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = DeliveryServiceModel.fromJson(response);
      return jsonData;
    }
    catch (e){
      rethrow;
    }
  }

  Future<dynamic> getPackageTypeList() async {
    try{
      Map<String, String> queryParameters = {};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.packageType);

      dynamic response = await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = PackageType.fromJson(response);
      return jsonData;
    }
    catch (e){
      rethrow;
    }
  }

  Future<dynamic> createExpectedPackage(var data) async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.createExpectedPackage);

      dynamic response = await apiServices.postApiResponsewithtoken(url,
          token, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateExpectedPackage(var data, var id) async {

    String packageId = id.toString();
    String query = "/$packageId";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.updateExpectedPackage);

      dynamic response =
      await apiServices.putApiResponsewithtoken(url, token, data, query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getBlockUnitNoList(var blockName, var propertyId, var unitNo) async {
    try {
      Map<String, String> queryParameters = {
        'blockName': blockName,
        'propertyId': propertyId.toString(),
        'unitNumber': unitNo
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.blockUnitNoList);

      dynamic response =
      await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = BlockUnitNumber.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

}