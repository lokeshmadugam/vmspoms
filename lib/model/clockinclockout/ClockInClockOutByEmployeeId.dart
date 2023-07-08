class ClockInClockOutByEmployeeId {
  int? status;
  String? message;
  Result? result;

  ClockInClockOutByEmployeeId({this.status, this.message, this.result});

  ClockInClockOutByEmployeeId.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? createdBy;
  String? createdOn;
  int? userId;
  int? propertyId;
  String? employeeId;
  int? activity;
  String? clockInTime;
  String? clockOutTime;
  String? clockInIp;
  String? clockOutIp;
  String? clockInLocation;
  String? clockOutLocation;
  double? clockInLatitude;
  double? clockInLongitude;
  double? checkOutLatitude;
  double? checkOutLongitude;
  String? clockinoutDate;
  String? remarks;
  String? imgUrlClockin;
  String? imgUrlClockout;
  String? imgUrlRequestTimeOffIntime;
  int? emailFlag;
  bool? clockIn;
  bool? clockOut;
  bool? reqTime;

  Result(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.userId,
      this.propertyId,
      this.employeeId,
      this.activity,
      this.clockInTime,
      this.clockOutTime,
      this.clockInIp,
      this.clockOutIp,
      this.clockInLocation,
      this.clockOutLocation,
      this.clockInLatitude,
      this.clockInLongitude,
      this.checkOutLatitude,
      this.checkOutLongitude,
      this.clockinoutDate,
      this.remarks,
      this.imgUrlClockin,
      this.imgUrlClockout,
      this.imgUrlRequestTimeOffIntime,
      this.emailFlag,
      this.clockIn,
      this.clockOut,
      this.reqTime});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    userId = json['user_id'];
    propertyId = json['property_id'];
    employeeId = json['employee_id'];
    activity = json['activity'];
    clockInTime = json['clock_in_time'];
    clockOutTime = json['clock_out_time'];
    clockInIp = json['clock_in_ip'];
    clockOutIp = json['clock_out_ip'];
    clockInLocation = json['clock_in_location'];
    clockOutLocation = json['clock_out_location'];
    clockInLatitude = json['clock_in_latitude'];
    clockInLongitude = json['clock_in_longitude'];
    checkOutLatitude = json['check_out_latitude'];
    checkOutLongitude = json['check_out_longitude'];
    clockinoutDate = json['clockinout_date'];
    remarks = json['remarks'];
    imgUrlClockin = json['img_url_clockin'];
    imgUrlClockout = json['img_url_clockout'];
    imgUrlRequestTimeOffIntime = json['img_url_request_time_off_intime'];
    emailFlag = json['email_flag'];
    clockIn = json['clock_in'];
    clockOut = json['clock_out'];
    reqTime = json['req_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['user_id'] = this.userId;
    data['property_id'] = this.propertyId;
    data['employee_id'] = this.employeeId;
    data['activity'] = this.activity;
    data['clock_in_time'] = this.clockInTime;
    data['clock_out_time'] = this.clockOutTime;
    data['clock_in_ip'] = this.clockInIp;
    data['clock_out_ip'] = this.clockOutIp;
    data['clock_in_location'] = this.clockInLocation;
    data['clock_out_location'] = this.clockOutLocation;
    data['clock_in_latitude'] = this.clockInLatitude;
    data['clock_in_longitude'] = this.clockInLongitude;
    data['check_out_latitude'] = this.checkOutLatitude;
    data['check_out_longitude'] = this.checkOutLongitude;
    data['clockinout_date'] = this.clockinoutDate;
    data['remarks'] = this.remarks;
    data['img_url_clockin'] = this.imgUrlClockin;
    data['img_url_clockout'] = this.imgUrlClockout;
    data['img_url_request_time_off_intime'] = this.imgUrlRequestTimeOffIntime;
    data['email_flag'] = this.emailFlag;
    data['clock_in'] = this.clockIn;
    data['clock_out'] = this.clockOut;
    data['req_time'] = this.reqTime;
    return data;
  }
}
