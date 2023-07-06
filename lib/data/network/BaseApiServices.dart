

abstract class BaseApiServices {
  Future<dynamic> postApiResponse(String url, dynamic data);

  Future<dynamic> postApiResponsewithtoken(
      String url, String token, dynamic data);

  Future<dynamic> getQueryResponse(String url, String token,
      Map<String, String> queryParameters, String? query);

  Future<dynamic> getQueryResponsewithoutToken(
      String url, Map<String, String> queryParameters);

  Future<dynamic> deleteApiResponsewithtoken(
      String url, String token, dynamic query);

  Future<dynamic> putApiResponsewithtoken(String url, String token,
      dynamic data, dynamic query);
}





