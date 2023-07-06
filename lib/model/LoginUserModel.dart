class LoginUserModel {
  int? status;
  String? message;
  LoginDetails? result;

  LoginUserModel({this.status, this.message, this.result});

  LoginUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new LoginDetails.fromJson(json['result']) : null;
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

class LoginDetails {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? appUserTypeId;
  int? appUsageTypeId;
  int? userType;
  String? firstName;
  String? lastName;
  String? phoneNo;
  String? emailAddress;
  String? username;
  int? roleId;
  String? mobileNo;
  String? password;
  String? passwordStatus;
  bool? toHide;
  String? blockName;
  Null? propusrQrCodeImg;
  String? propusrQrCode;
  String? unitNumber;
  int? unitDeviceCnt;
  Null? deviceId;
  Null? fcmId;
  Null? gcmId;
  Null? apnId;
  Null? signupRequestDate;
  String? signupReqStatus;
  int? otpCommId;
  Null? otp;
  Null? otpValidationStatus;
  Null? activationDate;
  String? remarks;
  String? lastLoginDatetime;
  int? isOnline;
  int? recStatus;
  String? recStatusname;
  String? appUserTypeName;
  String? appUsageTypeName;
  String? roleName;
  String? userTypeName;
  String? logoImgUrl;
  String? propertyDispName;
  Null? countryCode;
  Null? countryName;

  LoginDetails(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.appUserTypeId,
        this.appUsageTypeId,
        this.userType,
        this.firstName,
        this.lastName,
        this.phoneNo,
        this.emailAddress,
        this.username,
        this.roleId,
        this.mobileNo,
        this.password,
        this.passwordStatus,
        this.toHide,
        this.blockName,
        this.propusrQrCodeImg,
        this.propusrQrCode,
        this.unitNumber,
        this.unitDeviceCnt,
        this.deviceId,
        this.fcmId,
        this.gcmId,
        this.apnId,
        this.signupRequestDate,
        this.signupReqStatus,
        this.otpCommId,
        this.otp,
        this.otpValidationStatus,
        this.activationDate,
        this.remarks,
        this.lastLoginDatetime,
        this.isOnline,
        this.recStatus,
        this.recStatusname,
        this.appUserTypeName,
        this.appUsageTypeName,
        this.roleName,
        this.userTypeName,
        this.logoImgUrl,
        this.propertyDispName,
        this.countryCode,
        this.countryName});

  LoginDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    appUserTypeId = json['app_user_type_id'];
    appUsageTypeId = json['app_usage_type_id'];
    userType = json['user_type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNo = json['phone_no'];
    emailAddress = json['email_address'];
    username = json['username'];
    roleId = json['role_id'];
    mobileNo = json['mobile_no'];
    password = json['password'];
    passwordStatus = json['password_status'];
    toHide = json['to_hide'];
    blockName = json['block_name'];
    propusrQrCodeImg = json['propusr_qr_code_img'];
    propusrQrCode = json['propusr_qr_code'];
    unitNumber = json['unit_number'];
    unitDeviceCnt = json['unit_device_cnt'];
    deviceId = json['device_id'];
    fcmId = json['fcm_id'];
    gcmId = json['gcm_id'];
    apnId = json['apn_id'];
    signupRequestDate = json['signup_request_date'];
    signupReqStatus = json['signup_req_status'];
    otpCommId = json['otp_comm_id'];
    otp = json['otp'];
    otpValidationStatus = json['otp_validation_status'];
    activationDate = json['activation_date'];
    remarks = json['remarks'];
    lastLoginDatetime = json['last_login_datetime'];
    isOnline = json['is_online'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    appUserTypeName = json['appUserTypeName'];
    appUsageTypeName = json['appUsageTypeName'];
    roleName = json['roleName'];
    userTypeName = json['userTypeName'];
    logoImgUrl = json['logoImgUrl'];
    propertyDispName = json['propertyDispName'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['app_user_type_id'] = this.appUserTypeId;
    data['app_usage_type_id'] = this.appUsageTypeId;
    data['user_type'] = this.userType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_no'] = this.phoneNo;
    data['email_address'] = this.emailAddress;
    data['username'] = this.username;
    data['role_id'] = this.roleId;
    data['mobile_no'] = this.mobileNo;
    data['password'] = this.password;
    data['password_status'] = this.passwordStatus;
    data['to_hide'] = this.toHide;
    data['block_name'] = this.blockName;
    data['propusr_qr_code_img'] = this.propusrQrCodeImg;
    data['propusr_qr_code'] = this.propusrQrCode;
    data['unit_number'] = this.unitNumber;
    data['unit_device_cnt'] = this.unitDeviceCnt;
    data['device_id'] = this.deviceId;
    data['fcm_id'] = this.fcmId;
    data['gcm_id'] = this.gcmId;
    data['apn_id'] = this.apnId;
    data['signup_request_date'] = this.signupRequestDate;
    data['signup_req_status'] = this.signupReqStatus;
    data['otp_comm_id'] = this.otpCommId;
    data['otp'] = this.otp;
    data['otp_validation_status'] = this.otpValidationStatus;
    data['activation_date'] = this.activationDate;
    data['remarks'] = this.remarks;
    data['last_login_datetime'] = this.lastLoginDatetime;
    data['is_online'] = this.isOnline;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['appUserTypeName'] = this.appUserTypeName;
    data['appUsageTypeName'] = this.appUsageTypeName;
    data['roleName'] = this.roleName;
    data['userTypeName'] = this.userTypeName;
    data['logoImgUrl'] = this.logoImgUrl;
    data['propertyDispName'] = this.propertyDispName;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    return data;
  }
}

