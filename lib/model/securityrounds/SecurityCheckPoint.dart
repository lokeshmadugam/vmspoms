class SecurityCheckPoint {
  int? status;
  String? message;
  Result? result;

  SecurityCheckPoint({this.status, this.message, this.result});

  SecurityCheckPoint.fromJson(Map<String, dynamic> json) {
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
  int? propertyId;
  String? checkpointName;
  String? checkpointLocation;
  String? checkpointLocationMap;
  String? ckpointLocationLevel;
  String? ckpointLocationLatitude;
  String? ckpointLocationLongitude;
  String? checkpointLocationImg;
  int? isCheckpointRoundsRequired;
  int? checkpointRoundsFrequency;
  int? noCheckpointRoundsVisits;
  String? remarks;
  int? recStatus;
  String? recStatusname;
  String? checkpointRoundsFrequencyName;

  Items(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.checkpointName,
        this.checkpointLocation,
        this.checkpointLocationMap,
        this.ckpointLocationLevel,
        this.ckpointLocationLatitude,
        this.ckpointLocationLongitude,
        this.checkpointLocationImg,
        this.isCheckpointRoundsRequired,
        this.checkpointRoundsFrequency,
        this.noCheckpointRoundsVisits,
        this.remarks,
        this.recStatus,
        this.recStatusname,
        this.checkpointRoundsFrequencyName});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    checkpointName = json['checkpoint_name'];
    checkpointLocation = json['checkpoint_location'];
    checkpointLocationMap = json['checkpoint_location_map'];
    ckpointLocationLevel = json['ckpoint_location_level'];
    ckpointLocationLatitude = json['ckpoint_location_latitude'];
    ckpointLocationLongitude = json['ckpoint_location_longitude'];
    checkpointLocationImg = json['checkpoint_location_img'];
    isCheckpointRoundsRequired = json['is_checkpoint_rounds_required'];
    checkpointRoundsFrequency = json['checkpoint_rounds_frequency'];
    noCheckpointRoundsVisits = json['no_checkpoint_rounds_visits'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    checkpointRoundsFrequencyName = json['checkpointRoundsFrequencyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['checkpoint_name'] = this.checkpointName;
    data['checkpoint_location'] = this.checkpointLocation;
    data['checkpoint_location_map'] = this.checkpointLocationMap;
    data['ckpoint_location_level'] = this.ckpointLocationLevel;
    data['ckpoint_location_latitude'] = this.ckpointLocationLatitude;
    data['ckpoint_location_longitude'] = this.ckpointLocationLongitude;
    data['checkpoint_location_img'] = this.checkpointLocationImg;
    data['is_checkpoint_rounds_required'] = this.isCheckpointRoundsRequired;
    data['checkpoint_rounds_frequency'] = this.checkpointRoundsFrequency;
    data['no_checkpoint_rounds_visits'] = this.noCheckpointRoundsVisits;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['checkpointRoundsFrequencyName'] = this.checkpointRoundsFrequencyName;
    return data;
  }
}
