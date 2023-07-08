class UnclaimedItems {
  int? status;
  String? message;
  Result? result;

  UnclaimedItems({this.status, this.message, this.result});

  UnclaimedItems.fromJson(Map<String, dynamic> json) {
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
  int? lostReportUserId;
  Null? lostUnitNo;
  String? lostLocation;
  String? lostDescription;
  String? lostItemName;
  Null? lostDateTime;
  String? lostItemImgUrl;
  int? foundBy;
  String? foundLocation;
  String? foundDescription;
  String? foundItemName;
  String? foundDateTime;
  int? collectedBy;
  String? collectedRemarks;
  String? collectedDateTime;
  Null? receivedBySign;
  String? foundByItemPic;
  String? foundUnitNo;
  int? recStatus;
  String? recStatusname;
  String? foundByFirstName;
  String? foundByLastName;
  String? collectedByFirstName;
  String? collectedByLastName;

  Items(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyId,
      this.lostReportUserId,
      this.lostUnitNo,
      this.lostLocation,
      this.lostDescription,
      this.lostItemName,
      this.lostDateTime,
      this.lostItemImgUrl,
      this.foundBy,
      this.foundLocation,
      this.foundDescription,
      this.foundItemName,
      this.foundDateTime,
      this.collectedBy,
      this.collectedRemarks,
      this.collectedDateTime,
      this.receivedBySign,
      this.foundByItemPic,
      this.foundUnitNo,
      this.recStatus,
      this.recStatusname,
      this.foundByFirstName,
      this.foundByLastName,
      this.collectedByFirstName,
      this.collectedByLastName});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    lostReportUserId = json['lost_report_user_id'];
    lostUnitNo = json['lost_unit_no'];
    lostLocation = json['lost_location'];
    lostDescription = json['lost_description'];
    lostItemName = json['lost_item_name'];
    lostDateTime = json['lost_date_time'];
    lostItemImgUrl = json['lost_item_img_url'];
    foundBy = json['found_by'];
    foundLocation = json['found_location'];
    foundDescription = json['found_description'];
    foundItemName = json['found_item_name'];
    foundDateTime = json['found_date_time'];
    collectedBy = json['collected_by'];
    collectedRemarks = json['collected_remarks'];
    collectedDateTime = json['collected_date_time'];
    receivedBySign = json['received_by_sign'];
    foundByItemPic = json['found_by_item_pic'];
    foundUnitNo = json['found_unit_no'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    foundByFirstName = json['foundByFirstName'];
    foundByLastName = json['foundByLastName'];
    collectedByFirstName = json['collectedByFirstName'];
    collectedByLastName = json['collectedByLastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['lost_report_user_id'] = this.lostReportUserId;
    data['lost_unit_no'] = this.lostUnitNo;
    data['lost_location'] = this.lostLocation;
    data['lost_description'] = this.lostDescription;
    data['lost_item_name'] = this.lostItemName;
    data['lost_date_time'] = this.lostDateTime;
    data['lost_item_img_url'] = this.lostItemImgUrl;
    data['found_by'] = this.foundBy;
    data['found_location'] = this.foundLocation;
    data['found_description'] = this.foundDescription;
    data['found_item_name'] = this.foundItemName;
    data['found_date_time'] = this.foundDateTime;
    data['collected_by'] = this.collectedBy;
    data['collected_remarks'] = this.collectedRemarks;
    data['collected_date_time'] = this.collectedDateTime;
    data['received_by_sign'] = this.receivedBySign;
    data['found_by_item_pic'] = this.foundByItemPic;
    data['found_unit_no'] = this.foundUnitNo;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['foundByFirstName'] = this.foundByFirstName;
    data['foundByLastName'] = this.foundByLastName;
    data['collectedByFirstName'] = this.collectedByFirstName;
    data['collectedByLastName'] = this.collectedByLastName;
    return data;
  }
}
