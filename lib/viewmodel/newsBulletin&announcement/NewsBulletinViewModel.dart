import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '/model/newsbulletin/NewsBulletinModel.dart';
import '/repository/newsbulletin&announcement/NewsbulletinRepository.dart';

import '../../data/respose/ApiResponse.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';

class NewsButtelinViewModel extends ChangeNotifier {
  final _myRepo = NewsBulletinRepository();

  // News and Announcements
  Future<ApiResponse<VisitorsStatusModel>> getNewsandAnnouncements(
      String orderBy,
      String orderByPropertyName,
      int pageNumber,
      int pageSize,
      String appUseage,
      String configKey) async {
    ApiResponse<VisitorsStatusModel> listResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getNewsandAnnouncements(
        orderBy,
        orderByPropertyName,
        pageNumber,
        pageSize,
        appUseage,
        configKey,
      );
      listResponse = ApiResponse.success(value);
      print("response = $listResponse");
    } catch (error) {
      if (kDebugMode) {
        listResponse = ApiResponse.error(error.toString());
        print(error);
      }
    }

    return listResponse;
  }

// Get News List
  Future<ApiResponse<NewsBulletinModel>> getNewsList(
      String orderBy,
      String orderByPropertyName,
      int pageNumber,
      int pageSize,
      String propertyId,
      int Id) async {
    ApiResponse<NewsBulletinModel> listResponse = ApiResponse.loading();

    try {
      final value = await _myRepo.getNewsList(
          orderBy, orderByPropertyName, pageNumber, pageSize, propertyId, Id);
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
