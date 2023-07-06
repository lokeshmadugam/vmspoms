import 'package:poms_app/model/CountryModel.dart';

import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiServices.dart';
import '../../model/PostApiResponse.dart';
import '../../resources/AppUrl.dart';
import '../model/ServiceType.dart';

class SignUpRepo {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> submitSignUpDetails(var data) async {

    try {
      var url = (AppUrl.signUp);

      dynamic response =
      await apiServices.postApiResponse(url, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getGender(var configKey) async {
    try {
      Map<String, String> queryParameters = {
        'configKey': configKey.toString(),
      };

      var url = AppUrl.configItemsUrl;

      dynamic response =
      await apiServices.getQueryResponse(url, '', queryParameters, '');

      final jsonData = ServiceType.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
  Future<dynamic> getCoutry(String orderBy,
      String orderByPropertyName, int pageNumber, int pageSize,) async {
    String orderby = orderBy;
    String orderByPN= orderByPropertyName;
    String pagenumber = pageNumber.toString();
    String pagesize = pageSize.toString();
    try {
      Map<String, String> queryParameters = {
        'orderBy':orderby,
        'orderByPropertyName':orderByPN,
        'pageNumber': pagenumber,
        'pageSize': pagesize,
      };

      var url = AppUrl.countryUrl;

      dynamic response =
      await apiServices.getQueryResponse(url, '', queryParameters, '');

      final jsonData = CountryModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

}