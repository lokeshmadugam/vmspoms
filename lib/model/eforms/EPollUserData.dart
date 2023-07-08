class EPollUserData {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  EPollUserData(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  EPollUserData.fromJson(Map<String, dynamic> json) {
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
  List<PollItems>? items;

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
      items = <PollItems>[];
      json['items'].forEach((v) {
        items!.add(new PollItems.fromJson(v));
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

class PollItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? userId;
  int? admModuleId;
  int? epollingId;
  bool? hideForAll;
  int? epollingcatGroupId;
  String? fiedData;
  String? attachmentId;
  int? epollingStatus;
  int? recStatus;
  String? moduleName;
  String? epollingName;
  String? epollingStatusName;
  String? recStatusname;

  PollItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.userId,
      this.admModuleId,
      this.epollingId,
      this.hideForAll,
      this.epollingcatGroupId,
      this.fiedData,
      this.attachmentId,
      this.epollingStatus,
      this.recStatus,
      this.moduleName,
      this.epollingName,
      this.epollingStatusName,
      this.recStatusname});

  PollItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    userId = json['user_id'];
    admModuleId = json['adm_module_id'];
    epollingId = json['epolling_id'];
    hideForAll = json['hide_for_all'];
    epollingcatGroupId = json['epollingcat_group_id'];
    fiedData = json['fied_data'];
    attachmentId = json['attachment_id'];
    epollingStatus = json['epolling_status'];
    recStatus = json['rec_status'];
    moduleName = json['moduleName'];
    epollingName = json['epollingName'];
    epollingStatusName = json['epollingStatusName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['user_id'] = this.userId;
    data['adm_module_id'] = this.admModuleId;
    data['epolling_id'] = this.epollingId;
    data['hide_for_all'] = this.hideForAll;
    data['epollingcat_group_id'] = this.epollingcatGroupId;
    data['fied_data'] = this.fiedData;
    data['attachment_id'] = this.attachmentId;
    data['epolling_status'] = this.epollingStatus;
    data['rec_status'] = this.recStatus;
    data['moduleName'] = this.moduleName;
    data['epollingName'] = this.epollingName;
    data['epollingStatusName'] = this.epollingStatusName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
