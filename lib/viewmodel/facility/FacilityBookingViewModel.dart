

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/DeleteResponse.dart';
import '../../model/PostApiResponse.dart';
import '../../model/facility/FacilityBookingModel.dart';
import '../../model/facility/FacilityTypeModel.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../repository/facility/FacilityBookingRepo.dart';
import '../../utils/utils.dart';

class FacilityBookingViewModel with ChangeNotifier {

  final _myRepo = FacilityBookingRepository();
  Future<ApiResponse<FacilityBookingModel>> fetchFacilityBookingList(int facilityId,String orderBy, String orderByPropertyName, int pageNumber, int pageSize,
      int propertyId,String fromdate,String todate) async {
    ApiResponse<FacilityBookingModel> visitorListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getFacilityBookings(facilityId,orderBy, orderByPropertyName, pageNumber, pageSize, propertyId,fromdate,todate);
      visitorListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        visitorListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return visitorListResponse;
  }
  // Get Facility Types
  Future<ApiResponse<FacilityTypeModel>> getFacilityType(String orderBy, String orderByPropertyName, int pageNumber, int pageSize, int propertyId,) async {
    ApiResponse<FacilityTypeModel> facilityTypeResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getFacilityTypes(orderBy, orderByPropertyName, pageNumber, pageSize, propertyId);
      facilityTypeResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        facilityTypeResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return facilityTypeResponse;
  }

  //Create FacilityBookings
  Future<ApiResponse<PostApiResponse>> createFacilityBookings(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.createFacilityBookings(data);
      response = ApiResponse.success(value);

      if (value.status == 201){
      print('response = ${value.mobMessage}');
      Utils.flushBarErrorMessage("${value.mobMessage}", context);
      final result = value.result;


      } else {
        Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
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

  // Delete Facility Bookings Data
  Future<ApiResponse<DeleteResponse>> deleteFacilityBookingsData(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();

    try {
      DeleteResponse value = await _myRepo.deleteFacilityBookings(data);
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
  // Fee Paid Status
  Future<ApiResponse<VisitorsStatusModel>> getFeePaidStatus(String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, String appUseage ,String configKey
      ) async {
    ApiResponse<VisitorsStatusModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getFeePaidStatus(
        orderBy,
        orderByPropertyName,
        pageNumber,
        pageSize,
        appUseage,
        configKey,
      );;
      listResponse = ApiResponse.success(value);
      print("response = $listResponse");
    } catch (error) {
      if (kDebugMode) {
        listResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return listResponse;
  }
}