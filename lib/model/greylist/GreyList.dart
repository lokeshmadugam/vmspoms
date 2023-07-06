class GreyList {
  int? status;
  String? message;
  Result? result;

  GreyList({this.status, this.message, this.result});

  GreyList.fromJson(Map<String, dynamic> json) {
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
  String? visitorName;
  int? visitTypeId;
  String? visitorMobileNo;
  String? vehiclePlateNo;
  String? idDrivingLicenseNo;
  String? visitorCheckinDate;
  int? visitorTransportMode;
  String? vehicleImg;
  int? userIdReqGreylist;
  int? userTypeIdReqBlock;
  String? blockReqDate;
  String? blockReason;
  String? remarksByMgmtGuardhse;
  String? blockRequestStatus;
  int? recStatus;
  String? visitType;
  String? vehicleType;
  String? recStatusname;

  Items(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.visitorName,
        this.visitTypeId,
        this.visitorMobileNo,
        this.vehiclePlateNo,
        this.idDrivingLicenseNo,
        this.visitorCheckinDate,
        this.visitorTransportMode,
        this.vehicleImg,
        this.userIdReqGreylist,
        this.userTypeIdReqBlock,
        this.blockReqDate,
        this.blockReason,
        this.remarksByMgmtGuardhse,
        this.blockRequestStatus,
        this.recStatus,
        this.visitType,
        this.vehicleType,
        this.recStatusname});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    visitorName = json['visitor_name'];
    visitTypeId = json['visit_type_id'];
    visitorMobileNo = json['visitor_mobile_no'];
    vehiclePlateNo = json['vehicle_plate_no'];
    idDrivingLicenseNo = json['id_driving_license_no'];
    visitorCheckinDate = json['visitor_checkin_date'];
    visitorTransportMode = json['visitor_transport_mode'];
    vehicleImg = json['vehicle_img'];
    userIdReqGreylist = json['user_id_req_greylist'];
    userTypeIdReqBlock = json['user_type_id_req_block'];
    blockReqDate = json['block_req_date'];
    blockReason = json['block_reason'];
    remarksByMgmtGuardhse = json['remarks_by_mgmt_guardhse'];
    blockRequestStatus = json['block_request_status'];
    recStatus = json['rec_status'];
    visitType = json['visitType'];
    vehicleType = json['vehicleType'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['visitor_name'] = this.visitorName;
    data['visit_type_id'] = this.visitTypeId;
    data['visitor_mobile_no'] = this.visitorMobileNo;
    data['vehicle_plate_no'] = this.vehiclePlateNo;
    data['id_driving_license_no'] = this.idDrivingLicenseNo;
    data['visitor_checkin_date'] = this.visitorCheckinDate;
    data['visitor_transport_mode'] = this.visitorTransportMode;
    data['vehicle_img'] = this.vehicleImg;
    data['user_id_req_greylist'] = this.userIdReqGreylist;
    data['user_type_id_req_block'] = this.userTypeIdReqBlock;
    data['block_req_date'] = this.blockReqDate;
    data['block_reason'] = this.blockReason;
    data['remarks_by_mgmt_guardhse'] = this.remarksByMgmtGuardhse;
    data['block_request_status'] = this.blockRequestStatus;
    data['rec_status'] = this.recStatus;
    data['visitType'] = this.visitType;
    data['vehicleType'] = this.vehicleType;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
