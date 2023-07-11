class SignInModel {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  String? accessToken;
  UserDetails? userDetails;

  SignInModel(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.accessToken,
        this.userDetails});

  SignInModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    megCategory = json['megCategory'];
    webMessage = json['webMessage'];
    mobMessage = json['mobMessage'];
    accessToken = json['accessToken'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['megCategory'] = this.megCategory;
    data['webMessage'] = this.webMessage;
    data['mobMessage'] = this.mobMessage;
    data['accessToken'] = this.accessToken;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? id;
  int? admPropertyId;
  int? propertyId;
  int? appUserTypeId;
  int? appUsageTypeId;
  String? appUserTypeKeyValue;
  String? appUsageTypeKeyValue;
  int? userType;
  String? firstName;
  String? lastName;
  String? phoneNo;
  String? emailAddress;
  String? employeeId;
  String? username;
  int? roleId;
  String? mobileNo;
  String? blockName;
  int? unitDeviceCnt;
  int? otpCommId;
  String? otpValidationStatus;
  String? remarks;
  String? lastLoginDatetime;
  int? isOnline;
  int? recStatus;
  String? userQrcodeImg;
  String? userQrcode;
  String? unitNumber;
  String? signupRequestDate;
  String? recStatusname;
  String? appUserTypeName;
  String? appUsageTypeName;
  String? roleName;
  String? userTypeName;
  String? propertyDispName;
  String? logoImgUrl;
  String? propertyImg;
  String? profileImg;
  String? propertyAddressLine1;
  String? propertyAddressLine2;
  String? propertyCity;
  String? propertyPostalCode;
  String? propertyCountryCode;
  String? propertyCountryName;
  String? propertyState;
  String? countryCode;
  String? countryName;
  String? callingCode;
  int? timezone;
  String? propertyTimezoneName;
  String? dispDateFormat;
  int? isShowStreetName;
  int? isShowBlockName;
  List<Permissions>? permissions;

  UserDetails(
      {this.id,
        this.admPropertyId,
        this.propertyId,
        this.appUserTypeId,
        this.appUsageTypeId,
        this.appUserTypeKeyValue,
        this.appUsageTypeKeyValue,
        this.userType,
        this.firstName,
        this.lastName,
        this.phoneNo,
        this.emailAddress,
        this.employeeId,
        this.username,
        this.roleId,
        this.mobileNo,
        this.blockName,
        this.unitDeviceCnt,
        this.otpCommId,
        this.otpValidationStatus,
        this.remarks,
        this.lastLoginDatetime,
        this.isOnline,
        this.recStatus,
        this.userQrcodeImg,
        this.userQrcode,
        this.unitNumber,
        this.signupRequestDate,
        this.recStatusname,
        this.appUserTypeName,
        this.appUsageTypeName,
        this.roleName,
        this.userTypeName,
        this.propertyDispName,
        this.logoImgUrl,
        this.propertyImg,
        this.profileImg,
        this.propertyAddressLine1,
        this.propertyAddressLine2,
        this.propertyCity,
        this.propertyPostalCode,
        this.propertyCountryCode,
        this.propertyCountryName,
        this.propertyState,
        this.countryCode,
        this.countryName,
        this.callingCode,
        this.timezone,
        this.propertyTimezoneName,
        this.dispDateFormat,
        this.isShowStreetName,
        this.isShowBlockName,
        this.permissions});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    admPropertyId = json['adm_property_id'];
    propertyId = json['property_id'];
    appUserTypeId = json['app_user_type_id'];
    appUsageTypeId = json['app_usage_type_id'];
    appUserTypeKeyValue = json['app_user_type_key_value'];
    appUsageTypeKeyValue = json['app_usage_type_key_value'];
    userType = json['user_type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNo = json['phone_no'];
    emailAddress = json['email_address'];
    employeeId = json['employee_id'];
    username = json['username'];
    roleId = json['role_id'];
    mobileNo = json['mobile_no'];
    blockName = json['block_name'];
    unitDeviceCnt = json['unit_device_cnt'];
    otpCommId = json['otp_comm_id'];
    otpValidationStatus = json['otp_validation_status'];
    remarks = json['remarks'];
    lastLoginDatetime = json['last_login_datetime'];
    isOnline = json['is_online'];
    recStatus = json['rec_status'];
    userQrcodeImg = json['user_qrcode_img'];
    userQrcode = json['user_qrcode'];
    unitNumber = json['unit_number'];
    signupRequestDate = json['signup_request_date'];
    recStatusname = json['recStatusname'];
    appUserTypeName = json['appUserTypeName'];
    appUsageTypeName = json['appUsageTypeName'];
    roleName = json['roleName'];
    userTypeName = json['userTypeName'];
    propertyDispName = json['propertyDispName'];
    logoImgUrl = json['logoImgUrl'];
    propertyImg = json['property_img'];
    profileImg = json['profile_img'];
    propertyAddressLine1 = json['property_address_line1'];
    propertyAddressLine2 = json['property_address_line2'];
    propertyCity = json['property_city'];
    propertyPostalCode = json['property_postal_code'];
    propertyCountryCode = json['property_country_code'];
    propertyCountryName = json['property_country_name'];
    propertyState = json['property_state'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    callingCode = json['calling_code'];
    timezone = json['timezone'];
    propertyTimezoneName = json['propertyTimezoneName'];
    dispDateFormat = json['disp_date_format'];
    isShowStreetName = json['is_show_street_name'];
    isShowBlockName = json['is_show_block_name'];
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adm_property_id'] = this.admPropertyId;
    data['property_id'] = this.propertyId;
    data['app_user_type_id'] = this.appUserTypeId;
    data['app_usage_type_id'] = this.appUsageTypeId;
    data['app_user_type_key_value'] = this.appUserTypeKeyValue;
    data['app_usage_type_key_value'] = this.appUsageTypeKeyValue;
    data['user_type'] = this.userType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_no'] = this.phoneNo;
    data['email_address'] = this.emailAddress;
    data['employee_id'] = this.employeeId;
    data['username'] = this.username;
    data['role_id'] = this.roleId;
    data['mobile_no'] = this.mobileNo;
    data['block_name'] = this.blockName;
    data['unit_device_cnt'] = this.unitDeviceCnt;
    data['otp_comm_id'] = this.otpCommId;
    data['otp_validation_status'] = this.otpValidationStatus;
    data['remarks'] = this.remarks;
    data['last_login_datetime'] = this.lastLoginDatetime;
    data['is_online'] = this.isOnline;
    data['rec_status'] = this.recStatus;
    data['user_qrcode_img'] = this.userQrcodeImg;
    data['user_qrcode'] = this.userQrcode;
    data['unit_number'] = this.unitNumber;
    data['signup_request_date'] = this.signupRequestDate;
    data['recStatusname'] = this.recStatusname;
    data['appUserTypeName'] = this.appUserTypeName;
    data['appUsageTypeName'] = this.appUsageTypeName;
    data['roleName'] = this.roleName;
    data['userTypeName'] = this.userTypeName;
    data['propertyDispName'] = this.propertyDispName;
    data['logoImgUrl'] = this.logoImgUrl;
    data['property_img'] = this.propertyImg;
    data['profile_img'] = this.profileImg;
    data['property_address_line1'] = this.propertyAddressLine1;
    data['property_address_line2'] = this.propertyAddressLine2;
    data['property_city'] = this.propertyCity;
    data['property_postal_code'] = this.propertyPostalCode;
    data['property_country_code'] = this.propertyCountryCode;
    data['property_country_name'] = this.propertyCountryName;
    data['property_state'] = this.propertyState;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['calling_code'] = this.callingCode;
    data['timezone'] = this.timezone;
    data['propertyTimezoneName'] = this.propertyTimezoneName;
    data['disp_date_format'] = this.dispDateFormat;
    data['is_show_street_name'] = this.isShowStreetName;
    data['is_show_block_name'] = this.isShowBlockName;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permissions {
  int? moduleId;
  String? menuDisplayNameWeb;
  String? menuDisplayNameMobile;
  String? moduleDisplayNameWeb;
  String? moduleDisplayNameMobile;
  int? parentMenuId;
  String? menuIconWeb;
  String? menuIconMobile;
  String? modulePath;
  int? roleId;
  List<Action>? action;
  List<FunctionName>? functionName;
  List<ParentSubMenu>? parentSubMenu;

  Permissions(
      {this.moduleId,
        this.menuDisplayNameWeb,
        this.menuDisplayNameMobile,
        this.moduleDisplayNameWeb,
        this.moduleDisplayNameMobile,
        this.parentMenuId,
        this.menuIconWeb,
        this.menuIconMobile,
        this.modulePath,
        this.roleId,
        this.action,
        this.functionName,
        this.parentSubMenu});

  Permissions.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    menuDisplayNameWeb = json['menu_display_name_web'];
    menuDisplayNameMobile = json['menu_display_name_mobile'];
    moduleDisplayNameWeb = json['module_display_name_web'];
    moduleDisplayNameMobile = json['module_display_name_mobile'];
    parentMenuId = json['parent_menu_id'];
    menuIconWeb = json['menu_icon_web'];
    menuIconMobile = json['menu_icon_mobile'];
    modulePath = json['module_path'];
    roleId = json['role_id'];
    if (json['action'] != null) {
      action = <Action>[];
      json['action'].forEach((v) {
        action!.add(new Action.fromJson(v));
      });
    }
    if (json['functionName'] != null) {
      functionName = <FunctionName>[];
      json['functionName'].forEach((v) {
        functionName!.add(new FunctionName.fromJson(v));
      });
    }
    if (json['parentSubMenu'] != null) {
      parentSubMenu = <ParentSubMenu>[];
      json['parentSubMenu'].forEach((v) {
        parentSubMenu!.add(new ParentSubMenu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_id'] = this.moduleId;
    data['menu_display_name_web'] = this.menuDisplayNameWeb;
    data['menu_display_name_mobile'] = this.menuDisplayNameMobile;
    data['module_display_name_web'] = this.moduleDisplayNameWeb;
    data['module_display_name_mobile'] = this.moduleDisplayNameMobile;
    data['parent_menu_id'] = this.parentMenuId;
    data['menu_icon_web'] = this.menuIconWeb;
    data['menu_icon_mobile'] = this.menuIconMobile;
    data['module_path'] = this.modulePath;
    data['role_id'] = this.roleId;
    if (this.action != null) {
      data['action'] = this.action!.map((v) => v.toJson()).toList();
    }
    if (this.functionName != null) {
      data['functionName'] = this.functionName!.map((v) => v.toJson()).toList();
    }
    if (this.parentSubMenu != null) {
      data['parentSubMenu'] =
          this.parentSubMenu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Action {
  int? actionId;
  String? actionName;

  Action({this.actionId, this.actionName});

  Action.fromJson(Map<String, dynamic> json) {
    actionId = json['action_id'];
    actionName = json['action_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_id'] = this.actionId;
    data['action_name'] = this.actionName;
    return data;
  }
}

class FunctionName {
  String? menuDisplayNameWeb;
  String? menuDisplayNameMobile;
  String? moduleDisplayNameWeb;
  String? moduleDisplayNameMobile;
  String? functionDisplayNameWeb;
  String? functionDisplayNameMobile;
  String? functionDescription;
  String? moduleDescription;
  String? modulePath;
  String? functionPath;

  FunctionName(
      {this.menuDisplayNameWeb,
        this.menuDisplayNameMobile,
        this.moduleDisplayNameWeb,
        this.moduleDisplayNameMobile,
        this.functionDisplayNameWeb,
        this.functionDisplayNameMobile,
        this.functionDescription,
        this.moduleDescription,
        this.modulePath,
        this.functionPath});

  FunctionName.fromJson(Map<String, dynamic> json) {
    menuDisplayNameWeb = json['menu_display_name_web'];
    menuDisplayNameMobile = json['menu_display_name_mobile'];
    moduleDisplayNameWeb = json['module_display_name_web'];
    moduleDisplayNameMobile = json['module_display_name_mobile'];
    functionDisplayNameWeb = json['function_display_name_web'];
    functionDisplayNameMobile = json['function_display_name_mobile'];
    functionDescription = json['function_description'];
    moduleDescription = json['module_description'];
    modulePath = json['module_path'];
    functionPath = json['function_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_display_name_web'] = this.menuDisplayNameWeb;
    data['menu_display_name_mobile'] = this.menuDisplayNameMobile;
    data['module_display_name_web'] = this.moduleDisplayNameWeb;
    data['module_display_name_mobile'] = this.moduleDisplayNameMobile;
    data['function_display_name_web'] = this.functionDisplayNameWeb;
    data['function_display_name_mobile'] = this.functionDisplayNameMobile;
    data['function_description'] = this.functionDescription;
    data['module_description'] = this.moduleDescription;
    data['module_path'] = this.modulePath;
    data['function_path'] = this.functionPath;
    return data;
  }
}

class ParentSubMenu {
  int? moduleId;
  String? menuDisplayNameWeb;
  String? menuDisplayNameMobile;
  String? moduleDisplayNameWeb;
  String? moduleDisplayNameMobile;
  String? modulePath;
  int? parentMenuId;
  String? menuIconWeb;
  String? menuIconMobile;
  int? roleId;
  List<Action>? action;
  List<Null>? functionName;
  Null? parentChildSubMenu;

  ParentSubMenu(
      {this.moduleId,
        this.menuDisplayNameWeb,
        this.menuDisplayNameMobile,
        this.moduleDisplayNameWeb,
        this.moduleDisplayNameMobile,
        this.modulePath,
        this.parentMenuId,
        this.menuIconWeb,
        this.menuIconMobile,
        this.roleId,
        this.action,
        this.functionName,
        this.parentChildSubMenu});

  ParentSubMenu.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    menuDisplayNameWeb = json['menu_display_name_web'];
    menuDisplayNameMobile = json['menu_display_name_mobile'];
    moduleDisplayNameWeb = json['module_display_name_web'];
    moduleDisplayNameMobile = json['module_display_name_mobile'];
    modulePath = json['module_path'];
    parentMenuId = json['parent_menu_id'];
    menuIconWeb = json['menu_icon_web'];
    menuIconMobile = json['menu_icon_mobile'];
    roleId = json['role_id'];
    if (json['action'] != null) {
      action = <Action>[];
      json['action'].forEach((v) {
        action!.add(new Action.fromJson(v));
      });
    }
    // if (json['functionName'] != null) {
    //   functionName = <Null>[];
    //   json['functionName'].forEach((v) {
    //     functionName!.add(new Null.fromJson(v));
    //   });
    // }
    parentChildSubMenu = json['parentChildSubMenu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module_id'] = this.moduleId;
    data['menu_display_name_web'] = this.menuDisplayNameWeb;
    data['menu_display_name_mobile'] = this.menuDisplayNameMobile;
    data['module_display_name_web'] = this.moduleDisplayNameWeb;
    data['module_display_name_mobile'] = this.moduleDisplayNameMobile;
    data['module_path'] = this.modulePath;
    data['parent_menu_id'] = this.parentMenuId;
    data['menu_icon_web'] = this.menuIconWeb;
    data['menu_icon_mobile'] = this.menuIconMobile;
    data['role_id'] = this.roleId;
    if (this.action != null) {
      data['action'] = this.action!.map((v) => v.toJson()).toList();
    }
    // if (this.functionName != null) {
    //   data['functionName'] = this.functionName!.map((v) => v.toJson()).toList();
    // }
    data['parentChildSubMenu'] = this.parentChildSubMenu;
    return data;
  }
}


