class ManagementOffice {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  ManagementOffice(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  ManagementOffice.fromJson(Map<String, dynamic> json) {
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
  List<ManagementOfficeItems>? items;

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
      items = <ManagementOfficeItems>[];
      json['items'].forEach((v) {
        items!.add(new ManagementOfficeItems.fromJson(v));
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

class ManagementOfficeItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? appUserTypeId;
  int? appUsageTypeId;
  int? userType;
  String? firstName;
  String? lastName;
  int? gender;
  int? identificationTypeId;
  String? uniqueId;
  String? nationality;
  int? relationshipToOwner;
  String? tenancyExpiryDate;
  String? description;
  String? tenancyAgreementUrl;
  String? phoneNo;
  String? emailAddress;
  String? username;
  int? roleId;
  String? mobileNo;
  String? password;
  int? passwordStatus;
  bool? toHide;
  String? blockName;
  String? propusrQrCodeImg;
  String? propusrQrCode;
  String? unitNumber;
  String? profileImg;
  int? unitDeviceCnt;
  String? deviceId;
  String? fcmId;
  String? gcmId;
  String? apnId;
  String? signupRequestDate;
  int? signupReqStatus;
  int? otpCommId;
  String? otp;
  String? otpValidationStatus;
  String? activationDate;
  String? remarks;
  String? lastLoginDatetime;
  int? isOnline;
  int? recStatus;
  String? countryName;
  String? svgFlagUrl;
  String? mobFlagUrl;
  String? identificationTypeName;
  String? passwordStatusType;
  String? recStatusname;
  String? appUserTypeName;
  String? appUsageTypeName;
  String? roleName;
  String? userTypeName;
  String? logoImgUrl;
  String? propertyDispName;
  String? countryCode;
  String? genderName;
  String? relationship;
  String? signupReqStatusType;

  ManagementOfficeItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.appUserTypeId,
      this.appUsageTypeId,
      this.userType,
      this.firstName,
      this.lastName,
      this.gender,
      this.identificationTypeId,
      this.uniqueId,
      this.nationality,
      this.relationshipToOwner,
      this.tenancyExpiryDate,
      this.description,
      this.tenancyAgreementUrl,
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
      this.profileImg,
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
      this.countryName,
      this.svgFlagUrl,
      this.mobFlagUrl,
      this.identificationTypeName,
      this.passwordStatusType,
      this.recStatusname,
      this.appUserTypeName,
      this.appUsageTypeName,
      this.roleName,
      this.userTypeName,
      this.logoImgUrl,
      this.propertyDispName,
      this.countryCode,
      this.genderName,
      this.relationship,
      this.signupReqStatusType});

  ManagementOfficeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    appUserTypeId = json['app_user_type_id'];
    appUsageTypeId = json['app_usage_type_id'];
    userType = json['user_type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    identificationTypeId = json['identification_type_id'];
    uniqueId = json['unique_id'];
    nationality = json['nationality'];
    relationshipToOwner = json['relationship_to_owner'];
    tenancyExpiryDate = json['tenancy_expiry_date'];
    description = json['description'];
    tenancyAgreementUrl = json['tenancy_agreement_url'];
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
    profileImg = json['profile_img'];
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
    countryName = json['countryName'];
    svgFlagUrl = json['svg_flag_url'];
    mobFlagUrl = json['mob_flag_url'];
    identificationTypeName = json['identificationTypeName'];
    passwordStatusType = json['passwordStatusType'];
    recStatusname = json['recStatusname'];
    appUserTypeName = json['appUserTypeName'];
    appUsageTypeName = json['appUsageTypeName'];
    roleName = json['roleName'];
    userTypeName = json['userTypeName'];
    logoImgUrl = json['logoImgUrl'];
    propertyDispName = json['propertyDispName'];
    countryCode = json['country_code'];
    genderName = json['genderName'];
    relationship = json['relationship'];
    signupReqStatusType = json['signupReqStatusType'];
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
    data['gender'] = this.gender;
    data['identification_type_id'] = this.identificationTypeId;
    data['unique_id'] = this.uniqueId;
    data['nationality'] = this.nationality;
    data['relationship_to_owner'] = this.relationshipToOwner;
    data['tenancy_expiry_date'] = this.tenancyExpiryDate;
    data['description'] = this.description;
    data['tenancy_agreement_url'] = this.tenancyAgreementUrl;
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
    data['profile_img'] = this.profileImg;
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
    data['countryName'] = this.countryName;
    data['svg_flag_url'] = this.svgFlagUrl;
    data['mob_flag_url'] = this.mobFlagUrl;
    data['identificationTypeName'] = this.identificationTypeName;
    data['passwordStatusType'] = this.passwordStatusType;
    data['recStatusname'] = this.recStatusname;
    data['appUserTypeName'] = this.appUserTypeName;
    data['appUsageTypeName'] = this.appUsageTypeName;
    data['roleName'] = this.roleName;
    data['userTypeName'] = this.userTypeName;
    data['logoImgUrl'] = this.logoImgUrl;
    data['propertyDispName'] = this.propertyDispName;
    data['country_code'] = this.countryCode;
    data['genderName'] = this.genderName;
    data['relationship'] = this.relationship;
    data['signupReqStatusType'] = this.signupReqStatusType;
    return data;
  }
}
