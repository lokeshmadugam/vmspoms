class FavoriteVisitorModel {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  FavoriteVisitorModel(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  FavoriteVisitorModel.fromJson(Map<String, dynamic> json) {
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
  List<FavoriteVisitorsItems>? items;

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
      items = <FavoriteVisitorsItems>[];
      json['items'].forEach((v) {
        items!.add(new FavoriteVisitorsItems.fromJson(v));
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

class FavoriteVisitorsItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? userId;
  int? userTypeId;
  String? visitorName;
  String? visitorMobileNo;
  int? visitorTransportMode;
  int? noOfVisitor;
  String? vehiclePlateNo;
  String? idDrivingLicenseNo;
  String? blockName;
  String? unitNumber;
  int? isPreregistered;
  int? isParkingRequired;
  int? visitTypeId;
  int? visitReasonId;
  String? visitorRegistrDate;
  String? remarks;
  int? recStatus;

  FavoriteVisitorsItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.userId,
        this.userTypeId,
        this.visitorName,
        this.visitorMobileNo,
        this.visitorTransportMode,
        this.noOfVisitor,
        this.vehiclePlateNo,
        this.idDrivingLicenseNo,
        this.blockName,
        this.unitNumber,
        this.isPreregistered,
        this.isParkingRequired,
        this.visitTypeId,
        this.visitReasonId,
        this.visitorRegistrDate,
        this.remarks,
        this.recStatus});

  FavoriteVisitorsItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    userId = json['user_id'];
    userTypeId = json['user_type_id'];
    visitorName = json['visitor_name'];
    visitorMobileNo = json['visitor_mobile_no'];
    visitorTransportMode = json['visitor_transport_mode'];
    noOfVisitor = json['no_of_visitor'];
    vehiclePlateNo = json['vehicle_plate_no'];
    idDrivingLicenseNo = json['id_driving_license_no'];
    blockName = json['block_name'];
    unitNumber = json['unit_number'];
    isPreregistered = json['is_preregistered'];
    isParkingRequired = json['is_parking_required'];
    visitTypeId = json['visit_type_id'];
    visitReasonId = json['visit_reason_id'];
    visitorRegistrDate = json['visitor_registr_date'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['user_id'] = this.userId;
    data['user_type_id'] = this.userTypeId;
    data['visitor_name'] = this.visitorName;
    data['visitor_mobile_no'] = this.visitorMobileNo;
    data['visitor_transport_mode'] = this.visitorTransportMode;
    data['no_of_visitor'] = this.noOfVisitor;
    data['vehicle_plate_no'] = this.vehiclePlateNo;
    data['id_driving_license_no'] = this.idDrivingLicenseNo;
    data['block_name'] = this.blockName;
    data['unit_number'] = this.unitNumber;
    data['is_preregistered'] = this.isPreregistered;
    data['is_parking_required'] = this.isParkingRequired;
    data['visit_type_id'] = this.visitTypeId;
    data['visit_reason_id'] = this.visitReasonId;
    data['visitor_registr_date'] = this.visitorRegistrDate;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    return data;
  }
}

