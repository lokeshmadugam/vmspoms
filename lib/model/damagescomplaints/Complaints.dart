class Complaints {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  Complaints(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  Complaints.fromJson(Map<String, dynamic> json) {
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
  List<ComplaintItems>? items;

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
      items = <ComplaintItems>[];
      json['items'].forEach((v) {
        items!.add(new ComplaintItems.fromJson(v));
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

class ComplaintItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? complaintTypeId;
  int? complaintFromUserId;
  String? complaintFromDate;
  int? complaintToAppUsertypeId;
  String? complaintPics;
  int? complaintAssignedToUserId;
  String? complaintResolution;
  int? resolutionGivenByUsrid;
  String? resolutionDatetime;
  int? notifyUserCommModeId;
  int? complaintStatus;
  String? complaintDescription;
  String? ipAddress;
  int? recStatus;
  String? blockName;
  String? unitNo;
  String? complaintStatusName;
  String? complaintTypeName;
  String? recStatusname;

  ComplaintItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.complaintTypeId,
      this.complaintFromUserId,
      this.complaintFromDate,
      this.complaintToAppUsertypeId,
      this.complaintPics,
      this.complaintAssignedToUserId,
      this.complaintResolution,
      this.resolutionGivenByUsrid,
      this.resolutionDatetime,
      this.notifyUserCommModeId,
      this.complaintStatus,
      this.complaintDescription,
      this.ipAddress,
      this.recStatus,
      this.blockName,
      this.unitNo,
      this.complaintStatusName,
      this.complaintTypeName,
      this.recStatusname});

  ComplaintItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    complaintTypeId = json['complaint_type_id'];
    complaintFromUserId = json['complaint_from_user_id'];
    complaintFromDate = json['complaint_from_date'];
    complaintToAppUsertypeId = json['complaint_to_app_usertype_id'];
    complaintPics = json['complaint_pics'];
    complaintAssignedToUserId = json['complaint_assigned_to_user_id'];
    complaintResolution = json['complaint_resolution'];
    resolutionGivenByUsrid = json['resolution_given_by_usrid'];
    resolutionDatetime = json['resolution_datetime'];
    notifyUserCommModeId = json['notify_user_comm_mode_id'];
    complaintStatus = json['complaint_status'];
    complaintDescription = json['complaint_description'];
    ipAddress = json['ip_address'];
    recStatus = json['rec_status'];
    blockName = json['block_name'];
    unitNo = json['unit_no'];
    complaintStatusName = json['complaintStatusName'];
    complaintTypeName = json['complaintTypeName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['complaint_type_id'] = this.complaintTypeId;
    data['complaint_from_user_id'] = this.complaintFromUserId;
    data['complaint_from_date'] = this.complaintFromDate;
    data['complaint_to_app_usertype_id'] = this.complaintToAppUsertypeId;
    data['complaint_pics'] = this.complaintPics;
    data['complaint_assigned_to_user_id'] = this.complaintAssignedToUserId;
    data['complaint_resolution'] = this.complaintResolution;
    data['resolution_given_by_usrid'] = this.resolutionGivenByUsrid;
    data['resolution_datetime'] = this.resolutionDatetime;
    data['notify_user_comm_mode_id'] = this.notifyUserCommModeId;
    data['complaint_status'] = this.complaintStatus;
    data['complaint_description'] = this.complaintDescription;
    data['ip_address'] = this.ipAddress;
    data['rec_status'] = this.recStatus;
    data['block_name'] = this.blockName;
    data['unit_no'] = this.unitNo;
    data['complaintStatusName'] = this.complaintStatusName;
    data['complaintTypeName'] = this.complaintTypeName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
