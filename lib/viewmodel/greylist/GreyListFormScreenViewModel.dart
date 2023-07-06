import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/PostApiResponse.dart';
import '../../model/greylist/VehicleType.dart';
import '../../model/greylist/VisitType.dart';
import '../../repository/greylist/GreyListFormRepository.dart';
import '../../utils/Utils.dart';

class GreyListFormScreenViewModel extends ChangeNotifier {

  final _myRepo = GreyListFormRepository();

  ApiResponse<VisitType> visitType = ApiResponse.loading();
  ApiResponse<VehicleType> vehicleType = ApiResponse.loading();
  ApiResponse<PostApiResponse> postApiResponse = ApiResponse.loading();


  void _setVisitType(ApiResponse<VisitType> response) {
    if (response.data != null) {
      visitType = response;
      notifyListeners();
    }
  }

  Future<void> fetchVisitTypes() async {
    _setVisitType(ApiResponse.loading());
    _myRepo
        .getVisitType()
        .then((value) => _setVisitType(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setVisitType(ApiResponse.error(error.toString())));
  }

  void _setVehicleType(ApiResponse<VehicleType> response) {
    if (response.data != null) {
      vehicleType = response;
      notifyListeners();
    }
  }

  Future<void> fetchVehiclesTypes() async {
    _setVehicleType(ApiResponse.loading());
    _myRepo
        .getVehicleType()
        .then((value) => _setVehicleType(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setVehicleType(ApiResponse.error(error.toString())));
  }

  // void _setSubmitGreyListForm(ApiResponse<PostApiResponse> response, BuildContext context) {
  //   if (response.data != null) {
  //     postApiResponse = response;
  //     Utils.toastMessage(postApiResponse.data!.message.toString());
  //     Navigator.pop(context);
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> submitGreyListForm1(var data, BuildContext context) async {
  //   _setSubmitGreyListForm(ApiResponse.loading(), context);
  //   _myRepo
  //       .submitGreyListForm(data)
  //       .then((value) => _setSubmitGreyListForm(ApiResponse.success(value), context))
  //       .onError((error, stackTrace) =>
  //       _setSubmitGreyListForm(ApiResponse.error(error.toString()), context));
  // }
  //Grey List Registration
  Future<ApiResponse<PostApiResponse>> submitGreyListForm(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.submitGreyListForm(data);
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
  // Update GreyList Data
  Future<ApiResponse<PostApiResponse>> updateGreyListForm(int id,var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.updateGreyListForm(id, data);
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
  // Future<void> updateGreyListForm(var greyListId, var data, BuildContext context) async {
  //   _setSubmitGreyListForm(ApiResponse.loading(), context);
  //   _myRepo
  //       .updateGreyListForm(greyListId, data)
  //       .then((value) => _setSubmitGreyListForm(ApiResponse.success(value), context))
  //       .onError((error, stackTrace) =>
  //       _setSubmitGreyListForm(ApiResponse.error(error.toString()), context));
  // }

}