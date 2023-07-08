import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../Model/PostApiResponse.dart';
import '../../model/DeleteResponse.dart';
import '../../repository/securityrounds/SecurityViewDetailsRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';
import '../../utils/Utils.dart';

class SecurityViewDetailsScreenViewModel extends ChangeNotifier {
  final _myRepo = SecurityViewDetailsRepository();

  ApiResponse<SecurityViewDetails> securityDetails = ApiResponse.loading();

  void _setSecurityDetails(ApiResponse<SecurityViewDetails> response) {
    if (response.data != null) {
      securityDetails = response;
      notifyListeners();
    }
  }

  Future<void> fetchSecurityDetails(var userId, var propertyId) async {
    _setSecurityDetails(ApiResponse.loading());
    _myRepo
        .getSecurityViewDetails(userId, propertyId)
        .then((value) => _setSecurityDetails(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
            _setSecurityDetails(ApiResponse.error(error.toString())));
  }

  Future<ApiResponse<DeleteResponse>> deleteSecurityRounds(
      var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteSecurityRounds(data);
      response = ApiResponse.success(value);

      if (value.status == 200) {
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
