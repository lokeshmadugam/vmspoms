class LostFoundRequest {
  int? collectedBy;
  String? collectedDateTime;
  String? collectedRemarks;
  int? createdBy;
  int? foundBy;
  String? foundByItemPic;
  String? foundDateTime;
  String? foundDescription;
  String? foundItemName;
  String? foundLocation;
  String? foundUnitNo;
  String? lostDateTime;
  String? lostDescription;
  String? lostItemImgUrl;
  String? lostItemName;
  String? lostLocation;
  int? lostReportUserId;
  String? lostUnitNo;
  int? propertyId;
  int? recStatus;
  String? receivedBySign;
  int? updatedBy;

  LostFoundRequest(
      {this.collectedBy,
      this.collectedDateTime,
      this.collectedRemarks,
      this.createdBy,
      this.foundBy,
      this.foundByItemPic,
      this.foundDateTime,
      this.foundDescription,
      this.foundItemName,
      this.foundLocation,
      this.foundUnitNo,
      this.lostDateTime,
      this.lostDescription,
      this.lostItemImgUrl,
      this.lostItemName,
      this.lostLocation,
      this.lostReportUserId,
      this.lostUnitNo,
      this.propertyId,
      this.recStatus,
      this.updatedBy,
      this.receivedBySign});

  LostFoundRequest.fromJson(Map<String, dynamic> json) {
    collectedBy = json['collected_by'];
    collectedDateTime = json['collected_date_time'];
    collectedRemarks = json['collected_remarks'];
    createdBy = json['created_by'];
    foundBy = json['found_by'];
    foundByItemPic = json['found_by_item_pic'];
    foundDateTime = json['found_date_time'];
    foundDescription = json['found_description'];
    foundItemName = json['found_item_name'];
    foundLocation = json['found_location'];
    foundUnitNo = json['found_unit_no'];
    lostDateTime = json['lost_date_time'];
    lostDescription = json['lost_description'];
    lostItemImgUrl = json['lost_item_img_url'];
    lostItemName = json['lost_item_name'];
    lostLocation = json['lost_location'];
    lostReportUserId = json['lost_report_user_id'];
    lostUnitNo = json['lost_unit_no'];
    propertyId = json['property_id'];
    recStatus = json['rec_status'];
    receivedBySign = json['received_by_sign'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collected_by'] = this.collectedBy;
    data['collected_date_time'] = this.collectedDateTime;
    data['collected_remarks'] = this.collectedRemarks;
    data['created_by'] = this.createdBy;
    data['found_by'] = this.foundBy;
    data['found_by_item_pic'] = this.foundByItemPic;
    data['found_date_time'] = this.foundDateTime;
    data['found_description'] = this.foundDescription;
    data['found_item_name'] = this.foundItemName;
    data['found_location'] = this.foundLocation;
    data['found_unit_no'] = this.foundUnitNo;
    data['lost_date_time'] = this.lostDateTime;
    data['lost_description'] = this.lostDescription;
    data['lost_item_img_url'] = this.lostItemImgUrl;
    data['lost_item_name'] = this.lostItemName;
    data['lost_location'] = this.lostLocation;
    data['lost_report_user_id'] = this.lostReportUserId;
    data['lost_unit_no'] = this.lostUnitNo;
    data['property_id'] = this.propertyId;
    data['rec_status'] = this.recStatus;
    data['received_by_sign'] = this.receivedBySign;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
