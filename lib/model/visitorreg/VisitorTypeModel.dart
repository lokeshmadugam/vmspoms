class VisitorTypeModel {
  int? status;
  String? message;
  Result? result;

  VisitorTypeModel({this.status, this.message, this.result});

  VisitorTypeModel.fromJson(Map<String, dynamic> json) {
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
  List<VisitTypeItems>? items;

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
      items = <VisitTypeItems>[];
      json['items'].forEach((v) {
        items!.add(new VisitTypeItems.fromJson(v));
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

class VisitTypeItems {
  int? id;
  int? createdBy;
  String? createdOn;
  String? visitType;
  String? remark;
  int? recStatus;
  String? recStatusname;

  VisitTypeItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.visitType,
        this.remark,
        this.recStatus,
        this.recStatusname});

  VisitTypeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    visitType = json['visit_type'];
    remark = json['remark'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['visit_type'] = this.visitType;
    data['remark'] = this.remark;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}



