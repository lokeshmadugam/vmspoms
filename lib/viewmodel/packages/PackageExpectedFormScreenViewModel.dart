import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/packages/DeliveryServiceModel.dart';
import '../../model/packages/PackageType.dart';
import '../../model/PostApiResponse.dart';
import '../../repository/packages/PackageExpectedFormRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/packages/BlockUnitNumber.dart';
import '../../utils/Utils.dart';

class PackageExpectedFormScreenViewModel extends ChangeNotifier {

  final _myRepo = PackageExpectedFormRepository();

  ApiResponse<DeliveryServiceModel> deliveryService = ApiResponse.loading();
  ApiResponse<PackageType> packageType = ApiResponse.loading();
  ApiResponse<PostApiResponse> postApiResponse = ApiResponse.loading();
  ApiResponse<BlockUnitNumber> blockUnitNumber = ApiResponse.loading();

  void _setDeliveryServiceList(ApiResponse<DeliveryServiceModel> response) {
    if (response.data != null) {
      deliveryService = response;
      notifyListeners();
    }
  }

  Future<void> fetchDeliveryServiceList(var countryCode) async {
    _setDeliveryServiceList(ApiResponse.loading());
    _myRepo
        .getDeliveryServiceList(countryCode)
        .then((value) => _setDeliveryServiceList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setDeliveryServiceList(ApiResponse.error(error.toString())));
  }

  void _setPackageTypeList(ApiResponse<PackageType> response) {
    if (response.data != null) {
      packageType = response;
      notifyListeners();
    }
  }

  Future<void> fetchPackageTypeList() async {
    _setPackageTypeList(ApiResponse.loading());
    _myRepo
        .getPackageTypeList()
        .then((value) => _setPackageTypeList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setPackageTypeList(ApiResponse.error(error.toString())));
  }

  void _setCreatePackage(ApiResponse<PostApiResponse> response, BuildContext context) {
    if (response.data != null) {
      postApiResponse = response;
      Utils.toastMessage(postApiResponse.data!.mobMessage.toString());
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> createExpectedPackage(var data, BuildContext context) async {
    _setCreatePackage(ApiResponse.loading(), context);
    _myRepo
        .createExpectedPackage(data)
        .then((value) => _setCreatePackage(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
        _setCreatePackage(ApiResponse.error(error.toString()), context));
  }

  Future<void> updateExpectedPackage(var data, var packageId, BuildContext context) async {
    _setCreatePackage(ApiResponse.loading(), context);
    _myRepo
        .updateExpectedPackage(data, packageId)
        .then((value) => _setCreatePackage(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
        _setCreatePackage(ApiResponse.error(error.toString()), context));
  }

  void _setBlockUnitNoList(ApiResponse<BlockUnitNumber> response) {
    if (response.data != null) {
      blockUnitNumber = response;
      notifyListeners();
    }
  }

  Future<void> fetchBlockUnitNoList(var blockName, var propertyId, var unitNo) async {
    _setBlockUnitNoList(ApiResponse.loading());
    _myRepo
        .getBlockUnitNoList(blockName, propertyId, unitNo)
        .then((value) => _setBlockUnitNoList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setBlockUnitNoList(ApiResponse.error(error.toString())));
  }
}
