
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:poms_app/model/visitorreg/GetAllParkings.dart';
import 'package:poms_app/model/visitorreg/ParkingTypeModel.dart';
import 'package:poms_app/repository/visitorreg/ParkingRepo.dart';

import '../../data/respose/ApiResponse.dart';
import '../../model/visitorreg/ParkingModel.dart';

class ParkingViewModel extends ChangeNotifier {



  final _myRepo = ParkingRepository();

  // ApiResponse<ParkingType> parkingtype = ApiResponse.loading();
  //
  //
  //
  //
  // void _setParkingtype(ApiResponse<ParkingType> response) {
  //   if (response.data != null) {
  //     parkingtype = response;
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> fetchParkingtypes(String orderBy,
  //     String orderByPropertyName,
  //     int pageNumber, int pageSize, int propertyId,) async {
  //   _setParkingtype(ApiResponse.loading());
  //   _myRepo
  //       .getParkingType(  orderBy, orderByPropertyName, pageNumber, pageSize, propertyId,)
  //       .then((value) => _setParkingtype(ApiResponse.success(value)))
  //       .onError((error, stackTrace) =>
  //       _setParkingtype(ApiResponse.error(error.toString())));
  // }
// Get Parking
  Future<ApiResponse<ParkingModel>> getParking(String orderBy,
      String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId, String unitNo) async {
    ApiResponse<ParkingModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getParking(
          orderBy, orderByPropertyName, pageNumber, pageSize, propertyId,
          unitNo);
      listResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        listResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return listResponse;
  }
  // Get Parking type
  Future<ApiResponse<ParkingType>> getParkingType(
      String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId) async {
    ApiResponse<ParkingType> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getParkingType(orderBy,orderByPropertyName,pageNumber,pageSize,propertyId);
      listResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        listResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return listResponse;
  }

  // Get all Parking
  Future<ApiResponse<GetAllParkings>> getAllParkings(
    String baytype, String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId) async {
    ApiResponse<GetAllParkings> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getAllParkings(baytype,orderBy,orderByPropertyName,pageNumber,pageSize,propertyId);
      listResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        listResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return listResponse;
  }
}