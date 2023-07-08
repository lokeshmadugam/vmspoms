import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/DeleteResponse.dart';
import '../../model/packages/PackageExpected.dart';
import '../../model/packages/PackageReceived.dart';
import '../../repository/packages/PackageExpectedRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../repository/packages/PackageReceivedRepository.dart';
import '../../utils/Utils.dart';

class PackageExpectedScreenViewModel extends ChangeNotifier {
  final _myRepo = PackageExpectedRepository();

  ApiResponse<PackageExpected> packageExpected = ApiResponse.loading();

  void _setPackageExpectList(ApiResponse<PackageExpected> response) {
    if (response.data != null) {
      packageExpected = response;
      notifyListeners();
    }
  }

  Future<void> fetchPackageExpectedList(var propertyId) async {
    _setPackageExpectList(ApiResponse.loading());
    _myRepo
        .getPackageExpectedList(propertyId)
        .then((value) => _setPackageExpectList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
            _setPackageExpectList(ApiResponse.error(error.toString())));
  }

  // Delete Expected Data
  Future<ApiResponse<DeleteResponse>> deleteExpectedDetails(
      var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();

    try {
      DeleteResponse value = await _myRepo.deleteExpectedDetails(data);
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
