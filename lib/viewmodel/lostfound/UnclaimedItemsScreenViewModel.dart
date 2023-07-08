import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/DeleteResponse.dart';
import '../../model/lostfound/LostItems.dart';
import '../../model/lostfound/UnclaimedItems.dart';
import '../../repository/lostfound/LostItemsRepository.dart';
import '../../repository/lostfound/UnclaimedItemsRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../utils/Utils.dart';

class UnclaimedItemsScreenViewModel extends ChangeNotifier {
  final _myRepo = UnclaimedItemsRepository();

  ApiResponse<UnclaimedItems> unclaimedItems = ApiResponse.loading();

  void _setUnclaimedItemsList(ApiResponse<UnclaimedItems> response) {
    if (response.data != null) {
      unclaimedItems = response;
      notifyListeners();
    }
  }

  Future<void> fetchUnclaimedItemsList(var propertyId, var id) async {
    _setUnclaimedItemsList(ApiResponse.loading());
    _myRepo
        .getUnclaimedItemsList(propertyId, id)
        .then((value) => _setUnclaimedItemsList(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
            _setUnclaimedItemsList(ApiResponse.error(error.toString())));
  }

  // Delete Unclaimed Item Data
  Future<ApiResponse<DeleteResponse>> deletetUnclaimedItemsDetails(
      var data, BuildContext context) async {
    ApiResponse<DeleteResponse> response = ApiResponse.loading();
    notifyListeners();
    // PostApiResponse postListResult;
    try {
      DeleteResponse value = await _myRepo.deleteUnclaimedDetails(data);
      response = ApiResponse.success(value);

      if (value.status == 200) {
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
