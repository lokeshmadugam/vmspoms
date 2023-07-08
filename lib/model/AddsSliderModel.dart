class AddsSliderModel {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  AddsSliderModel(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  AddsSliderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    megCategory = json['megCategory'];
    webMessage = json['webMessage'];
    mobMessage = json['mobMessage'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['megCategory'] = this.megCategory;
    data['webMessage'] = this.webMessage;
    data['mobMessage'] = this.mobMessage;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? pageNumber;
  int? pageSize;
  int? totalPage;
  int? itemCounts;
  int? totalItemCounts;
  String? orderBy;
  String? orderByPropertyName;
  List<AddItems>? items;

  Result(
      {this.pageNumber,
      this.pageSize,
      this.totalPage,
      this.itemCounts,
      this.totalItemCounts,
      this.orderBy,
      this.orderByPropertyName,
      this.items});

  Result.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    itemCounts = json['itemCounts'];
    totalItemCounts = json['totalItemCounts'];
    orderBy = json['orderBy'];
    orderByPropertyName = json['orderByPropertyName'];
    if (json['items'] != null) {
      items = <AddItems>[];
      json['items'].forEach((v) {
        items!.add(new AddItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['itemCounts'] = this.itemCounts;
    data['totalItemCounts'] = this.totalItemCounts;
    data['orderBy'] = this.orderBy;
    data['orderByPropertyName'] = this.orderByPropertyName;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddItems {
  int? id;
  int? createdBy;
  String? createdOn;
  String? propertyIds;
  String? country;
  String? state;
  String? city;
  String? sliderImg;
  String? sliderImgEmbededUrl;
  String? sliderText;
  String? dispFromDatetime;
  String? dispToDatetime;
  int? noAdsHideSlider;
  String? iconUrl;
  int? recStatus;
  String? recStatusname;
  String? countryName;
  String? svgFlagUrl;
  String? mobFlagUrl;

  AddItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyIds,
      this.country,
      this.state,
      this.city,
      this.sliderImg,
      this.sliderImgEmbededUrl,
      this.sliderText,
      this.dispFromDatetime,
      this.dispToDatetime,
      this.noAdsHideSlider,
      this.iconUrl,
      this.recStatus,
      this.recStatusname,
      this.countryName,
      this.svgFlagUrl,
      this.mobFlagUrl});

  AddItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyIds = json['property_ids'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    sliderImg = json['slider_img'];
    sliderImgEmbededUrl = json['slider_img_embeded_url'];
    sliderText = json['slider_text'];
    dispFromDatetime = json['disp_from_datetime'];
    dispToDatetime = json['disp_to_datetime'];
    noAdsHideSlider = json['no_ads_hide_slider'];
    iconUrl = json['icon_url'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    countryName = json['countryName'];
    svgFlagUrl = json['svg_flag_url'];
    mobFlagUrl = json['mob_flag_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_ids'] = this.propertyIds;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['slider_img'] = this.sliderImg;
    data['slider_img_embeded_url'] = this.sliderImgEmbededUrl;
    data['slider_text'] = this.sliderText;
    data['disp_from_datetime'] = this.dispFromDatetime;
    data['disp_to_datetime'] = this.dispToDatetime;
    data['no_ads_hide_slider'] = this.noAdsHideSlider;
    data['icon_url'] = this.iconUrl;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['countryName'] = this.countryName;
    data['svg_flag_url'] = this.svgFlagUrl;
    data['mob_flag_url'] = this.mobFlagUrl;
    return data;
  }
}
