import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/clockinclockout/ClockInClockOutByEmployeeId.dart';
import '../../model/clockinclockout/ClockInClockOutRequest.dart';
import '../../model/clockinclockout/ClockInRequestTimeConfigItem.dart';
import '../../repository/clockinclockout/ClockInClockOutRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../utils/Utils.dart';

class ClockInClockOutScreenViewModel extends ChangeNotifier {

  final _myRepo = ClockInClockOutRepository();

  ApiResponse<ClockInRequestTimeConfigItem> configItem = ApiResponse.loading();
  ApiResponse<PostApiResponse> postApiResponse = ApiResponse.loading();
  ApiResponse<MediaUpload> mediaUpload = ApiResponse.loading();
  ApiResponse<ClockInClockOutByEmployeeId> clockInClockOutByEmployeeId = ApiResponse.loading();

  ClockInClockOutRequest request = ClockInClockOutRequest();

  void _setConfigItems(ApiResponse<ClockInRequestTimeConfigItem> response) {
    if (response.data != null) {
      configItem = response;
      notifyListeners();
    }
  }

  Future<void> fetchAttendanceConfigItems() async {
    _setConfigItems(ApiResponse.loading());
    _myRepo
        .getConfigItems()
        .then((value) => _setConfigItems(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setConfigItems(ApiResponse.error(error.toString())));
  }

  Future<void> _setMediaUpload(ApiResponse<MediaUpload> response, int clockInOutReq,
      BuildContext context) async {
    if (response.data != null) {
      mediaUpload = response;

      if(clockInOutReq == 0){
        request.imgUrlClockin = mediaUpload.data!.refName;
        submitClockInRequest(request, context);
      } else if(clockInOutReq == 1){
        request.imgUrlClockout = mediaUpload.data!.refName;
        updateClockOutRequest(request, context);
      } else if(clockInOutReq == 2){
        request.imgUrlRequestTimeOffIntime = mediaUpload.data!.refName;
        submitRequestTimeOff(request, context);
      }

    }
  }

  Future<void> getMediaUpload(String clockInImage, var data, int clockInOutReq, BuildContext context) async {
    request = data;
      _setMediaUpload(ApiResponse.loading(), clockInOutReq, context);
      _myRepo
          .mediaUpload(clockInImage)
          .then((value) => _setMediaUpload(ApiResponse.success(value), clockInOutReq, context))
          .onError((error, stackTrace) => _setMediaUpload(
          ApiResponse.error(error.toString()), clockInOutReq, context));
  }

  void _setClockInResponse(ApiResponse<PostApiResponse> response, BuildContext context) {
    if (response.data != null) {
      postApiResponse = response;
      Utils.toastMessage(postApiResponse.data!.mobMessage.toString());

      fetchClockInClockOutByEmployeeId(request.clockInTime!.substring(0,10),
          request.employeeId, request.propertyId);

      notifyListeners();
    }
  }

  Future<void> submitClockInRequest(ClockInClockOutRequest request, BuildContext context) async {
    _setClockInResponse(ApiResponse.loading(), context);
    _myRepo
        .submitClockIn(request)
        .then((value) => _setClockInResponse(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
        _setClockInResponse(ApiResponse.error(error.toString()), context));
  }

  void _setClockOutResponse(ApiResponse<PostApiResponse> response, BuildContext context) {
    if (response.data != null) {
      postApiResponse = response;
      Utils.toastMessage(postApiResponse.data!.mobMessage.toString());

      fetchClockInClockOutByEmployeeId(request.clockOutTime!.substring(0,10),
          request.employeeId, request.propertyId);

      notifyListeners();
    }
  }

  Future<void> updateClockOutRequest(ClockInClockOutRequest request, BuildContext context) async {
    _setClockOutResponse(ApiResponse.loading(), context);
    _myRepo
        .updateClockOut(request.propertyId, request)
        .then((value) => _setClockOutResponse(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
        _setClockOutResponse(ApiResponse.error(error.toString()), context));
  }

  void _setRequestTimeOffResponse(ApiResponse<PostApiResponse> response, BuildContext context) {
    if (response.data != null) {
      postApiResponse = response;
      Utils.toastMessage(postApiResponse.data!.mobMessage.toString());

      fetchClockInClockOutByEmployeeId(request.clockOutTime!.substring(0,10),
          request.employeeId, request.propertyId);

      notifyListeners();
    }
  }

  Future<void> submitRequestTimeOff(ClockInClockOutRequest request, BuildContext context) async {
    _setRequestTimeOffResponse(ApiResponse.loading(), context);
    _myRepo
        .submitRequestTimeOff(request)
        .then((value) => _setRequestTimeOffResponse(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
        _setRequestTimeOffResponse(ApiResponse.error(error.toString()), context));
  }

  void _setClockInClockOutByEmployeeId(ApiResponse<ClockInClockOutByEmployeeId> response) {
    if (response.data != null) {
      clockInClockOutByEmployeeId = response;
      notifyListeners();
    }
  }

  Future<void> fetchClockInClockOutByEmployeeId(var clockInOutDate,
      var employeeId, var propertyId) async {
    _setClockInClockOutByEmployeeId(ApiResponse.loading());
    _myRepo
        .getClockInClockOutByEmployeeId(clockInOutDate, employeeId, propertyId)
        .then((value) => _setClockInClockOutByEmployeeId(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setClockInClockOutByEmployeeId(ApiResponse.error(error.toString())));
  }
  Future<ApiResponse<ClockInClockOutByEmployeeId>> fetchClockInClockOutByEmployeeId1(var clockInOutDate,
      var employeeId, var propertyId) async {
    ApiResponse<ClockInClockOutByEmployeeId> response = ApiResponse.loading();

    try {
      final value = await _myRepo.getClockInClockOutByEmployeeId(clockInOutDate, employeeId, propertyId);
      response = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        response = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return response;
  }
}