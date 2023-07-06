class CompanyPolicies {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  CompanyPolicies(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  CompanyPolicies.fromJson(Map<String, dynamic> json) {
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
  List<PolicyItems>? items;

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
      items = <PolicyItems>[];
      json['items'].forEach((v) {
        items!.add(new PolicyItems.fromJson(v));
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

class PolicyItems {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? policyTypeId;
  String? dispName;
  String? policyDescription;
  int? recStatus;
  String? policyTypeName;
  String? recStatusname;

  PolicyItems(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.policyTypeId,
        this.dispName,
        this.policyDescription,
        this.recStatus,
        this.policyTypeName,
        this.recStatusname});

  PolicyItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    policyTypeId = json['policy_type_id'];
    dispName = json['disp_name'];
    policyDescription = json['policy_description'];
    recStatus = json['rec_status'];
    policyTypeName = json['policyTypeName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['policy_type_id'] = this.policyTypeId;
    data['disp_name'] = this.dispName;
    data['policy_description'] = this.policyDescription;
    data['rec_status'] = this.recStatus;
    data['policyTypeName'] = this.policyTypeName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
