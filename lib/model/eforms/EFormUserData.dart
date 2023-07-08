class EFormUserData {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  EFormUserData(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  EFormUserData.fromJson(Map<String, dynamic> json) {
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
  List<UserDataItems>? items;

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
      items = <UserDataItems>[];
      json['items'].forEach((v) {
        items!.add(new UserDataItems.fromJson(v));
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

class UserDataItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? userId;
  String? unitNo;
  int? admModuleId;
  int? eformsId;
  bool? hideForAll;
  int? eformcatGroupId;
  String? fiedData;
  String? attachmentId;
  int? eformsStatusInt;
  int? approvedBy;
  String? approvedOn;
  String? remark;
  int? recStatus;
  String? moduleName;
  String? eformName;
  String? eformsStatus;
  String? recStatusname;
  List<Remarks>? remarks;

  UserDataItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.userId,
      this.unitNo,
      this.admModuleId,
      this.eformsId,
      this.hideForAll,
      this.eformcatGroupId,
      this.fiedData,
      this.attachmentId,
      this.eformsStatus,
      this.approvedBy,
      this.approvedOn,
      this.remark,
      this.recStatus,
      this.moduleName,
      this.eformName,
      this.eformsStatusInt,
      this.recStatusname,
      this.remarks});

  UserDataItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    userId = json['user_id'];
    unitNo = json['unit_no'];
    admModuleId = json['adm_module_id'];
    eformsId = json['eforms_id'];
    hideForAll = json['hide_for_all'];
    eformcatGroupId = json['eformcat_group_id'];
    fiedData = json['fied_data'];
    attachmentId = json['attachment_id'];
    eformsStatusInt = json['eforms_status'];
    approvedBy = json['approved_by'];
    approvedOn = json['approved_on'];
    remark = json['remark'];
    recStatus = json['rec_status'];
    moduleName = json['moduleName'];
    eformName = json['eformName'];
    eformsStatus = json['eformsStatus'];
    recStatusname = json['recStatusname'];
    if (json['remarks'] != null) {
      remarks = <Remarks>[];
      json['remarks'].forEach((v) {
        remarks!.add(new Remarks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['user_id'] = this.userId;
    data['unit_no'] = this.unitNo;
    data['adm_module_id'] = this.admModuleId;
    data['eforms_id'] = this.eformsId;
    data['hide_for_all'] = this.hideForAll;
    data['eformcat_group_id'] = this.eformcatGroupId;
    data['fied_data'] = this.fiedData;
    data['attachment_id'] = this.attachmentId;
    data['eforms_status'] = this.eformsStatus;
    data['approved_by'] = this.approvedBy;
    data['approved_on'] = this.approvedOn;
    data['remark'] = this.remark;
    data['rec_status'] = this.recStatus;
    data['moduleName'] = this.moduleName;
    data['eformName'] = this.eformName;
    data['eformsStatus'] = this.eformsStatus;
    data['recStatusname'] = this.recStatusname;
    if (this.remarks != null) {
      data['remarks'] = this.remarks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Remarks {
  int? userId;
  String? userName;
  String? comment;
  String? createdOn;

  Remarks({this.userId, this.userName, this.comment, this.createdOn});

  Remarks.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['userName'];
    comment = json['comment'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['userName'] = this.userName;
    data['comment'] = this.comment;
    data['created_on'] = this.createdOn;
    return data;
  }
}
