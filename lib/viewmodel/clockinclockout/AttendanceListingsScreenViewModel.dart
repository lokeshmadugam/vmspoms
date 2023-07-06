import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/PostApiResponse.dart';
import '../../model/DeleteResponse.dart';
import '../../model/clockinclockout/AttendanceListings.dart';
import '../../repository/clockinclockout/AttendanceListingsRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../utils/Utils.dart';

class AttendanceListingsScreenViewModel extends ChangeNotifier {

  final _myRepo = AttendanceListingsRepository();

  ApiResponse<AttendanceListings> attendanceList = ApiResponse.loading();


  void _setAttendanceListings(ApiResponse<AttendanceListings> response) {
    if (response.data != null) {
      attendanceList = response;
      notifyListeners();
    }
  }

  Future<void> fetchAttendanceListings(var employeeId, var startDate, var endDate,
      var propertyId) async {
    _setAttendanceListings(ApiResponse.loading());
    _myRepo
        .getAttendanceListings(employeeId, startDate, endDate, propertyId)
        .then((value) => _setAttendanceListings(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setAttendanceListings(ApiResponse.error(error.toString())));
  }
  Future<ApiResponse<AttendanceListings>> fetchAttendanceListings1(
      var employeeId, var startDate, var endDate,
      var propertyId) async {
    ApiResponse<AttendanceListings> response = ApiResponse.loading();

    try {
      final value = await _myRepo.getAttendanceListings(employeeId, startDate, endDate, propertyId);
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
  // Delete Visitor Data
  Future<ApiResponse<DeleteResponse>> deletetAttendanceDetails(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteAttendanceDetails(data);
      response = ApiResponse.success(value);

      if (value.status == 200){
        print('response = ${value.mobMessage}');

      }
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