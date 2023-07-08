class TrustedNeighbourListModel {
  int? status;
  String? message;
  Result? result;

  TrustedNeighbourListModel({this.status, this.message, this.result});

  TrustedNeighbourListModel.fromJson(Map<String, dynamic> json) {
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
  List<TrustedNbghItems>? items;

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
      items = <TrustedNbghItems>[];
      json['items'].forEach((v) {
        items!.add(new TrustedNbghItems.fromJson(v));
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

class TrustedNbghItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? trneigbAddedPropertyUserid;
  String? trneigbAddedDeviceId;
  int? trneigbourPropertyUserId;
  String? trneigbourAddedDatetime;
  int? recStatus;
  String? trustedNegihbourAddedName;
  String? trustedNegihbourName;
  String? recStatusname;

  TrustedNbghItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.trneigbAddedPropertyUserid,
      this.trneigbAddedDeviceId,
      this.trneigbourPropertyUserId,
      this.trneigbourAddedDatetime,
      this.recStatus,
      this.trustedNegihbourAddedName,
      this.trustedNegihbourName,
      this.recStatusname});

  TrustedNbghItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    trneigbAddedPropertyUserid = json['trneigb_added_property_userid'];
    trneigbAddedDeviceId = json['trneigb_added_device_id'];
    trneigbourPropertyUserId = json['trneigbour_property_user_id'];
    trneigbourAddedDatetime = json['trneigbour_added_datetime'];
    recStatus = json['rec_status'];
    trustedNegihbourAddedName = json['trustedNegihbourAddedName'];
    trustedNegihbourName = json['trustedNegihbourName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['trneigb_added_property_userid'] = this.trneigbAddedPropertyUserid;
    data['trneigb_added_device_id'] = this.trneigbAddedDeviceId;
    data['trneigbour_property_user_id'] = this.trneigbourPropertyUserId;
    data['trneigbour_added_datetime'] = this.trneigbourAddedDatetime;
    data['rec_status'] = this.recStatus;
    data['trustedNegihbourAddedName'] = this.trustedNegihbourAddedName;
    data['trustedNegihbourName'] = this.trustedNegihbourName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}

class UpdateTrustedNeighbourModel {
  int? propertyId;
  int? recStatus;
  String? trneigbAddedDeviceId;
  int? trneigbAddedPropertyUserid;
  String? trneigbourAddedDatetime;
  int? trneigbourPropertyUserId;
  int? updatedBy;

  UpdateTrustedNeighbourModel(
      {this.propertyId,
      this.recStatus,
      this.trneigbAddedDeviceId,
      this.trneigbAddedPropertyUserid,
      this.trneigbourAddedDatetime,
      this.trneigbourPropertyUserId,
      this.updatedBy});

  UpdateTrustedNeighbourModel.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    recStatus = json['rec_status'];
    trneigbAddedDeviceId = json['trneigb_added_device_id'];
    trneigbAddedPropertyUserid = json['trneigb_added_property_userid'];
    trneigbourAddedDatetime = json['trneigbour_added_datetime'];
    trneigbourPropertyUserId = json['trneigbour_property_user_id'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['rec_status'] = this.recStatus;
    data['trneigb_added_device_id'] = this.trneigbAddedDeviceId;
    data['trneigb_added_property_userid'] = this.trneigbAddedPropertyUserid;
    data['trneigbour_added_datetime'] = this.trneigbourAddedDatetime;
    data['trneigbour_property_user_id'] = this.trneigbourPropertyUserId;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
