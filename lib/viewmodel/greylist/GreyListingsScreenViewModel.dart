import 'package:flutter/cupertino.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/greylist/GreyList.dart';
import '../../repository/greylist/GreyListingsRepository.dart';


class GreyListingsScreenViewModel extends ChangeNotifier {

  final _myRepo = GreyListingsRepository();

  ApiResponse<GreyList> greyList = ApiResponse.loading();


  void _setGreyListings(ApiResponse<GreyList> response) {
    if (response.data != null) {
      greyList = response;
      notifyListeners();
    }
  }

  Future<void> fetchGreyListings(var propertyId) async {
    _setGreyListings(ApiResponse.loading());
    _myRepo
        .getGreyListingsList(propertyId)
        .then((value) => _setGreyListings(ApiResponse.success(value)))
        .onError((error, stackTrace) =>
        _setGreyListings(ApiResponse.error(error.toString())));
  }

}