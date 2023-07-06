import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:poms_app/model/DeleteResponse.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/PostApiResponse.dart';
import '../../model/trustednbgh/TrustedNbghListModel.dart';
import '../../model/trustednbgh/TrustedNeighboursModel.dart';
import '../../repository/trustednbgh/TrustedNbghRepo.dart';
import '../../utils/utils.dart';

class TrustedNeighbourViewModel with ChangeNotifier {

  final _myRepo = TrustedNeighbourRepository();
// Get Trusted Neighbours List
  Future<ApiResponse<TrustedNeighbourListModel>> fetchTrustedNeighboursList(
       String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId,int userId) async {
    ApiResponse<TrustedNeighbourListModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getTrustedNeighbours(orderBy, orderByPropertyName, pageNumber, pageSize, propertyId, userId);
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

  // Get All Trusted Neighbours
  Future<ApiResponse<TrustedNeighboursModel>> fetchAllTrustedNeighbours(
      String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId,String search) async {
    ApiResponse<TrustedNeighboursModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getAllTrustedNeighbour(orderBy, orderByPropertyName, pageNumber, pageSize, propertyId, search);
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

  // Add Trusted Neighbours
  Future<ApiResponse<PostApiResponse>> addTrustedNeighbours(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.addTrustedNeighbours(data);
      response = ApiResponse.success(value);

      if (value.status == 201){
        print('response = ${value.mobMessage}');

      } else {
        // Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
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

  // // Update Trusted Neighbours Data
  // Future<ApiResponse<PostApiResponse>>  updateTrustedNeighbours(var data, BuildContext context) async {
  //   ApiResponse<PostApiResponse> response = ApiResponse.loading();
  //   notifyListeners();
  //   PostApiResponse postListResult;
  //   try {
  //     PostApiResponse value = await _myRepo.updateTrustedNeighbours(data);
  //     response = ApiResponse.success(value);
  //
  //     if (value.status == 200){
  //       print('response = ${value.message}');
  //
  //     } else {
  //       // Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
  //     }
  //   } catch (error) {
  //     Utils.flushBarErrorMessage(error.toString(), context);
  //     response = ApiResponse.error(error.toString());
  //   }
  //
  //   if (kDebugMode) {
  //     print(response.toString());
  //   }
  //
  //   return response;
  // }
  // Delete Trusted Neighbours Data
  Future<ApiResponse<DeleteResponse>> deleteTrustedNeighboursData(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteTrustedNeighbours(data);
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