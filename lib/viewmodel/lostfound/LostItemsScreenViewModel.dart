import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/DeleteResponse.dart';
import '../../model/PostApiResponse.dart';
import '../../model/lostfound/LostItems.dart';
import '../../repository/lostfound/LostItemsRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../utils/Utils.dart';

class LostItemsScreenViewModel extends ChangeNotifier {

  final _myRepo = LostItemsRepository();

  ApiResponse<LostItems> lostItems = ApiResponse.loading();


  void _setLostItemsList(ApiResponse<LostItems> response) {
    if (response.data != null) {
      lostItems = response;
      notifyListeners();
    }
  }

  Future<void> fetchLostItemsList(var propertyId) async {
    _setLostItemsList(ApiResponse.loading());
    _myRepo
        .getLostItemsList(propertyId)
        .then((value) => _setLostItemsList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setLostItemsList(ApiResponse.error(error.toString())));
  }
  // Delete Lost Item Data
  Future<ApiResponse<DeleteResponse>> deletetLostItemsDetails(var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteLostDetails(data);
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
}