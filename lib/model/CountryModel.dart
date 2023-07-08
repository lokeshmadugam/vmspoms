class CountryModel {
  int? status;
  String? message;
  Result? result;

  CountryModel({this.status, this.message, this.result});

  CountryModel.fromJson(Map<String, dynamic> json) {
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
  List<CountryItems>? items;

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
      items = <CountryItems>[];
      json['items'].forEach((v) {
        items!.add(new CountryItems.fromJson(v));
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

class CountryItems {
  int? id;
  int? createdBy;
  String? createdOn;
  String? alpha2Code;
  String? alpha3Code;
  String? callingCode;
  String? currencyCode;
  String? currencySymbol;
  String? domain;
  String? svgFlagUrl;
  String? mobFlagUrl;
  String? cloudImgUrl;
  String? serverImgPath;
  int? dbImg;
  String? name;
  String? nativeName;
  String? region;
  String? urlTag;
  int? seqNo;
  int? activeFlag;
  int? status;
  String? recStatusname;

  CountryItems(
      {this.id,
      this.createdBy,
      this.createdOn,
      this.alpha2Code,
      this.alpha3Code,
      this.callingCode,
      this.currencyCode,
      this.currencySymbol,
      this.domain,
      this.svgFlagUrl,
      this.mobFlagUrl,
      this.cloudImgUrl,
      this.serverImgPath,
      this.dbImg,
      this.name,
      this.nativeName,
      this.region,
      this.urlTag,
      this.seqNo,
      this.activeFlag,
      this.status,
      this.recStatusname});

  CountryItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    alpha2Code = json['alpha2_code'];
    alpha3Code = json['alpha3_code'];
    callingCode = json['calling_code'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    domain = json['domain'];
    svgFlagUrl = json['svg_flag_url'];
    mobFlagUrl = json['mob_flag_url'];
    cloudImgUrl = json['cloud_img_url'];
    serverImgPath = json['server_img_path'];
    dbImg = json['db_img'];
    name = json['name'];
    nativeName = json['native_name'];
    region = json['region'];
    urlTag = json['url_tag'];
    seqNo = json['seq_no'];
    activeFlag = json['active_flag'];
    status = json['status'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['alpha2_code'] = this.alpha2Code;
    data['alpha3_code'] = this.alpha3Code;
    data['calling_code'] = this.callingCode;
    data['currency_code'] = this.currencyCode;
    data['currency_symbol'] = this.currencySymbol;
    data['domain'] = this.domain;
    data['svg_flag_url'] = this.svgFlagUrl;
    data['mob_flag_url'] = this.mobFlagUrl;
    data['cloud_img_url'] = this.cloudImgUrl;
    data['server_img_path'] = this.serverImgPath;
    data['db_img'] = this.dbImg;
    data['name'] = this.name;
    data['native_name'] = this.nativeName;
    data['region'] = this.region;
    data['url_tag'] = this.urlTag;
    data['seq_no'] = this.seqNo;
    data['active_flag'] = this.activeFlag;
    data['status'] = this.status;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
