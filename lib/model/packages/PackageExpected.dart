class PackageExpected {
  int? status;
  String? message;
  Result? result;

  PackageExpected({this.status, this.message, this.result});

  PackageExpected.fromJson(Map<String, dynamic> json) {
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
  List<Items>? items;

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
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
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

class Items {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? userId;
  int? userTypeId;
  int? packageTypeId;
  String? packageFrom;
  String? packageExpectDate;
  String? blockName;
  String? unitNumber;
  int? unitDeviceCnt;
  String? remarks;
  int? recStatus;
  Null? userTypeName;
  String? recStatusname;

  Items(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.userId,
      this.userTypeId,
      this.packageTypeId,
      this.packageFrom,
      this.packageExpectDate,
      this.blockName,
      this.unitNumber,
      this.unitDeviceCnt,
      this.remarks,
      this.recStatus,
      this.userTypeName,
      this.recStatusname});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    userId = json['user_id'];
    userTypeId = json['user_type_id'];
    packageTypeId = json['package_type_id'];
    packageFrom = json['package_from'];
    packageExpectDate = json['package_expect_date'];
    blockName = json['block_name'];
    unitNumber = json['unit_number'];
    unitDeviceCnt = json['unit_device_cnt'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
    userTypeName = json['userTypeName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['user_id'] = this.userId;
    data['user_type_id'] = this.userTypeId;
    data['package_type_id'] = this.packageTypeId;
    data['package_from'] = this.packageFrom;
    data['package_expect_date'] = this.packageExpectDate;
    data['block_name'] = this.blockName;
    data['unit_number'] = this.unitNumber;
    data['unit_device_cnt'] = this.unitDeviceCnt;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    data['userTypeName'] = this.userTypeName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
