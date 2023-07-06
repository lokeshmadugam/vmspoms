class VehicleTypeModel {
  int? status;
  String? message;
  Result? result;

  VehicleTypeModel({this.status, this.message, this.result});

  VehicleTypeModel.fromJson(Map<String, dynamic> json) {
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
  List<VehicleTypeItems>? items;

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
      items = <VehicleTypeItems>[];
      json['items'].forEach((v) {
        items!.add(new VehicleTypeItems.fromJson(v));
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

class VehicleTypeItems {
  int? id;
  int? createdBy;
  String? createdOn;
  String? vehicleType;
  String? vehiclePicture;
  String? description;
  String? remark;
  int? recStatus;
  String? recStatusname;

  VehicleTypeItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.vehicleType,
        this.vehiclePicture,
        this.description,
        this.remark,
        this.recStatus,
        this.recStatusname});

  VehicleTypeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    vehicleType = json['vehicle_type'];
    vehiclePicture = json['vehicle_picture'];
    description = json['description'];
    remark = json['remark'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['vehicle_type'] = this.vehicleType;
    data['vehicle_picture'] = this.vehiclePicture;
    data['description'] = this.description;
    data['remark'] = this.remark;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}

