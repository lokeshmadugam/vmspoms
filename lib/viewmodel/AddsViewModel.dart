
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:poms_app/model/AddsSliderModel.dart';

import 'package:poms_app/repository/AddsSliderRepo.dart';


import '../../data/respose/ApiResponse.dart';


class AddsViewModel extends ChangeNotifier {


  final _myRepo = AddsRepository();

  // Get Adds
  Future<ApiResponse<AddsSliderModel>> getAdds(String orderBy,
      String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId) async {
    ApiResponse<AddsSliderModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getAdds(
          orderBy, orderByPropertyName, pageNumber, pageSize, propertyId);
      listResponse = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        listResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return listResponse;
  }
}