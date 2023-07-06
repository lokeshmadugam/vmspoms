class FacilityBookingModel {
  int? status;
  String? message;
  Result? result;

  FacilityBookingModel({this.status, this.message, this.result});

  FacilityBookingModel.fromJson(Map<String, dynamic> json) {
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
  List<FacilityItems>? items;

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
      items = <FacilityItems>[];
      json['items'].forEach((v) {
        items!.add(new FacilityItems.fromJson(v));
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

class FacilityItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? userId;
  int? userTypeId;
  String? unitNumber;
  int? unitDeviceCnt;
  int? noOfUsrGuests;
  int? facilityId;
  String? bookingId;
  int? bookingStatus;
  String? cancelReason;
  String? requestedDate;
  String? usageDate;
  String? usageStarttime;
  String? usageEndtime;
  String? bookingHrsDay;
  int? feePaidStatus;
  String? facilityKeyCodeCollectionTime;
  String? facilityKeyCodeHandoverTime;
  String? facilityKeyCodeHandoverBy;
  int? keyCollectedBy;
  String? remarks;
  int? recStatus;
  String? recStatusname;
  String? facilityName;
  String? facilityImg;
  String? keyCollectedName;
  String? bookingStatusName;

  FacilityItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.userId,
        this.userTypeId,
        this.unitNumber,
        this.unitDeviceCnt,
        this.noOfUsrGuests,
        this.facilityId,
        this.bookingId,
        this.bookingStatus,
        this.cancelReason,
        this.requestedDate,
        this.usageDate,
        this.usageStarttime,
        this.usageEndtime,
        this.bookingHrsDay,
        this.feePaidStatus,
        this.facilityKeyCodeCollectionTime,
        this.facilityKeyCodeHandoverTime,
        this.facilityKeyCodeHandoverBy,
        this.keyCollectedBy,
        this.remarks,
        this.recStatus,
        this.recStatusname,
        this.facilityName,
        this.facilityImg,
        this.keyCollectedName,
        this.bookingStatusName});

  FacilityItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    userId = json['user_id'];
    userTypeId = json['user_type_id'];
    unitNumber = json['unit_number'];
    unitDeviceCnt = json['unit_device_cnt'];
    noOfUsrGuests = json['no_of_usr_guests'];
    facilityId = json['facility_id'];
    bookingId = json['booking_id'];
    bookingStatus = json['booking_status'];
    cancelReason = json['cancel_reason'];
    requestedDate = json['requested_date'];
    usageDate = json['usage_date'];
    usageStarttime = json['usage_starttime'];
    usageEndtime = json['usage_endtime'];
    bookingHrsDay = json['booking_hrs_day'];
    feePaidStatus = json['fee_paid_status'];
    facilityKeyCodeCollectionTime = json['facility_key_code_collection_time'];
    facilityKeyCodeHandoverTime = json['facility_key_code_handover_time'];
    facilityKeyCodeHandoverBy = json['facility_key_code_handover_by'];
    keyCollectedBy = json['key_collected_by'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    facilityName = json['facilityName'];
    facilityImg = json['facilityImg'];
    keyCollectedName = json['keyCollectedName'];
    bookingStatusName = json['bookingStatusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['user_id'] = this.userId;
    data['user_type_id'] = this.userTypeId;
    data['unit_number'] = this.unitNumber;
    data['unit_device_cnt'] = this.unitDeviceCnt;
    data['no_of_usr_guests'] = this.noOfUsrGuests;
    data['facility_id'] = this.facilityId;
    data['booking_id'] = this.bookingId;
    data['booking_status'] = this.bookingStatus;
    data['cancel_reason'] = this.cancelReason;
    data['requested_date'] = this.requestedDate;
    data['usage_date'] = this.usageDate;
    data['usage_starttime'] = this.usageStarttime;
    data['usage_endtime'] = this.usageEndtime;
    data['booking_hrs_day'] = this.bookingHrsDay;
    data['fee_paid_status'] = this.feePaidStatus;
    data['facility_key_code_collection_time'] =
        this.facilityKeyCodeCollectionTime;
    data['facility_key_code_handover_time'] = this.facilityKeyCodeHandoverTime;
    data['facility_key_code_handover_by'] = this.facilityKeyCodeHandoverBy;
    data['key_collected_by'] = this.keyCollectedBy;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['facilityName'] = this.facilityName;
    data['facilityImg'] = this.facilityImg;
    data['keyCollectedName'] = this.keyCollectedName;
    data['bookingStatusName'] = this.bookingStatusName;
    return data;
  }
}











