


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/MediaUpload.dart';
import '../resources/AppUrl.dart';
import 'package:http/http.dart' as http;
class FileStorageRepository {

  //
  // Future<dynamic> mediaUpload(var imagePath) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? bearerToken = prefs.getString('token');
  //     String token = jsonDecode(bearerToken!);
  //
  //     final url = (AppUrl.mediaUpload);
  //     final request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //     final image = await http.MultipartFile.fromPath('fileToUpload', imagePath);
  //     request.files.add(image);
  //
  //     dynamic response = await request.send();
  //     dynamic responseString = await response.stream.bytesToString();
  //
  //     dynamic responseJson = jsonDecode(responseString);
  //
  //     final jsonData = MediaUpload.fromJson(responseJson);
  //     return jsonData;
  //
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


  Future<List<String>> mediaUpload(List<String> imagePaths) async {
    final List<String> urls = [];

    try {


      for (final imagePath in imagePaths) {
        final url = AppUrl.mediaUpload;
        final request = http.MultipartRequest('POST', Uri.parse(url));

        final file =
        await http.MultipartFile.fromPath('fileToUpload', imagePath);
        request.files.add(file);

        // Add any additional request parameters or headers if required

        final response = await request.send();
        final responseString = await response.stream.bytesToString();

        final responseJson = jsonDecode(responseString);

        if (responseJson is Map<String, dynamic> &&
            responseJson.containsKey('originalName')    &&
            responseJson.containsKey('refName')   ) {
          var originalName = responseJson['originalName'];
          var refName = responseJson['refName'];
          urls.add(originalName);
          urls.add(refName);

        }
        else {
          throw Exception('Failed to extract URL from the response');
        }
      }

      return urls;
    } catch (e) {
      print('Error uploading media: $e');
      rethrow;
    }
  }











}