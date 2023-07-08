import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../resources/AppUrl.dart';
import 'package:http/http.dart' as http;

class EditLostDetailsFormRepository {
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

  Future<dynamic> updateLostDetailsForm(var id, var data) async {
    String lostId = id.toString();
    String query = "/$lostId";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');
      String token = jsonDecode(bearerToken!);

      var url = AppUrl.updateLostItems;
      // "https://ap-04.eezapps.com/vms/api/LostFound/$id";

      // LostFound
      dynamic response =
          await apiServices.putApiResponsewithtoken(url, token, data, query);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
