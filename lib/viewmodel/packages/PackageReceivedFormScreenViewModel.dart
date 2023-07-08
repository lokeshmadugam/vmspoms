import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/packages/BlockUnitNumber.dart';
import '../../model/packages/DeliveryServiceModel.dart';
import '../../model/MediaUpload.dart';
import '../../model/packages/PackageReceivedRequest.dart';
import '../../model/packages/PackageStatus.dart';
import '../../model/packages/PackageType.dart';
import '../../model/PostApiResponse.dart';
import '../../repository/packages/PackageReceivedFormRepository.dart';
import '../../utils/Utils.dart';
import '../../data/respose/ApiResponse.dart';

class PackageReceivedFormScreenViewModel extends ChangeNotifier {
  final _myRepo = PackageReceivedFormRepository();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  PackageReceivedRequest request = PackageReceivedRequest();

  ApiResponse<DeliveryServiceModel> deliveryService = ApiResponse.loading();
  ApiResponse<PackageType> packageType = ApiResponse.loading();
  ApiResponse<PostApiResponse> postApiResponse = ApiResponse.loading();
  ApiResponse<MediaUpload> mediaUpload = ApiResponse.loading();
  ApiResponse<BlockUnitNumber> blockUnitNumber = ApiResponse.loading();
  ApiResponse<PackageStatus> packageStatus = ApiResponse.loading();

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

  void _setCreatePackage(
      ApiResponse<PostApiResponse> response, BuildContext context) {
    if (response.data != null) {
      postApiResponse = response;
      Utils.toastMessage(postApiResponse.data!.mobMessage.toString());
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> createReceivedPackage(
      PackageReceivedRequest request, BuildContext context) async {
    _setCreatePackage(ApiResponse.loading(), context);
    _myRepo
        .createReceivedPackage(request)
        .then((value) => _setCreatePackage(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
            _setCreatePackage(ApiResponse.error(error.toString()), context));
  }

  Future<void> updateReceivedPackage(
      PackageReceivedRequest request, BuildContext context) async {
    _setCreatePackage(ApiResponse.loading(), context);
    _myRepo
        .updateReceivedPackage(request)
        .then((value) => _setCreatePackage(ApiResponse.success(value), context))
        .onError((error, stackTrace) =>
            _setCreatePackage(ApiResponse.error(error.toString()), context));
  }

  Future<void> _setMediaUpload(ApiResponse<MediaUpload> response,
      BuildContext context, String signatureImagePath, var postOrPut) async {
    if (response.data != null) {
      mediaUpload = response;

      if (request.packageImg!.isEmpty) {
        request.packageImg = mediaUpload.data!.refName;
      } else {
        request.packageCollectionAckImg = mediaUpload.data!.refName;
      }

      if (signatureImagePath.isNotEmpty &&
          request.packageCollectionAckImg!.isEmpty) {
        await getMediaUpload(signatureImagePath, signatureImagePath, request,
            context, postOrPut);
      } else {
        if (request.packageImg!.isNotEmpty &&
            request.packageCollectionAckImg!.isNotEmpty) {
          updateReceivedPackage(request, context);
        } else {
          createReceivedPackage(request, context);
        }
      }
    }
  }

  Future<void> getMediaUpload(var imagePath, String signatureImagePath,
      var data, BuildContext context, var postOrPut) async {
    request = data;
    _setMediaUpload(
        ApiResponse.loading(), context, signatureImagePath, postOrPut);
    _myRepo
        .mediaUpload(imagePath)
        .then((value) => _setMediaUpload(
            ApiResponse.success(value), context, signatureImagePath, postOrPut))
        .onError((error, stackTrace) => _setMediaUpload(
            ApiResponse.error(error.toString()),
            context,
            signatureImagePath,
            postOrPut));
  }

  void _setBlockUnitNoList(ApiResponse<BlockUnitNumber> response) {
    if (response.data != null) {
      blockUnitNumber = response;
      notifyListeners();
    }
  }

  Future<void> fetchBlockUnitNoList(
      var blockName, var propertyId, var unitNo) async {
    _setBlockUnitNoList(ApiResponse.loading());
    _myRepo
        .getBlockUnitNoList(blockName, propertyId, unitNo)
        .then((value) => _setBlockUnitNoList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
            _setBlockUnitNoList(ApiResponse.error(error.toString())));
  }

  /* void _setPackageStatus(ApiResponse<PackageStatus> response) {
    if (response.data != null) {
      packageStatus = response;
      notifyListeners();
    }
  }

  Future<void> fetchPackageStatusaa() async {
    _setPackageStatus(ApiResponse.loading());
    _myRepo
        .getPackageStatus()
        .then((value) => _setPackageStatus(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setPackageStatus(ApiResponse.error(error.toString())));
  }*/

  Future<ApiResponse<PackageStatus>> fetchPackageStatus() async {
    ApiResponse<PackageStatus> response = ApiResponse.loading();
    try {
      var value = await _myRepo.getPackageStatus();
      response = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        response = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return response;
  }
}
