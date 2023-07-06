import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:poms_app/model/visitorreg/FavoriteVisitors.dart';
import 'package:poms_app/model/visitorreg/ParkingModel.dart';
import '../../model/DeleteResponse.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/PostApiResponse.dart';
import '../../model/visitorreg/VehicleTypeModel.dart';
import '../../model/visitorreg/VisitReasonModel.dart';
import '../../model/visitorreg/VisitorDetailsModel.dart';
import '../../model/visitorreg/VisitorTypeModel.dart';
import '../../model/visitorreg/VisitorsListModel.dart';
import '../../model/visitorreg/VisitorsStatusModel.dart';
import '../../repository/visitorreg/Invitevisitorrepo.dart';
import '../../utils/utils.dart';

class InviteVisitorViewModel extends ChangeNotifier {



var visitorDetails;




  var orgId = 0;
  var userId = 0;

  final _myRepo = InviteVisitorRepository();
  //VisitType
  ApiResponse<VisitorTypeModel> visitTypeResponse = ApiResponse.loading();
  setVisitTypeResponse(ApiResponse<VisitorTypeModel> response) {
    visitTypeResponse = response;
    notifyListeners();
  }
  Future<void> getVisitorType1() async {
    _myRepo
        .getVisitorTypes()
        .then((value) {
      setVisitTypeResponse(
        ApiResponse.success(value),
      );
      print("response = $value");
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        setVisitTypeResponse(ApiResponse.error(error.toString()));
        print(error);
      }
    });
  }
