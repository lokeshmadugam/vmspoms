class ManagementSecurity {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  ManagementSecurity(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  ManagementSecurity.fromJson(Map<String, dynamic> json) {
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
  List<MgmtSecurityItems>? items;

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
      items = <MgmtSecurityItems>[];
      json['items'].forEach((v) {
        items!.add(new MgmtSecurityItems.fromJson(v));
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

class MgmtSecurityItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? mgmtInhouseServicesId;
  int? serviceTypeId;
  String? contactName;
  String? phoneNo;
  int? contactPriority;
  String? remark;
  int? recStatus;
  String? mgmtInhouseServicesName;
  String? serviceTypeName;
  String? recStatusname;

  MgmtSecurityItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.mgmtInhouseServicesId,
      this.serviceTypeId,
      this.contactName,
      this.phoneNo,
      this.contactPriority,
      this.remark,
      this.recStatus,
      this.mgmtInhouseServicesName,
      this.serviceTypeName,
      this.recStatusname});

  MgmtSecurityItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    mgmtInhouseServicesId = json['mgmt_inhouse_services_id'];
    serviceTypeId = json['service_type_id'];
    contactName = json['contact_name'];
    phoneNo = json['phone_no'];
    contactPriority = json['contact_priority'];
    remark = json['remark'];
    recStatus = json['rec_status'];
    mgmtInhouseServicesName = json['mgmtInhouseServicesName'];
    serviceTypeName = json['serviceTypeName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['mgmt_inhouse_services_id'] = this.mgmtInhouseServicesId;
    data['service_type_id'] = this.serviceTypeId;
    data['contact_name'] = this.contactName;
    data['phone_no'] = this.phoneNo;
    data['contact_priority'] = this.contactPriority;
    data['remark'] = this.remark;
    data['rec_status'] = this.recStatus;
    data['mgmtInhouseServicesName'] = this.mgmtInhouseServicesName;
    data['serviceTypeName'] = this.serviceTypeName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
