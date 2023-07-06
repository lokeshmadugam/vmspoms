class FacilityTypeModel {
  int? status;
  String? message;
  Result? result;

  FacilityTypeModel({this.status, this.message, this.result});

  FacilityTypeModel.fromJson(Map<String, dynamic> json) {
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
  List<FacilityTypes>? items;

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
      items = <FacilityTypes>[];
      json['items'].forEach((v) {
        items!.add(new FacilityTypes.fromJson(v));
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

class FacilityTypes {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? facilityId;
  String? facilityDeckName;
  String? facilityDeckLevel;
  String? facilityDeckMap;
  String? facilityNoCode;
  String? facilityQrCode;
  String? facilityName;
  String? facilityThumbnailImb;
  String? facilityImg;
  String? facilityRulebook;
  String? bookingHrsDay;
  String? bookingFees;
  int? allowedAgeToUse;
  int? isFeeRequired;
  bool? isBookingRequired;
  String? operatingHoursFrom;
  String? operatingHoursTo;
  int? isOpenDuringHolidays;
  String? remarks;
  int? recStatus;
  String? recStatusname;

  FacilityTypes(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.facilityId,
        this.facilityDeckName,
        this.facilityDeckLevel,
        this.facilityDeckMap,
        this.facilityNoCode,
        this.facilityQrCode,
        this.facilityName,
        this.facilityThumbnailImb,
        this.facilityImg,
        this.facilityRulebook,
        this.bookingHrsDay,
        this.bookingFees,
        this.allowedAgeToUse,
        this.isFeeRequired,
        this.isBookingRequired,
        this.operatingHoursFrom,
        this.operatingHoursTo,
        this.isOpenDuringHolidays,
        this.remarks,
        this.recStatus,
        this.recStatusname});

  FacilityTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    facilityId = json['facility_id'];
    facilityDeckName = json['facility_deck_name'];
    facilityDeckLevel = json['facility_deck_level'];
    facilityDeckMap = json['facility_deck_map'];
    facilityNoCode = json['facility_no_code'];
    facilityQrCode = json['facility_qr_code'];
    facilityName = json['facility_name'];
    facilityThumbnailImb = json['facility_thumbnail_imb'];
    facilityImg = json['facility_img'];
    facilityRulebook = json['facility_rulebook'];
    bookingHrsDay = json['booking_hrs_day'];
    bookingFees = json['booking_fees'];
    allowedAgeToUse = json['allowed_age_to_use'];
    isFeeRequired = json['is_fee_required'];
    isBookingRequired = json['is_booking_required'];
    operatingHoursFrom = json['operating_hours_from'];
    operatingHoursTo = json['operating_hours_to'];
    isOpenDuringHolidays = json['is_open_during_holidays'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['facility_id'] = this.facilityId;
    data['facility_deck_name'] = this.facilityDeckName;
    data['facility_deck_level'] = this.facilityDeckLevel;
    data['facility_deck_map'] = this.facilityDeckMap;
    data['facility_no_code'] = this.facilityNoCode;
    data['facility_qr_code'] = this.facilityQrCode;
    data['facility_name'] = this.facilityName;
    data['facility_thumbnail_imb'] = this.facilityThumbnailImb;
    data['facility_img'] = this.facilityImg;
    data['facility_rulebook'] = this.facilityRulebook;
    data['booking_hrs_day'] = this.bookingHrsDay;
    data['booking_fees'] = this.bookingFees;
    data['allowed_age_to_use'] = this.allowedAgeToUse;
    data['is_fee_required'] = this.isFeeRequired;
    data['is_booking_required'] = this.isBookingRequired;
    data['operating_hours_from'] = this.operatingHoursFrom;
    data['operating_hours_to'] = this.operatingHoursTo;
    data['is_open_during_holidays'] = this.isOpenDuringHolidays;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}








