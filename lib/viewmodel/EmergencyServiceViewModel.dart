import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/EmergencyService.dart';
import '../../model/ServiceType.dart';
import '../../repository/EmergencyServiceRepo.dart';
import '../../data/respose/ApiResponse.dart';

class EmergencyServcieViewModel with ChangeNotifier {
  final _myRepo = EmergencyServiceRepo();

  Future<ApiResponse<EmergencyService>> fetchEmergencyServiceList(
      var countryCode, var serviceTypeId, var subServiceTypeId) async {
    ApiResponse<EmergencyService> emergencyListResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getEmergencyServices(
          countryCode, serviceTypeId, subServiceTypeId);
      emergencyListResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        emergencyListResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return emergencyListResponse;
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
