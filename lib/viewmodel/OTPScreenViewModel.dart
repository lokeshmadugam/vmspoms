import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../repository/OTPRepo.dart';
import '../data/respose/ApiResponse.dart';
import '../model/PostApiResponse.dart';
import '../utils/Utils.dart';

class OTPScreenViewModel extends ChangeNotifier {
  final _myRepo = OTPRepo();

  Future<ApiResponse<PostApiResponse>> verifyEmail(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    try {
      PostApiResponse value = await _myRepo.verifyEmail(data);
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


}
