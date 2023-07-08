//
// import 'package:flutter/cupertino.dart';
// import '../repository/FileStorageRepo.dart';
//
// import '../data/respose/ApiResponse.dart';
// import '../data/respose/Status.dart';
// import '../model/MediaUpload.dart';

// class FileStorageViewModel extends ChangeNotifier {
// // Response loading
//
// var request;
// MediaUpload? mediaUpload;
//
//   final _myRepo = FileStorageRepository();
//
// /*
// Future<List?> getMediaUpload(List<String> imagePath, BuildContext context) async {
//   setMediaUpload(ApiResponse.loading(), context);
//   try {
//     var value = await _myRepo.mediaUpload(imagePath);
//     final mediaUploadList = value;
//     // final mediaUpload = MediaUpload.fromJson(mediaUploadList.first);
//     //
//     // final qrcode = await setMediaUpload(ApiResponse.success(mediaUpload), context);
//     return mediaUploadList;
//   } catch (error) {
//     setMediaUpload(ApiResponse.error(error.toString()), context);
//     return null;
//   }
// }
//
//   Future<String?> setMediaUpload(ApiResponse<MediaUpload> response, BuildContext context) async {
//     if (response.data != null) {
//       final qrcode = response.data!.refName!.trim();
//
//
//       return qrcode;
//     }
//     throw Exception("Media upload failed.");
//   }
//
// */
//   Future<List<String>?> getMediaUpload(List<String> imagePaths, BuildContext context) async {
//     setMediaUpload(ApiResponse.loading(), context);
//     try {
//       var urls = await _myRepo.mediaUpload(imagePaths);
//       if (urls != null) {
//         return urls;
//       } else {
//         throw Exception('Failed to upload ');
//       }
//     } catch (error) {
//       setMediaUpload(ApiResponse.error(error.toString()), context);
//       return null;
//     }
//   }
//
//   Future<List<String>> setMediaUpload(ApiResponse<List<String>> response, BuildContext context) async {
//     if (response.data != null && response.data!.isNotEmpty) {
//       final qrcode = response.data!;
//       return qrcode;
//     }
//     throw Exception("Media upload failed.");
//   }
//
// }

import 'package:flutter/cupertino.dart';
import '../repository/FileStorageRepo.dart';
import '../data/respose/ApiResponse.dart';
import '../model/MediaUpload.dart';

class FileStorageViewModel extends ChangeNotifier {
  var request;
  MediaUpload? mediaUpload;

  final _myRepo = FileStorageRepository();

  Future<List<String>?> getMediaUpload(
      List<String> imagePaths, BuildContext context) async {
    setMediaUpload(ApiResponse.loading(), context);
    try {
      var urls = await _myRepo.mediaUpload(imagePaths);
      if (urls != null) {
        return urls;
      } else {
        throw Exception('Failed to upload ');
      }
    } catch (error) {
      setMediaUpload(ApiResponse.error(error.toString()), context);
      return null;
    }
  }

  Future<List<String>> setMediaUpload(
      ApiResponse<List<String>> response, BuildContext context) async {
    if (response.data != null && response.data!.isNotEmpty) {
      final data = response.data!;
      return data;
    }
    throw Exception("Media upload failed.");
  }
}
