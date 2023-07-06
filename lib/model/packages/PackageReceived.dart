class PackageReceived {
  int? status;
  String? message;
  Result? result;

  PackageReceived({this.status, this.message, this.result});

  PackageReceived.fromJson(Map<String, dynamic> json) {
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
  String? unitNumber;
  String? blockName;
  int? packageTypeId;
  String? packageFrom;
  int? packageReceivedBy;
  int? packageReceiptsStatus;
  String? packageReceivedDate;
  String? packageReceiptNotification;
  String? packageCollectedBy;
  String? packageCollectedOn;
  String? packageCollectionAckImg;
  String? collectionDate;
  String? packageImg;
  String? remarks;
  int? recStatus;
  String? packageReceiptsStatusName;
  String? recStatusname;

  Items(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.unitNumber,
        this.blockName,
        this.packageTypeId,
        this.packageFrom,
        this.packageReceivedBy,
        this.packageReceiptsStatus,
        this.packageReceivedDate,
        this.packageReceiptNotification,
        this.packageCollectedBy,
        this.packageCollectedOn,
        this.packageCollectionAckImg,
        this.collectionDate,
        this.packageImg,
        this.remarks,
        this.recStatus,
        this.packageReceiptsStatusName,
        this.recStatusname});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    unitNumber = json['unit_number'];
    blockName = json['block_name'];
    packageTypeId = json['package_type_id'];
    packageFrom = json['package_from'];
    packageReceivedBy = json['package_received_by'];
    packageReceiptsStatus = json['package_receipts_status'];
    packageReceivedDate = json['package_received_date'];
    packageReceiptNotification = json['package_receipt_notification'];
    packageCollectedBy = json['package_collected_by'];
    packageCollectedOn = json['package_collected_on'];
    packageCollectionAckImg = json['package_collection_ack_img'];
    collectionDate = json['collection_date'];
    packageImg = json['package_img'];
    remarks = json['remarks'];
    recStatus = json['rec_status'];
    packageReceiptsStatusName = json['packageReceiptsStatusName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['unit_number'] = this.unitNumber;
    data['block_name'] = this.blockName;
    data['package_type_id'] = this.packageTypeId;
    data['package_from'] = this.packageFrom;
    data['package_received_by'] = this.packageReceivedBy;
    data['package_receipts_status'] = this.packageReceiptsStatus;
    data['package_received_date'] = this.packageReceivedDate;
    data['package_receipt_notification'] = this.packageReceiptNotification;
    data['package_collected_by'] = this.packageCollectedBy;
    data['package_collected_on'] = this.packageCollectedOn;
    data['package_collection_ack_img'] = this.packageCollectionAckImg;
    data['collection_date'] = this.collectionDate;
    data['package_img'] = this.packageImg;
    data['remarks'] = this.remarks;
    data['rec_status'] = this.recStatus;
    data['packageReceiptsStatusName'] = this.packageReceiptsStatusName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
