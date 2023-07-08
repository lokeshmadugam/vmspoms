import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../resources/AppUrl.dart';
import 'package:http/http.dart' as http;

class LostDetailsFormRepository {
  BaseApiServices apiServices = NetworkApiService();

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

  Future<dynamic> submitLostDetailsForm(var data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = (AppUrl.submitLostItems);

      dynamic response =
          await apiServices.postApiResponsewithtoken(url, token, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
