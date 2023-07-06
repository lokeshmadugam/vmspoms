import 'dart:convert';
import 'package:poms_app/Model/LoginUserModel.dart';
import '../model/SignInModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiServices.dart';
import '../model/PostApiResponse.dart';
import '../resources/AppUrl.dart';

class LoginRepository {

  BaseApiServices _apiServices = NetworkApiService();
  String token = "";
  Future<dynamic> loginApi(dynamic data) async {
var url = (AppUrl.loginUrl) ;
    dynamic response = await _apiServices.postApiResponse(url, data);
    print("loginUrl = $url");
    try {
      final jsonData = SignInModel.fromJson(response);
      // token = jsonData.accessToken!;
      // print(token);
      return jsonData;

    } catch (e) {
      throw e;
    }
  }

//  Get Login User Details

  Future<LoginUserModel> getLoginUserDetails(int id) async {

    String vistorId = id.toString();
    try {
      Map<String, String> queryParameters ={
        'id':vistorId,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      // var url =   AppUrl.getLoginDetailsByIdUrl;
      var url =   "https://ap-04.eezapps.com/vms/api/PropertyUsers/$id";

      dynamic response = await _apiServices.getQueryResponse(
          url, token, queryParameters,'');

      final jsonData = LoginUserModel.fromJson(response);
      return jsonData;
    }
    catch (e) {
      rethrow;
    }
  }
  Future<dynamic> submitEmail(var data) async {

    try {
      var url = (AppUrl.email);

      dynamic response =
      await _apiServices.postApiResponse(url, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}


