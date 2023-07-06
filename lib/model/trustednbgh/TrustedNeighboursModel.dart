class TrustedNeighboursModel {
  int? status;
  String? message;
  Result? result;

  TrustedNeighboursModel({this.status, this.message, this.result});

  TrustedNeighboursModel.fromJson(Map<String, dynamic> json) {
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
  List<NeighboursItems>? items;

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
      items = <NeighboursItems>[];
      json['items'].forEach((v) {
        items!.add(new NeighboursItems.fromJson(v));
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

class NeighboursItems {
  int? id;
  String? firstName;
  String? lastName;
  String? blockName;
  String? unitNumber;
  String? phoneNo;
  String? mobileNo;

  NeighboursItems(
      {this.id,
        this.firstName,
        this.lastName,
        this.blockName,
        this.unitNumber,
        this.phoneNo,
        this.mobileNo});

  NeighboursItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    blockName = json['block_name'];
    unitNumber = json['unit_number'];
    phoneNo = json['phone_no'];
    mobileNo = json['mobile_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['block_name'] = this.blockName;
    data['unit_number'] = this.unitNumber;
    data['phone_no'] = this.phoneNo;
    data['mobile_no'] = this.mobileNo;
    return data;
  }
}

