import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/ManagementSecurity.dart';
import '../../repository/ManagementSecurityRepo.dart';
import '../../model/EmergencyService.dart';
import '../../model/ServiceType.dart';
import '../../repository/EmergencyServiceRepo.dart';
import '../../data/respose/ApiResponse.dart';

class ManagementSecurityViewModel with ChangeNotifier {
  final _myRepo = ManagementSecurityRepo();

  Future<ApiResponse<ManagementSecurity>> fetchManagementContactList(
      var managementInHouseId, var propertyId) async {
    ApiResponse<ManagementSecurity> managementSecurityListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getManagementContactList(managementInHouseId, propertyId);
      managementSecurityListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        managementSecurityListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return managementSecurityListResponse;
  }


  Future<ApiResponse<ServiceType>> fetchServiceType(var serviceType) async {
    ApiResponse<ServiceType> serviceListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getServiceTypes(serviceType);
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
