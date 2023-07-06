import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/securityrounds/SecurityCheckPoint.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';
import '../../repository/securityrounds/SecurityChecksRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../model/securityrounds/SecurityRoundsLogsRequest.dart';
import '../../utils/Utils.dart';

class SecurityChecksScreenViewModel extends ChangeNotifier {

  final _myRepo = SecurityChecksRepository();

  ApiResponse<SecurityCheckPoint> checkPoints = ApiResponse.loading();
  ApiResponse<PostApiResponse> postApiResponse = ApiResponse.loading();
  ApiResponse<MediaUpload> mediaUpload = ApiResponse.loading();

  List<SecurityRoundsLogsRequest> logsList = [];

  void _setCheckPoints(ApiResponse<SecurityCheckPoint> response) {
    if (response.data != null) {
      checkPoints = response;
      notifyListeners();
    }
  }

  Future<void> fetchSecurityCheckPoints(var propertyId) async {
    _setCheckPoints(ApiResponse.loading());
    _myRepo
        .getSecurityCheckPoints(propertyId)
        .then((value) => _setCheckPoints(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setCheckPoints(ApiResponse.error(error.toString())));
  }

  Future<void> _setMediaUpload(ApiResponse<MediaUpload> response, int index,
      BuildContext context) async {
    if (response.data != null) {
      mediaUpload = response;
      logsList[index].checkpointLocationImg = mediaUpload.data!.refName!.trim();

      getMediaUpload(index + 1, logsList, context);
    }
  }

  Future<void> getMediaUpload(int index, var data, BuildContext context) async {
    logsList = data;
    if (index == logsList.length) {
      submitSecurityLogs(logsList, context);
    } else {
      _setMediaUpload(ApiResponse.loading(), index, context);
      _myRepo
          .mediaUpload(logsList[index].checkpointLocationImg)
          .then((value) => _setMediaUpload(ApiResponse.success(value), index, context))
          .onError((error, stackTrace) => _setMediaUpload(
          ApiResponse.error(error.toString()), index, context));
    }
  }

  Future<ApiResponse<PostApiResponse>> submitSecurityLogs(
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.submitSecurityChecks(data);
      response = ApiResponse.success(value);
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
    }

    if (kDebugMode) {
      print(response.toString());
    }

    return response;
  }

  Future<ApiResponse<PostApiResponse>> submitSecurityRoundsTemp(
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.submitSecurityChecksTemp(data);
      response = ApiResponse.success(value);
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
    }

    if (kDebugMode) {
      print(response.toString());
    }

    return response;
  }

  Future<ApiResponse<MediaUpload>> newMediaUpload(
      var imagePath, BuildContext context) async {
    ApiResponse<MediaUpload> response = ApiResponse.loading();
    notifyListeners();
    try {
      MediaUpload value = await _myRepo.mediaUpload(imagePath);
      response = ApiResponse.success(value);
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
    }

    if (kDebugMode) {
      print(response.toString());
    }

    return response;
  }

  Future<ApiResponse<SecurityViewDetails>> getSecurityTempLogs(
      var id, var roundsId, BuildContext context) async {
    ApiResponse<SecurityViewDetails> response = ApiResponse.loading();
    notifyListeners();
    try {
      SecurityViewDetails value = await _myRepo.getSecurityCheckTempLogs(id, roundsId);
      response = ApiResponse.success(value);
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
    }

    if (kDebugMode) {
      print(response.toString());
    }

    return response;
  }




}