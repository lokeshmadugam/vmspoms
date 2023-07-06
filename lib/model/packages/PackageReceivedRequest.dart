class PackageReceivedRequest {
  String? blockName;
  String? collectionDate;
  String? packageCollectedBy;
  String? packageCollectedOn;
  String? packageCollectionAckImg;
  String? packageFrom;
  String? packageImg;
  String? packageReceiptNotification;
  int? packageReceiptsStatus;
  int? packageReceivedBy;
  String? packageReceivedDate;
  int? packageTypeId;
  int? propertyId;
  int? recStatus;
  String? remarks;
  String? unitNumber;
  int? createdBy;
  int? id;
  int? updatedBy;

  PackageReceivedRequest(
      {this.blockName,
        this.collectionDate,
        this.packageCollectedBy,
        this.packageCollectedOn,
        this.packageCollectionAckImg,
        this.packageFrom,
        this.packageImg,
        this.packageReceiptNotification,
        this.packageReceiptsStatus,
        this.packageReceivedBy,
        this.packageReceivedDate,
        this.packageTypeId,
        this.propertyId,
        this.recStatus,
        this.remarks,
        this.unitNumber,
        this.createdBy,
        this.id,
        this.updatedBy});

  PackageReceivedRequest.fromJson(Map<String, dynamic> json) {
    blockName = json['block_name'];
    collectionDate = json['collection_date'];
    packageCollectedBy = json['package_collected_by'];
    packageCollectedOn = json['package_collected_on'];
    packageCollectionAckImg = json['package_collection_ack_img'];
    packageFrom = json['package_from'];
    packageImg = json['package_img'];
    packageReceiptNotification = json['package_receipt_notification'];
    packageReceiptsStatus = json['package_receipts_status'];
    packageReceivedBy = json['package_received_by'];
    packageReceivedDate = json['package_received_date'];
    packageTypeId = json['package_type_id'];
    propertyId = json['property_id'];
    recStatus = json['rec_status'];
    remarks = json['remarks'];
    unitNumber = json['unit_number'];
    createdBy = json['created_by'];
    id = json['id'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_name'] = this.blockName;
    data['collection_date'] = this.collectionDate;
    data['package_collected_by'] = this.packageCollectedBy;
    data['package_collected_on'] = this.packageCollectedOn;
    data['package_collection_ack_img'] = this.packageCollectionAckImg;
    data['package_from'] = this.packageFrom;
    data['package_img'] = this.packageImg;
    data['package_receipt_notification'] = this.packageReceiptNotification;
    data['package_receipts_status'] = this.packageReceiptsStatus;
    data['package_received_by'] = this.packageReceivedBy;
    data['package_received_date'] = this.packageReceivedDate;
    data['package_type_id'] = this.packageTypeId;
    data['property_id'] = this.propertyId;
    data['rec_status'] = this.recStatus;
    data['remarks'] = this.remarks;
    data['unit_number'] = this.unitNumber;
    data['created_by'] = this.createdBy;
    data['id'] = this.id;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
