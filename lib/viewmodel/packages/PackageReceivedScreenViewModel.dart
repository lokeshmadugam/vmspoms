import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/DeleteResponse.dart';
import '../../model/packages/PackageReceived.dart';
import '../../data/respose/ApiResponse.dart';
import '../../repository/packages/PackageReceivedRepository.dart';
import '../../utils/Utils.dart';

class PackageReceivedScreenViewModel extends ChangeNotifier {

  final _myRepo = PackageReceivedRepository();

  ApiResponse<PackageReceived> packageReceipt = ApiResponse.loading();

  void _setPackageReceiptList(ApiResponse<PackageReceived> response) {
    if (response.data != null) {
      packageReceipt = response;
      notifyListeners();
    }
  }

  Future<void> fetchPackageReceiptsList(var propertyId, var unitNo) async {
    _setPackageReceiptList(ApiResponse.loading());
    _myRepo
        .getPackageReceivedList(propertyId, unitNo)
        .then((value) => _setPackageReceiptList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setPackageReceiptList(ApiResponse.error(error.toString())));
  }
  // Delete Received Data
  Future<ApiResponse<DeleteResponse>> deletetReceivedDetails(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();

    try {
      DeleteResponse value = await _myRepo.deleteReceivedDetails(data);
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
