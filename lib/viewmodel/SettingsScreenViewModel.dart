import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../data/respose/ApiResponse.dart';
import '../model/CompanyPolicies.dart';
import '../repository/SettingsRepo.dart';

class SettingsScreenViewModel with ChangeNotifier {
  final _myRepo = SettingsRepo();

  Future<ApiResponse<CompanyPolicies>> fetchCompanyPolicyList(
      var propertyId) async {
    ApiResponse<CompanyPolicies> companyPolicyResponse = ApiResponse.loading();

    try {
      final value =
          await _myRepo.getCompanyPolicyList(propertyId);
      companyPolicyResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        companyPolicyResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return companyPolicyResponse;
  }
}
