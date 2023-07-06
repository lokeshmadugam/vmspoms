class EPollCategoryName {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  EPollCategoryName(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  EPollCategoryName.fromJson(Map<String, dynamic> json) {
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
  List<EPollCategoryItems>? items;

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
      items = <EPollCategoryItems>[];
      json['items'].forEach((v) {
        items!.add(new EPollCategoryItems.fromJson(v));
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

class EPollCategoryItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  String? epollingCategoryName;
  String? description;
  String? iconUrl;
  int? isDefault;
  int? recStatus;
  String? recStatusname;
  String? propertyEpollingRest;

  EPollCategoryItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.epollingCategoryName,
        this.description,
        this.iconUrl,
        this.isDefault,
        this.recStatus,
        this.recStatusname,
        this.propertyEpollingRest});

  EPollCategoryItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    epollingCategoryName = json['epolling_category_name'];
    description = json['description'];
    iconUrl = json['icon_url'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    propertyEpollingRest = json['propertyEpollingRest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['epolling_category_name'] = this.epollingCategoryName;
    data['description'] = this.description;
    data['icon_url'] = this.iconUrl;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['propertyEpollingRest'] = this.propertyEpollingRest;
    return data;
  }
}
