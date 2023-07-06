import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:poms_app/model/houserules/HouseRulesModel.dart';
import 'package:poms_app/model/houserules/RulesModel.dart';
import 'package:poms_app/repository/houserules/HouseRulesRepo.dart';

import '../../data/respose/ApiResponse.dart';
import '../../model/intercom/IntercomListingModel.dart';

class HouseRulesViewModel extends ChangeNotifier {


  final _myRepo = HouseRulesRepository();

// Get All HouseRules List
  Future<ApiResponse<HouseRulesModel>> getHouseRulesList(String orderBy,
      String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId,) async {
    ApiResponse<HouseRulesModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getHouseRulesList(
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
// Get All Rules
  Future<ApiResponse<RulesModel>> getRules(String orderBy,
      String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId,int documentId) async {
    ApiResponse<RulesModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getRules(orderBy, orderByPropertyName, pageNumber, pageSize, propertyId, documentId);
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