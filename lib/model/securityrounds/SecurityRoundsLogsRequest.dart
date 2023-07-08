class SecurityRoundsLogsRequest {
  String? checkinLatitude;
  String? checkinLongitude;
  int? checkinOfficerUserid;
  String? checkinTime;
  int? checkpointId;
  String? checkpointLocationImg;
  int? checkpointVisitDailyCnt;
  int? createdBy;
  int? propertyId;
  int? recStatus;
  String? remarks;
  int? roundsGroupid;

  SecurityRoundsLogsRequest({
    this.checkinLatitude,
    this.checkinLongitude,
    this.checkinOfficerUserid,
    this.checkinTime,
    this.checkpointId,
    this.checkpointLocationImg,
    this.checkpointVisitDailyCnt,
    this.createdBy,
    this.propertyId,
    this.recStatus,
    this.remarks,
    this.roundsGroupid,
  });

  SecurityRoundsLogsRequest.fromJson(Map<String, dynamic> json) {
    checkinLatitude = json['checkin_latitude'];
    checkinLongitude = json['checkin_longitude'];
    checkinOfficerUserid = json['checkin_officer_userid'];
    checkinTime = json['checkin_time'];
    checkpointId = json['checkpoint_id'];
    checkpointLocationImg = json['checkpoint_location_img'];
    checkpointVisitDailyCnt = json['checkpoint_visit_daily_cnt'];
    createdBy = json['created_by'];
    propertyId = json['property_id'];
    recStatus = json['rec_status'];
    remarks = json['remarks'];
    roundsGroupid = json['rounds_groupid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkin_latitude'] = this.checkinLatitude;
    data['checkin_longitude'] = this.checkinLongitude;
    data['checkin_officer_userid'] = this.checkinOfficerUserid;
    data['checkin_time'] = this.checkinTime;
    data['checkpoint_id'] = this.checkpointId;
    data['checkpoint_location_img'] = this.checkpointLocationImg;
    data['checkpoint_visit_daily_cnt'] = this.checkpointVisitDailyCnt;
    data['created_by'] = this.createdBy;
    data['property_id'] = this.propertyId;
    data['rec_status'] = this.recStatus;
    data['remarks'] = this.remarks;
    data['rounds_groupid'] = this.roundsGroupid;
    return data;
  }
}
