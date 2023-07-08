import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/packages/BlockUnitNumber.dart';
import '../../model/packages/DeliveryServiceModel.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../model/packages/PackageStatus.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/packages/PackageReceivedRequest.dart';
import '../../model/packages/PackageType.dart';
import '../../resources/AppUrl.dart';
import 'package:http/http.dart' as http;

class PackageReceivedFormRepository {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> getDeliveryServiceList(var countryCode) async {
    try {
      Map<String, String> queryParameters = {'countryCode': countryCode};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.deliveryService);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = DeliveryServiceModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPackageTypeList() async {
    try {
      Map<String, String> queryParameters = {};

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.packageType);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = PackageType.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createReceivedPackage(PackageReceivedRequest request) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.createReceivedPackage);

      dynamic response = await apiServices.postApiResponsewithtoken(
          url, token, request.toJson());

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateReceivedPackage(PackageReceivedRequest request) async {
    String packageId = request.id.toString();
    String query = "/$packageId";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.updateReceivedPackage);

      dynamic response = await apiServices.putApiResponsewithtoken(
          url, token, request.toJson(), query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> mediaUpload(var imagePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      final url = (AppUrl.mediaUpload);
      final request = http.MultipartRequest('POST', Uri.parse(url));

      final image =
          await http.MultipartFile.fromPath('fileToUpload', imagePath);
      request.files.add(image);

      dynamic response = await request.send();
      dynamic responseString = await response.stream.bytesToString();

      dynamic responseJson = jsonDecode(responseString);

      final jsonData = MediaUpload.fromJson(responseJson);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getBlockUnitNoList(
      var blockName, var propertyId, var unitNo) async {
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

  Future<dynamic> getPackageStatus() async {
    try {
      Map<String, String> queryParameters = {
        'configKey': 'packagereceiptsstatus'
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.receiptStatus);

      dynamic response =
          await apiServices.getQueryResponse(url, token, queryParameters, "");

      final jsonData = PackageStatus.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
