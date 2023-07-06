import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiServices.dart';
import '../model/PostApiResponse.dart';
import '../resources/AppUrl.dart';

class OTPRepo {
  BaseApiServices apiServices = NetworkApiService();

  Future<dynamic> verifyEmail(var data) async {

    try {
      var url = (AppUrl.verifyEmail);

      dynamic response =
      await apiServices.postApiResponse(url, data);

      final jsonData = PostApiResponse.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

}