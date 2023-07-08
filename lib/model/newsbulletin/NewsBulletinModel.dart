class NewsBulletinModel {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  NewsBulletinModel(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  NewsBulletinModel.fromJson(Map<String, dynamic> json) {
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
  List<NewsBulletinItems>? items;

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
      items = <NewsBulletinItems>[];
      json['items'].forEach((v) {
        items!.add(new NewsBulletinItems.fromJson(v));
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

class NewsBulletinItems {
  int? id;
  int? createdBy;
  String? createdOn;
  String? propertyIds;
  String? country;
  String? state;
  String? city;
  String? newsBulletinName;
  int? announcementNewbulletinId;
  String? announcementDate;
  int? isNotifyUser;
  String? picDocument;
  String? imgUrl;
  int? notifyUserCommModeId;
  int? newsbulletinArchiveStatus;
  int? recStatus;
  String? recStatusname;
  String? newsbulletinArchiveStatusName;
  String? commModeName;
  String? announcementNewbulletinName;
  List<PropertyName>? propertyName;

  NewsBulletinItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.propertyIds,
      this.country,
      this.state,
      this.city,
      this.newsBulletinName,
      this.announcementNewbulletinId,
      this.announcementDate,
      this.isNotifyUser,
      this.picDocument,
      this.imgUrl,
      this.notifyUserCommModeId,
      this.newsbulletinArchiveStatus,
      this.recStatus,
      this.recStatusname,
      this.newsbulletinArchiveStatusName,
      this.commModeName,
      this.announcementNewbulletinName,
      this.propertyName});

  NewsBulletinItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyIds = json['property_ids'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    newsBulletinName = json['news_bulletin_name'];
    announcementNewbulletinId = json['announcement_newbulletin_id'];
    announcementDate = json['announcement_date'];
    isNotifyUser = json['is_notify_user'];
    picDocument = json['pic_document'];
    imgUrl = json['img_url'];
    notifyUserCommModeId = json['notify_user_comm_mode_id'];
    newsbulletinArchiveStatus = json['newsbulletin_archive_status'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    newsbulletinArchiveStatusName = json['newsbulletinArchiveStatusName'];
    commModeName = json['commModeName'];
    announcementNewbulletinName = json['announcementNewbulletinName'];
    if (json['propertyName'] != null) {
      propertyName = <PropertyName>[];
      json['propertyName'].forEach((v) {
        propertyName!.add(new PropertyName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_ids'] = this.propertyIds;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['news_bulletin_name'] = this.newsBulletinName;
    data['announcement_newbulletin_id'] = this.announcementNewbulletinId;
    data['announcement_date'] = this.announcementDate;
    data['is_notify_user'] = this.isNotifyUser;
    data['pic_document'] = this.picDocument;
    data['img_url'] = this.imgUrl;
    data['notify_user_comm_mode_id'] = this.notifyUserCommModeId;
    data['newsbulletin_archive_status'] = this.newsbulletinArchiveStatus;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    data['newsbulletinArchiveStatusName'] = this.newsbulletinArchiveStatusName;
    data['commModeName'] = this.commModeName;
    data['announcementNewbulletinName'] = this.announcementNewbulletinName;
    if (this.propertyName != null) {
      data['propertyName'] = this.propertyName!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyName {
  String? propertyDispName;

  PropertyName({this.propertyDispName});

  PropertyName.fromJson(Map<String, dynamic> json) {
    propertyDispName = json['propertyDispName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['propertyDispName'] = this.propertyDispName;
    return data;
  }
}
