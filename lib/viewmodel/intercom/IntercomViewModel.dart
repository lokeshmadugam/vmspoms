import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:poms_app/model/intercom/IntercomListingModel.dart';
import 'package:poms_app/repository/intercom/IntercomRepo.dart';

import '../../Model/PostApiResponse.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/DeleteResponse.dart';
import '../../utils/Utils.dart';

class IntercomViewModel extends ChangeNotifier {



  final _myRepo = IntercomRepository();
// Get All Intercom List
  Future<ApiResponse<IntercomListModel>> getIntercomList(
      String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId,String unitNo) async {
    ApiResponse<IntercomListModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getIntercomList(orderBy, orderByPropertyName, pageNumber, pageSize, propertyId,unitNo);
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



  //Get Intercom Registration
  Future<ApiResponse<PostApiResponse>> intercomRegistration(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.intercomRegistration(data);
      response = ApiResponse.success(value);

      if (value.status == 201){
      print('response = ${value.mobMessage}');
      Utils.flushBarErrorMessage("${value.mobMessage}", context);



      } else {
        Utils.flushBarErrorMessage("${value.mobMessage}", context);
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
  // Update Intercom
  Future<ApiResponse<PostApiResponse>> updateIntercom(var data,int id, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.updateIntercomDetails(data,id);
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
  // Delete Intercom Data
  Future<ApiResponse<DeleteResponse>> deletetIntercomDetails(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteIntecomDetails(data);
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