class RulesModel {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  RulesModel(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  RulesModel.fromJson(Map<String, dynamic> json) {
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
  List<RulesItems>? items;

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
      items = <RulesItems>[];
      json['items'].forEach((v) {
        items!.add(new RulesItems.fromJson(v));
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

class RulesItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? documentTypeId;
  String? documentName;
  String? docPublishDate;
  String? documentText;
  String? documentUrl;
  String? description;
  String? notifyUserCommModeId;
  int? recStatus;
  String? recStatusname;
  String? propertydocumentTypeName;

  RulesItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.documentTypeId,
        this.documentName,
        this.docPublishDate,
        this.documentText,
        this.documentUrl,
        this.description,
        this.notifyUserCommModeId,
        this.recStatus,
        this.recStatusname,
        this.propertydocumentTypeName});

  RulesItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    documentTypeId = json['document_type_id'];
    documentName = json['document_name'];
    docPublishDate = json['doc_publish_date'];
    documentText = json['document_text'];
    documentUrl = json['document_url'];
    description = json['description'];
    notifyUserCommModeId = json['notify_user_comm_mode_id'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    propertydocumentTypeName = json['propertydocumentTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['document_type_id'] = this.documentTypeId;
    data['document_name'] = this.documentName;
    data['doc_publish_date'] = this.docPublishDate;
    data['document_text'] = this.documentText;
    data['document_url'] = this.documentUrl;
    data['description'] = this.description;
    data['notify_user_comm_mode_id'] = this.notifyUserCommModeId;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['propertydocumentTypeName'] = this.propertydocumentTypeName;
    return data;
  }
}

