class VisitorsStatusModel {
  int? status;
  String? message;
  Result? result;

  VisitorsStatusModel({this.status, this.message, this.result});

  VisitorsStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
  List<VisitorStatusItems>? items;

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
      items = <VisitorStatusItems>[];
      json['items'].forEach((v) {
        items!.add(new VisitorStatusItems.fromJson(v));
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

class VisitorStatusItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? configKeyId;
  String? appUsage;
  String? configKey;
  String? keyValue;
  String? description;
  int? seqNo;
  int? isDefault;
  int? recStatus;
  String? displayName;
  String? recStatusname;

  VisitorStatusItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.configKeyId,
      this.appUsage,
      this.configKey,
      this.keyValue,
      this.description,
      this.seqNo,
      this.isDefault,
      this.recStatus,
      this.displayName,
      this.recStatusname});

  VisitorStatusItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    configKeyId = json['config_key_id'];
    appUsage = json['app_usage'];
    configKey = json['config_key'];
    keyValue = json['key_value'];
    description = json['description'];
    seqNo = json['seq_no'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    displayName = json['display_name'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['config_key_id'] = this.configKeyId;
    data['app_usage'] = this.appUsage;
    data['config_key'] = this.configKey;
    data['key_value'] = this.keyValue;
    data['description'] = this.description;
    data['seq_no'] = this.seqNo;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['display_name'] = this.displayName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
