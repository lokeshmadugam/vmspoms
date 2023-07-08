import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../AppException.dart';
import 'BaseApiServices.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future postApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Conection");
    }

    //if true then it'll return json response
    return responseJson;
  }

  Future postApiResponsewithtoken(
      String url, String token, dynamic data) async {
    dynamic responseJson;
    try {
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Conection");
    }

    //if true then it'll return json response
    return responseJson;
  }

  //For Get Api's
  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Conection");
    }

    //if true then it'll return json respose
    return responseJson;
  }

  @override
  Future getQueryResponse(String url, String token,
      Map<String, String> queryParameters, String? query) async {
    dynamic responseJson;

    try {
      final response = await http.get(
          Uri.parse(url + query!).replace(queryParameters: queryParameters),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Conection");
    }
    return responseJson;
  }

  @override
  Future getQueryResponsewithoutToken(
      String url, Map<String, String> queryParameters) async {
    dynamic responseJson;

    try {
      final response = await http.get(
          Uri.parse(url).replace(queryParameters: queryParameters),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': 'Bearer $token',
          });

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Conection");
    }
    return responseJson;
  }

  Future deleteApiResponsewithtoken(
      String url, String token, dynamic query) async {
    dynamic responseJson;
    try {
      var body = json.encode(query);

      var response = await http.delete(Uri.parse(url + query),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Conection");
    }

    //if true then it'll return json response
    return responseJson;
  }

  Future putApiResponsewithtoken(
      String url, String token, dynamic data, dynamic query) async {
    dynamic responseJson;
    try {
      var body = json.encode(data);

      var response = await http.put(Uri.parse(url + query),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Conection");
    }

    //if true then it'll return json response
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(message: response.body.toString());
      case 401:
        throw UnAuthorizedException(message: response.body.toString());
      case 404:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      default:
        throw FetchDataException(
            message: "Error occured while communicating with server " +
                "with status code " +
                response.statusCode.toString());
    }
  }
}
