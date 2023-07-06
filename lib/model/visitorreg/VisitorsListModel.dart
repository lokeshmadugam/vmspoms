

class VisitorsListModel {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  VisitorsListModel(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  VisitorsListModel.fromJson(Map<String, dynamic> json) {
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
  List<VistorsListItems>? items;

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
      items = <VistorsListItems>[];
      json['items'].forEach((v) {
        items!.add(new VistorsListItems.fromJson(v));
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

class VistorsListItems {
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
  int? unitDeviceCnt;
  int? visitTypeId;
  int? isPreregistered;
  int? isParkingRequired;
  int? visitReasonId;
  String? visitorRegistrDate;
  String? visitorArrivalDate;
  String? visitorArrivalTime;
  String? visitorStayStartdate;
  String? visitorStayEnddate;
  int? visitorStayDurationHours;
  String? preregReqdateMgmtApproveStatus;
  String? preregStartDate;
  String? preregEndDate;
  int? visitorRegistrstionStatusId;
  String? registrationQrcode;
  String? registrationQrcodeImg;
  String? remarks;
  int? recStatus;
  String? parkingLotUsageRest;
  String? userTypeName;
  String? vehicleType;
  String? recStatusname;
  String? vistReason;
  String? visitorRegistrstionStatus;
  String? grayList;
  String? name;
  String? hostName;
  List<VisitorCheckInOutDate>? visitorCheckInOutDate;
  String? visitTypeName;
  String? parkingRequired;

  VistorsListItems(
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
        this.unitDeviceCnt,
        this.visitTypeId,
        this.isPreregistered,
        this.isParkingRequired,
        this.visitReasonId,
        this.visitorRegistrDate,
        this.visitorArrivalDate,
        this.visitorArrivalTime,
        this.visitorStayStartdate,
        this.visitorStayEnddate,
        this.visitorStayDurationHours,
        this.preregReqdateMgmtApproveStatus,
        this.preregStartDate,
        this.preregEndDate,
        this.visitorRegistrstionStatusId,
        this.registrationQrcode,
        this.registrationQrcodeImg,
        this.remarks,
        this.recStatus,
        this.parkingLotUsageRest,
        this.userTypeName,
        this.vehicleType,
        this.recStatusname,
        this.vistReason,
        this.visitorRegistrstionStatus,
        this.grayList,
        this.name,
        this.hostName,
        this.visitorCheckInOutDate,
        this.visitTypeName,
        this.parkingRequired});

  VistorsListItems.fromJson(Map<String, dynamic> json) {
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
    unitDeviceCnt = json['unit_device_cnt'];
    visitTypeId = json['visit_type_id'];
    isPreregistered = json['is_preregistered'];
    isParkingRequired = json['is_parking_required'];
    visitReasonId = json['visit_reason_id'];
    visitorRegistrDate = json['visitor_registr_date'];
    visitorArrivalDate = json['visitor_arrival_date'];
    visitorArrivalTime = json['visitor_arrival_time'];
    visitorStayStartdate = json['visitor_stay_startdate'];
    visitorStayEnddate = json['visitor_stay_enddate'];
    visitorStayDurationHours = json['visitor_stay_duration_hours'];
    preregReqdateMgmtApproveStatus = json['prereg_reqdate_mgmt_approve_status'];
    preregStartDate = json['prereg_start_date'];
    preregEndDate = json['prereg_end_date'];
    visitorRegistrstionStatusId = json['visitor_registrstion_status_id'];
    registrationQrcode = json['registration_qrcode'];
    registrationQrcodeImg = json['registration_qrcode_img'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
    parkingLotUsageRest = json['parkingLotUsageRest'];
    userTypeName = json['userTypeName'];
    vehicleType = json['vehicleType'];
    recStatusname = json['recStatusname'];
    vistReason = json['vistReason'];
    visitorRegistrstionStatus = json['visitorRegistrstionStatus'];
    grayList = json['grayList'];
    name = json['name'];
    hostName = json['hostName'];
    if (json['visitorCheckInOutDate'] != null) {
      visitorCheckInOutDate = <VisitorCheckInOutDate>[];
      json['visitorCheckInOutDate'].forEach((v) {
        visitorCheckInOutDate!.add(new VisitorCheckInOutDate.fromJson(v));
      });
    }
    visitTypeName = json['visitTypeName'];
    parkingRequired = json['parkingRequired'];
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
    data['unit_device_cnt'] = this.unitDeviceCnt;
    data['visit_type_id'] = this.visitTypeId;
    data['is_preregistered'] = this.isPreregistered;
    data['is_parking_required'] = this.isParkingRequired;
    data['visit_reason_id'] = this.visitReasonId;
    data['visitor_registr_date'] = this.visitorRegistrDate;
    data['visitor_arrival_date'] = this.visitorArrivalDate;
    data['visitor_arrival_time'] = this.visitorArrivalTime;
    data['visitor_stay_startdate'] = this.visitorStayStartdate;
    data['visitor_stay_enddate'] = this.visitorStayEnddate;
    data['visitor_stay_duration_hours'] = this.visitorStayDurationHours;
    data['prereg_reqdate_mgmt_approve_status'] =
        this.preregReqdateMgmtApproveStatus;
    data['prereg_start_date'] = this.preregStartDate;
    data['prereg_end_date'] = this.preregEndDate;
    data['visitor_registrstion_status_id'] = this.visitorRegistrstionStatusId;
    data['registration_qrcode'] = this.registrationQrcode;
    data['registration_qrcode_img'] = this.registrationQrcodeImg;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    data['parkingLotUsageRest'] = this.parkingLotUsageRest;
    data['userTypeName'] = this.userTypeName;
    data['vehicleType'] = this.vehicleType;
    data['recStatusname'] = this.recStatusname;
    data['vistReason'] = this.vistReason;
    data['visitorRegistrstionStatus'] = this.visitorRegistrstionStatus;
    data['grayList'] = this.grayList;
    data['name'] = this.name;
    data['hostName'] = this.hostName;
    if (this.visitorCheckInOutDate != null) {
      data['visitorCheckInOutDate'] =
          this.visitorCheckInOutDate!.map((v) => v.toJson()).toList();
    }
    data['visitTypeName'] = this.visitTypeName;
    data['parkingRequired'] = this.parkingRequired;
    return data;
  }
}

class VisitorCheckInOutDate {
  String? visitorCheckinDate;
  String? visitorCheckoutDate;

  VisitorCheckInOutDate({this.visitorCheckinDate, this.visitorCheckoutDate});

  VisitorCheckInOutDate.fromJson(Map<String, dynamic> json) {
    visitorCheckinDate = json['visitor_checkin_date'];
    visitorCheckoutDate = json['visitor_checkout_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitor_checkin_date'] = this.visitorCheckinDate;
    data['visitor_checkout_date'] = this.visitorCheckoutDate;
    return data;
  }
}









