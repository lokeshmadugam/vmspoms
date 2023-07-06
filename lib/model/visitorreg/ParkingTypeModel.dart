class ParkingType {
  int? status;
  String? message;
  Result? result;

  ParkingType({this.status, this.message, this.result});

  ParkingType.fromJson(Map<String, dynamic> json) {
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
  List<ParkingTypeItems>? items;

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
      items = <ParkingTypeItems>[];
      json['items'].forEach((v) {
        items!.add(new ParkingTypeItems.fromJson(v));
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

class ParkingTypeItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  String? unitNo;
  String? bayLocation;
  String? bayNumber;
  int? bayType;
  String? bayUrlImg;
  int? recStatus;
  String? recStatusname;
  String? bayTypeName;

  ParkingTypeItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.unitNo,
        this.bayLocation,
        this.bayNumber,
        this.bayType,
        this.bayUrlImg,
        this.recStatus,
        this.recStatusname,
        this.bayTypeName});

  ParkingTypeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    unitNo = json['unit_no'];
    bayLocation = json['bay_location'];
    bayNumber = json['bay_number'];
    bayType = json['bay_type'];
    bayUrlImg = json['bay_url_img'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    bayTypeName = json['bayTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['unit_no'] = this.unitNo;
    data['bay_location'] = this.bayLocation;
    data['bay_number'] = this.bayNumber;
    data['bay_type'] = this.bayType;
    data['bay_url_img'] = this.bayUrlImg;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['bayTypeName'] = this.bayTypeName;
    return data;
  }
}

