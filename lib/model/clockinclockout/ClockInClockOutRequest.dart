class ClockInClockOutRequest {
  int? activity;
  double? checkOutLatitude;
  double? checkOutLongitude;
  String? clockInIp;
  double? clockInLatitude;
  String? clockInLocation;
  double? clockInLongitude;
  String? clockInTime;
  String? clockOutIp;
  String? clockOutLocation;
  String? clockOutTime;
  String? clockinoutDate;
  int? createdBy;
  int? emailFlag;
  String? employeeId;
  String? imgUrlClockin;
  String? imgUrlClockout;
  String? imgUrlRequestTimeOffIntime;
  int? propertyId;
  String? remarks;
  int? userId;

  ClockInClockOutRequest(
      {this.activity,
        this.checkOutLatitude,
        this.checkOutLongitude,
        this.clockInIp,
        this.clockInLatitude,
        this.clockInLocation,
        this.clockInLongitude,
        this.clockInTime,
        this.clockOutIp,
        this.clockOutLocation,
        this.clockOutTime,
        this.clockinoutDate,
        this.createdBy,
        this.emailFlag,
        this.employeeId,
        this.imgUrlClockin,
        this.imgUrlClockout,
        this.imgUrlRequestTimeOffIntime,
        this.propertyId,
        this.remarks,
        this.userId});

  ClockInClockOutRequest.fromJson(Map<String, dynamic> json) {
    activity = json['activity'];
    checkOutLatitude = json['check_out_latitude'];
    checkOutLongitude = json['check_out_longitude'];
    clockInIp = json['clock_in_ip'];
    clockInLatitude = json['clock_in_latitude'];
    clockInLocation = json['clock_in_location'];
    clockInLongitude = json['clock_in_longitude'];
    clockInTime = json['clock_in_time'];
    clockOutIp = json['clock_out_ip'];
    clockOutLocation = json['clock_out_location'];
    clockOutTime = json['clock_out_time'];
    clockinoutDate = json['clockinout_date'];
    createdBy = json['created_by'];
    emailFlag = json['email_flag'];
    employeeId = json['employee_id'];
    imgUrlClockin = json['img_url_clockin'];
    imgUrlClockout = json['img_url_clockout'];
    imgUrlRequestTimeOffIntime = json['img_url_request_time_off_intime'];
    propertyId = json['property_id'];
    remarks = json['remarks'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity'] = this.activity;
    data['check_out_latitude'] = this.checkOutLatitude;
    data['check_out_longitude'] = this.checkOutLongitude;
    data['clock_in_ip'] = this.clockInIp;
    data['clock_in_latitude'] = this.clockInLatitude;
    data['clock_in_location'] = this.clockInLocation;
    data['clock_in_longitude'] = this.clockInLongitude;
    data['clock_in_time'] = this.clockInTime;
    data['clock_out_ip'] = this.clockOutIp;
    data['clock_out_location'] = this.clockOutLocation;
    data['clock_out_time'] = this.clockOutTime;
    data['clockinout_date'] = this.clockinoutDate;
    data['created_by'] = this.createdBy;
    data['email_flag'] = this.emailFlag;
    data['employee_id'] = this.employeeId;
    data['img_url_clockin'] = this.imgUrlClockin;
    data['img_url_clockout'] = this.imgUrlClockout;
    data['img_url_request_time_off_intime'] = this.imgUrlRequestTimeOffIntime;
    data['property_id'] = this.propertyId;
    data['remarks'] = this.remarks;
    data['user_id'] = this.userId;
    return data;
  }
}
