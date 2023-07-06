import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/DeleteResponse.dart';
import '../../model/damagescomplaints/Complaints.dart';
import '../../model/damagescomplaints/ManagementOffice.dart';
import '../../repository/damagescomplaints/ComplaintsRepo.dart';
import '../../view/managementservices/ManagementServicesTabScreen.dart';
import '../../Model/PostApiResponse.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/ServiceType.dart';
import '../../utils/Utils.dart';

class ComplaintsViewModel with ChangeNotifier {
  final _myRepo = ComplaintsRepo();

  Future<ApiResponse<Complaints>> fetchComplaintsList(var propertyId, var userId) async {
    ApiResponse<Complaints> complaintsListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getComplaintsList(propertyId, userId);
      complaintsListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        complaintsListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return complaintsListResponse;
  }

  Future<ApiResponse<ServiceType>> fetchComplaintType(var configKey) async {
    ApiResponse<ServiceType> serviceListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getComplaintTypes(configKey);
      serviceListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        serviceListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return serviceListResponse;
  }

  Future<ApiResponse<ManagementOffice>> fetchComplaintAssignedToItems(var appUserTypeId,
      var propertyId) async {
    ApiResponse<ManagementOffice> managementOfficeResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getComplaintAssignedToItems(appUserTypeId, propertyId);
      managementOfficeResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        managementOfficeResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return managementOfficeResponse;
  }

  Future<ApiResponse<PostApiResponse>> submitComplaint(
      var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.submitComplaint(data);
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

  Future<ApiResponse<PostApiResponse>> updateComplaint(
      var data, var complaintId, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.updateComplaint(data, complaintId);
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
  // Delete Visitor Data
  Future<ApiResponse<DeleteResponse>> deletetComplaintDetails(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteComplaintDetails(data);
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
