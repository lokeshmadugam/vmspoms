class GetAllParkings {
  int? status;
  String? message;
  List<UnOccupied>? unOccupied;
  List<Occupied>? occupied;

  GetAllParkings({this.status, this.message, this.unOccupied, this.occupied});

  GetAllParkings.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['unOccupied'] != null) {
      unOccupied = <UnOccupied>[];
      json['unOccupied'].forEach((v) {
        unOccupied!.add(new UnOccupied.fromJson(v));
      });
    }
    if (json['occupied'] != null) {
      occupied = <Occupied>[];
      json['occupied'].forEach((v) {
        occupied!.add(new Occupied.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.unOccupied != null) {
      data['unOccupied'] = this.unOccupied!.map((v) => v.toJson()).toList();
    }
    if (this.occupied != null) {
      data['occupied'] = this.occupied!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnOccupied {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  String? unitNo;
  String? bayLocation;
  String? bayNumber;
  int? bayType;
  String? bayUrlImg;
  int? recStatus;
  String? recStatusname;
  String? bayTypeName;

  UnOccupied(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.unitNo,
        this.bayLocation,
        this.bayNumber,
        this.bayType,
        this.bayUrlImg,
        this.recStatus,
        this.recStatusname,
        this.bayTypeName});

  UnOccupied.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    unitNo = json['unit_no'];
    bayLocation = json['bay_location'];
    bayNumber = json['bay_number'];
    bayType = json['bay_type'];
    bayUrlImg = json['bay_url_img'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    bayTypeName = json['bayTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['unit_no'] = this.unitNo;
    data['bay_location'] = this.bayLocation;
    data['bay_number'] = this.bayNumber;
    data['bay_type'] = this.bayType;
    data['bay_url_img'] = this.bayUrlImg;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['bayTypeName'] = this.bayTypeName;
    return data;
  }
}

class Occupied {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? visitorId;
  int? unitShopId;
  int? bayType;
  String? lotNumber;
  int? bayStatus;
  String? usageDate;
  String? usageFrTime;
  Null? usageToTime;
  int? recStatus;
  String? recStatusname;
  String? bayStatusName;
  String? bayTypeName;
  String? unitNo;

  Occupied(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.visitorId,
        this.unitShopId,
        this.bayType,
        this.lotNumber,
        this.bayStatus,
        this.usageDate,
        this.usageFrTime,
        this.usageToTime,
        this.recStatus,
        this.recStatusname,
        this.bayStatusName,
        this.bayTypeName,
        this.unitNo});

  Occupied.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    visitorId = json['visitor_id'];
    unitShopId = json['unit_shop_id'];
    bayType = json['bay_type'];
    lotNumber = json['lot_number'];
    bayStatus = json['bay_status'];
    usageDate = json['usage_date'];
    usageFrTime = json['usage_fr_time'];
    usageToTime = json['usage_to_time'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    bayStatusName = json['bayStatusName'];
    bayTypeName = json['bayTypeName'];
    unitNo = json['unit_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['visitor_id'] = this.visitorId;
    data['unit_shop_id'] = this.unitShopId;
    data['bay_type'] = this.bayType;
    data['lot_number'] = this.lotNumber;
    data['bay_status'] = this.bayStatus;
    data['usage_date'] = this.usageDate;
    data['usage_fr_time'] = this.usageFrTime;
    data['usage_to_time'] = this.usageToTime;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['bayStatusName'] = this.bayStatusName;
    data['bayTypeName'] = this.bayTypeName;
    data['unit_no'] = this.unitNo;
    return data;
  }
}





