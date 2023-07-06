import 'package:flutter/cupertino.dart';
import '../../model/lostfound/LostFoundRequest.dart';
import '../../repository/lostfound/LostDetailsFormRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../utils/Utils.dart';

class LostDetailsFormScreenViewModel extends ChangeNotifier {
  final _myRepo = LostDetailsFormRepository();

  ApiResponse<PostApiResponse> postApiResponse = ApiResponse.loading();
  ApiResponse<MediaUpload> mediaUpload = ApiResponse.loading();

  Future<void> _setMediaUpload(
      ApiResponse<MediaUpload> response, var data, BuildContext context) async {
    if (response.data != null) {
      mediaUpload = response;
      data['lost_item_img_url'] = mediaUpload.data!.refName;

      submitLostFoundDetails(data, context);
    }
  }

  Future<void> getMediaUpload(
      var imagePath, var data, BuildContext context) async {
    _setMediaUpload(ApiResponse.loading(), data, context);
    _myRepo
        .mediaUpload(imagePath)
        .then((value) => _setMediaUpload(ApiResponse.success(value), data, context))
        .onError((error, stackTrace) =>
            _setMediaUpload(ApiResponse.error(error.toString()), data, context));
  }

  void _setSubmitLostFoundDetails(
      ApiResponse<PostApiResponse> response, BuildContext context) {
    if (response.data != null) {
      postApiResponse = response;
      Utils.toastMessage(postApiResponse.data!.mobMessage.toString());
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> submitLostFoundDetails(var data, BuildContext context) async {
    _setSubmitLostFoundDetails(ApiResponse.loading(), context);
    _myRepo
        .submitLostDetailsForm(data)
        .then((value) =>
            _setSubmitLostFoundDetails(ApiResponse.success(value), context))
        .onError((error, stackTrace) => _setSubmitLostFoundDetails(
            ApiResponse.error(error.toString()), context));
  }
}