Future<ApiResponse<VisitorTypeModel>> getVisitorType(
   ) async {
  ApiResponse<VisitorTypeModel> listResponse = ApiResponse.loading();

  try {
    final value = await _myRepo.getVisitorTypes();
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

//VisitReason
  ApiResponse<VisitReasonModel> visitReasonResponse = ApiResponse.loading();
  setVisitReasonResponse(ApiResponse<VisitReasonModel> response) {
    visitReasonResponse = response;
    notifyListeners();
  }
  Future<void> getVisitReasons1() async {
    _myRepo
        .getVisitReasons()
        .then((value) {
      setVisitReasonResponse(
        ApiResponse.success(value),
      );
      print("response = $value");
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        setVisitReasonResponse(ApiResponse.error(error.toString()));
        print(error);
      }
    });
  }
Future<ApiResponse<VisitReasonModel>> getVisitReasons(
   ) async {
  ApiResponse<VisitReasonModel> listResponse = ApiResponse
      .loading();

  try {
    final value = await _myRepo.getVisitReasons();
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
// VehicleType
  ApiResponse<VehicleTypeModel> vehicleTypeResponse = ApiResponse.loading();
  setVehicleTypeResponse(ApiResponse<VehicleTypeModel> response) {
    vehicleTypeResponse = response;
    notifyListeners();
  }
  Future<void> getVehicleTypes1() async {
    _myRepo
        .getVehicleType()
        .then((value) {
      setVehicleTypeResponse(
        ApiResponse.success(value),
      );
      print("response = $value");
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        setVisitReasonResponse(ApiResponse.error(error.toString()));
        print(error);
      }
    });
  }
  Future<ApiResponse<VehicleTypeModel>> getVehicleTypes(
     ) async {
    ApiResponse<VehicleTypeModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getVehicleType();
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
  // Get All Visitors List
  Future<ApiResponse<VisitorsListModel>> getVisitorsList(
      String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId) async {
    ApiResponse<VisitorsListModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getVisitList(orderBy, orderByPropertyName, pageNumber, pageSize, propertyId);
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
  // Visitors Status

  ApiResponse<VisitorsStatusModel> _visitorStatusResponse = ApiResponse.loading();

  ApiResponse<VisitorsStatusModel> get visitorStatusResponse => _visitorStatusResponse;

  void setVisitorStatusResponse(ApiResponse<VisitorsStatusModel> response) {
    _visitorStatusResponse = response;
    notifyListeners();
  }

  Future<void> getVisitorsStatus1(String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, String appUseage ,String configKey) async {
    try {
      final result = await _myRepo.getVisitorStatus(
        orderBy,
        orderByPropertyName,
        pageNumber,
        pageSize,
        appUseage,
        configKey,
      );
      setVisitorStatusResponse(ApiResponse.success(result));
    } catch (e) {
      setVisitorStatusResponse(ApiResponse.error(e.toString()));
      print(e);
    }
  }
  Future<ApiResponse<VisitorsStatusModel>> getVisitorsStatus(String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, String appUseage ,String configKey
      ) async {
    ApiResponse<VisitorsStatusModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getVisitorStatus(
        orderBy,
        orderByPropertyName,
        pageNumber,
        pageSize,
        appUseage,
        configKey,
      );;
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
  Future<ApiResponse<PostApiResponse>> visitorRegistration(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.visitorregistration(data);
      response = ApiResponse.success(value);

      // if (value.status == 200){
        // print('response = ${value.message}');
        // Utils.flushBarErrorMessage("${value.message}", context);
        // final result = value.result;


      // } else {
      //   Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
      // }
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
    }

    if (kDebugMode) {
      print(response.toString());
    }

    return response;
  }



  // ApiResponse<VisitorDetailsModel> visitorDetailsResponse = ApiResponse.loading();
  // setVisitorDetailsResponse(ApiResponse<VisitorDetailsModel> response) {
  //   visitorDetailsResponse = response;
  //   notifyListeners();
  // }
  //
  // Future<void> getVisitorDetails(int id) async {
  //   myRepo.getVisitorDetails(id).then((value) {
  //     setVisitorDetailsResponse(
  //       ApiResponse.success(value),
  //     );
  //     print("response = $value");
  //   }).onError((error, stackTrace) {
  //     if (kDebugMode) {
  //       setVisitReasonResponse(ApiResponse.error(error.toString()));
  //       print(error);
  //     }
  //   });
  // }
  // Get Visitor Details
  Future<ApiResponse<VisitorDetailsModel>> getVisitorDetails(int id) async {
    ApiResponse<VisitorDetailsModel> response = ApiResponse.loading();
    try {
      var value = await _myRepo.getVisitorDetails(id);
      response = ApiResponse.success(value);
      print("response = $value");
    } catch (error) {
      if (kDebugMode) {
        response = ApiResponse.error(error.toString());
        print(error);
      }
    }
    return response;
  }
// Update Visitor Registration
  Future<ApiResponse<PostApiResponse>> updateVisitorRegistration(var data,int id, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.updateVisitorDetails(data,id);
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
  // Delete Visitor Data
  Future<ApiResponse<DeleteResponse>> deletetVisitorDetails(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteVisitorDetails(data);
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
  Future<ApiResponse<PostApiResponse>> addFavoriteVisitor(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _myRepo.addFavoriteVisitorRegistration(data);
      response = ApiResponse.success(value);

      // if (value.status == 200){
      // print('response = ${value.message}');
      // Utils.flushBarErrorMessage("${value.message}", context);
      // final result = value.result;


      // } else {
      //   Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
      // }
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
      response = ApiResponse.error(error.toString());
    }

    if (kDebugMode) {
      print(response.toString());
    }

    return response;
  }

  // Get All Visitors List
  Future<ApiResponse<FavoriteVisitorModel>> getFavoriteVisitors(
      String orderBy, String orderByPropertyName,
      int pageNumber, int pageSize, int propertyId,int userId) async {
    ApiResponse<FavoriteVisitorModel> listResponse = ApiResponse
        .loading();

    try {
      final value = await _myRepo.getFavoriteVisitorList(orderBy, orderByPropertyName, pageNumber, pageSize, propertyId,userId);
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






//Visitor Registration

// ApiResponse<PostApiResponse> postlistResponse = ApiResponse.loading();
// setPostListResponse(ApiResponse<PostApiResponse> response) {
//   postlistResponse = response;
//   notifyListeners();
// }
// Future<void> visitorRegistration(var data, BuildContext context) async {
//
//   myRepo.visitorregistration(data).then((value) {
//
//     setPostListResponse(ApiResponse.success(value));
//     if (value.status == 200){
//      print('response = ${value.message}');
//       Utils.flushBarErrorMessage("${value.message}", context);
//       final id = value.result;
//       visitorId = id;
//       getVisitorDetails(id);
//     }else {
//       Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
//     }
//
//     if (kDebugMode) {
//       print(value.toString());
//     }
//   }).onError((error, stackTrace) {
//
//     if (kDebugMode) {
//       Utils.flushBarErrorMessage(error.toString(), context);
//       print(error.toString());
//     }
//   });
// }