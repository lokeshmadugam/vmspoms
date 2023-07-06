class SecurityViewDetails {
  int? status;
  String? message;
  Result? result;

  SecurityViewDetails({this.status, this.message, this.result});

  SecurityViewDetails.fromJson(Map<String, dynamic> json) {
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
  int? roundsGroupid;
  int? checkpointId;
  int? checkinOfficerUserid;
  String? checkinTime;
  String? checkinLatitude;
  String? checkinLongitude;
  String? checkpointLocationImg;
  int? checkpointVisitDailyCnt;
  String? remarks;
  int? recStatus;
  String? recStatusname;
  String? securityFirstName;
  String? securityLastName;
  String? checkpointName;
  List<MapView>? mapView;
  List<CheckPointImg>? checkPointImg;

  Items(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.roundsGroupid,
        this.checkpointId,
        this.checkinOfficerUserid,
        this.checkinTime,
        this.checkinLatitude,
        this.checkinLongitude,
        this.checkpointLocationImg,
        this.checkpointVisitDailyCnt,
        this.remarks,
        this.recStatus,
        this.recStatusname,
        this.securityFirstName,
        this.securityLastName,
        this.mapView,
        this.checkpointName,
        this.checkPointImg});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    roundsGroupid = json['rounds_groupid'];
    checkpointId = json['checkpoint_id'];
    checkinOfficerUserid = json['checkin_officer_userid'];
    checkinTime = json['checkin_time'];
    checkinLatitude = json['checkin_latitude'];
    checkinLongitude = json['checkin_longitude'];
    checkpointLocationImg = json['checkpoint_location_img'];
    checkpointVisitDailyCnt = json['checkpoint_visit_daily_cnt'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    securityFirstName = json['securityFirstName'];
    checkpointName = json['checkpointName'];
    securityLastName = json['securityLastName'];
    if (json['mapView'] != null) {
      mapView = <MapView>[];
      json['mapView'].forEach((v) {
        mapView!.add(new MapView.fromJson(v));
      });
    }
    if (json['checkPointImg'] != null) {
      checkPointImg = <CheckPointImg>[];
      json['checkPointImg'].forEach((v) {
        checkPointImg!.add(new CheckPointImg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['rounds_groupid'] = this.roundsGroupid;
    data['checkpoint_id'] = this.checkpointId;
    data['checkin_officer_userid'] = this.checkinOfficerUserid;
    data['checkin_time'] = this.checkinTime;
    data['checkin_latitude'] = this.checkinLatitude;
    data['checkin_longitude'] = this.checkinLongitude;
    data['checkpoint_location_img'] = this.checkpointLocationImg;
    data['checkpoint_visit_daily_cnt'] = this.checkpointVisitDailyCnt;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['securityFirstName'] = this.securityFirstName;
    data['checkpointName'] = this.checkpointName;
    data['securityLastName'] = this.securityLastName;
    if (this.mapView != null) {
      data['mapView'] = this.mapView!.map((v) => v.toJson()).toList();
    }
    if (this.checkPointImg != null) {
      data['checkPointImg'] =
          this.checkPointImg!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MapView {
  String? checkinLatitude;
  String? checkinLongitude;

  MapView({this.checkinLatitude, this.checkinLongitude});

  MapView.fromJson(Map<String, dynamic> json) {
    checkinLatitude = json['checkin_latitude'];
    checkinLongitude = json['checkin_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkin_latitude'] = this.checkinLatitude;
    data['checkin_longitude'] = this.checkinLongitude;
    return data;
  }
}

class CheckPointImg {
  String? checkpointLocationImg;

  CheckPointImg({this.checkpointLocationImg});

  CheckPointImg.fromJson(Map<String, dynamic> json) {
    checkpointLocationImg = json['checkpoint_location_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkpoint_location_img'] = this.checkpointLocationImg;
    return data;
  }
}
