class EmergencyService {
int? status;
int? megCategory;
String? webMessage;
String? mobMessage;
Result? result;

EmergencyService({this.status, this.megCategory, this.webMessage, this.mobMessage, this.result});

EmergencyService.fromJson(Map<String, dynamic> json) {
status = json['status'];
megCategory = json['megCategory'];
webMessage = json['webMessage'];
mobMessage = json['mobMessage'];
result = json['result'] != null ? new Result.fromJson(json['result']) : null;
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
  List<EmergencyItems>? items;

  Result({this.pageNumber, this.pageSize, this.totalPage, this.itemCounts, this.totalItemCounts, this.orderBy, this.orderByPropertyName, this.items});

  Result.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    itemCounts = json['itemCounts'];
    totalItemCounts = json['totalItemCounts'];
    orderBy = json['orderBy'];
    orderByPropertyName = json['orderByPropertyName'];
    if (json['items'] != null) {
      items = <EmergencyItems>[];
      json['items'].forEach((v) { items!.add(new EmergencyItems.fromJson(v)); });
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

class EmergencyItems {
  int? id;
  int? createdBy;
  String? createdOn;
  String? countryCode;
  String? countryName;
  String? state;
  int? serviceType;
  int? subserviceType;
  String? serviceName;
  String? serviceProviderName;
  String? dialNumber;
  String? serviceProviderUrl;
  int? recStatus;
  String? recStatusname;
  String? serviceTypeName;
  String? subserviceTypeName;

  EmergencyItems({this.id, this.createdBy, this.createdOn, this.countryCode, this.countryName, this.state, this.serviceType, this.subserviceType, this.serviceName, this.serviceProviderName, this.dialNumber, this.serviceProviderUrl, this.recStatus, this.recStatusname, this.serviceTypeName, this.subserviceTypeName});

  EmergencyItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    state = json['state'];
    serviceType = json['service_type'];
    subserviceType = json['subservice_type'];
    serviceName = json['service_name'];
    serviceProviderName = json['service_provider_name'];
    dialNumber = json['dial_number'];
    serviceProviderUrl = json['service_provider_url'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    serviceTypeName = json['serviceTypeName'];
    subserviceTypeName = json['subserviceTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['state'] = this.state;
    data['service_type'] = this.serviceType;
    data['subservice_type'] = this.subserviceType;
    data['service_name'] = this.serviceName;
    data['service_provider_name'] = this.serviceProviderName;
    data['dial_number'] = this.dialNumber;
    data['service_provider_url'] = this.serviceProviderUrl;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['serviceTypeName'] = this.serviceTypeName;
    data['subserviceTypeName'] = this.subserviceTypeName;
    return data;
  }
}
