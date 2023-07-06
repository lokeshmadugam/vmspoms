import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../model/lostfound/LostFoundRequest.dart';
import '../../repository/lostfound/EditLostDetailsFormRepository.dart';
import '../../repository/lostfound/LostDetailsFormRepository.dart';
import '../../data/respose/ApiResponse.dart';
import '../../model/MediaUpload.dart';
import '../../model/PostApiResponse.dart';
import '../../utils/Utils.dart';

class EditLostDetailsFormScreenViewModel extends ChangeNotifier {
  final _myRepo = EditLostDetailsFormRepository();
  final _lostDeRepo = LostDetailsFormRepository();
  var lostID;

  ApiResponse<PostApiResponse> postApiResponse = ApiResponse.loading();
  ApiResponse<MediaUpload> mediaUpload = ApiResponse.loading();

  Future<void> _setMediaUpload(
      ApiResponse<MediaUpload> response, var data, BuildContext context) async {
    if (response.data != null) {
      mediaUpload = response;
      data['found_by_item_pic'] = mediaUpload.data!.refName;
      data['lost_item_img_url'] = mediaUpload.data!.refName;

      // updateEditLostFoundDetails(data, context);
    }
  }

  Future<void> getMediaUpload(var imagePath, var data, BuildContext context, var lostId) async {
   lostID = lostId;
    _setMediaUpload(ApiResponse.loading(), data, context);
    _myRepo
        .mediaUpload(imagePath)
        .then((value) => _setMediaUpload(ApiResponse.success(value), data, context))
        .onError((error, stackTrace) =>
        _setMediaUpload(ApiResponse.error(error.toString()), data, context));
  }

  void _setUpdateLostFoundDetails(
      ApiResponse<PostApiResponse> response, BuildContext context) {
    if (response.data != null) {
      postApiResponse = response;
      Utils.toastMessage(postApiResponse.data!.mobMessage.toString());
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> updateEditLostFoundDetails(var id,var data, BuildContext context) async {
    _setUpdateLostFoundDetails(ApiResponse.loading(), context);
    _myRepo
        .updateLostDetailsForm(id, data)
        .then((value) =>
        _setUpdateLostFoundDetails(ApiResponse.success(value), context))
        .onError((error, stackTrace) => _setUpdateLostFoundDetails(
        ApiResponse.error(error.toString()), context));
  }
  Future<ApiResponse<PostApiResponse>> createUnclaimedData(var data, BuildContext context) async {
    ApiResponse<PostApiResponse> response = ApiResponse.loading();
    notifyListeners();
    PostApiResponse postListResult;
    try {
      PostApiResponse value = await _lostDeRepo.submitLostDetailsForm(data);
      response = ApiResponse.success(value);

      if (value.status == 201){
      print('response = ${value.mobMessage}');
      Utils.flushBarErrorMessage("${value.mobMessage}", context);
      final result = value.result;


      } else {
        Utils.flushBarErrorMessage(" Registration Failed".toString(), context);
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
