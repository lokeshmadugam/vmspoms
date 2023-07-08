class AttendanceListings {
  int? status;
  String? message;
  Result? result;

  AttendanceListings({this.status, this.message, this.result});

  AttendanceListings.fromJson(Map<String, dynamic> json) {
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
  String? timeOutMinutes;
  String? clockinoutDate;
  String? remarks;
  String? imgUrlClockin;
  String? imgUrlClockout;
  String? imgUrlRequestTimeOffIntime;
  int? emailFlag;
  String? employeeFirstName;
  String? employeeLastName;
  bool? clockIn;
  bool? clockOut;
  bool? reqTime;
  List<ReqTime>? reqTimeOff;

  Items(
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
      this.timeOutMinutes,
      this.clockinoutDate,
      this.remarks,
      this.imgUrlClockin,
      this.imgUrlClockout,
      this.imgUrlRequestTimeOffIntime,
      this.emailFlag,
      this.employeeFirstName,
      this.employeeLastName,
      this.clockIn,
      this.clockOut,
      this.reqTime,
      this.reqTimeOff});

  Items.fromJson(Map<String, dynamic> json) {
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
    timeOutMinutes = json['time_out_minutes'];
    clockinoutDate = json['clockinout_date'];
    remarks = json['remarks'];
    imgUrlClockin = json['img_url_clockin'];
    imgUrlClockout = json['img_url_clockout'];
    imgUrlRequestTimeOffIntime = json['img_url_request_time_off_intime'];
    emailFlag = json['email_flag'];
    employeeFirstName = json['employeeFirstName'];
    employeeLastName = json['employeeLastName'];
    clockIn = json['clock_in'];
    clockOut = json['clock_out'];
    reqTime = json['req_time'];
    if (json['reqTime'] != null) {
      reqTimeOff = <ReqTime>[];
      json['reqTime'].forEach((v) {
        reqTimeOff!.add(new ReqTime.fromJson(v));
      });
    }
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
    data['time_out_minutes'] = this.timeOutMinutes;
    data['clockinout_date'] = this.clockinoutDate;
    data['remarks'] = this.remarks;
    data['img_url_clockin'] = this.imgUrlClockin;
    data['img_url_clockout'] = this.imgUrlClockout;
    data['img_url_request_time_off_intime'] = this.imgUrlRequestTimeOffIntime;
    data['email_flag'] = this.emailFlag;
    data['employeeFirstName'] = this.employeeFirstName;
    data['employeeLastName'] = this.employeeLastName;
    data['clock_in'] = this.clockIn;
    data['clock_out'] = this.clockOut;
    data['req_time'] = this.reqTime;
    if (this.reqTime != null) {
      data['reqTime'] = this.reqTimeOff!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReqTime {
  String? permmissionOutTime;
  String? permmissionInTime;

  ReqTime({this.permmissionOutTime, this.permmissionInTime});

  ReqTime.fromJson(Map<String, dynamic> json) {
    permmissionOutTime = json['permmission_out_time_'];
    permmissionInTime = json['permmission_in_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['permmission_out_time_'] = this.permmissionOutTime;
    data['permmission_in_time'] = this.permmissionInTime;
    return data;
  }
}
