class EFormCategoryName {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  EFormCategoryName(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  EFormCategoryName.fromJson(Map<String, dynamic> json) {
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
  List<EFormCategoryItems>? items;

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
      items = <EFormCategoryItems>[];
      json['items'].forEach((v) {
        items!.add(new EFormCategoryItems.fromJson(v));
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

class EFormCategoryItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  String? eformCategoryName;
  String? description;
  String? iconUrl;
  int? isDefault;
  int? recStatus;
  String? recStatusname;
  String? propertyEformsRest;

  EFormCategoryItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.eformCategoryName,
        this.description,
        this.iconUrl,
        this.isDefault,
        this.recStatus,
        this.recStatusname,
        this.propertyEformsRest});

  EFormCategoryItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    eformCategoryName = json['eform_category_name'];
    description = json['description'];
    iconUrl = json['icon_url'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    propertyEformsRest = json['propertyEformsRest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['eform_category_name'] = this.eformCategoryName;
    data['description'] = this.description;
    data['icon_url'] = this.iconUrl;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['propertyEformsRest'] = this.propertyEformsRest;
    return data;
  }
}
