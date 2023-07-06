import 'package:flutter/cupertino.dart';
import '../../repository/securityrounds/SecurityViewDetailsRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/securityrounds/SecurityViewDetails.dart';

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

}