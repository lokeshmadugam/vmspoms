import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:poms_app/model/CountryModel.dart';
import '../../repository/SignUpRepo.dart';
import '../../data/respose/ApiResponse.dart';
import '../../utils/utils.dart';
import '../model/PostApiResponse.dart';
import '../model/ServiceType.dart';

class SignUpViewModel extends ChangeNotifier {
  final _myRepo = SignUpRepo();

  Future<ApiResponse<PostApiResponse>> submitSignUpDetails(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.submitSignUpDetails(data);
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

  Future<ApiResponse<ServiceType>> fetchGender(var configKey) async {
    ApiResponse<ServiceType> serviceListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getGender(configKey);
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
  Future<ApiResponse<CountryModel>> fetchCountry(String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,) async {
    ApiResponse<CountryModel> serviceListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getCoutry(orderBy, orderByPropertyName, pageNumber, pageSize);
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

}