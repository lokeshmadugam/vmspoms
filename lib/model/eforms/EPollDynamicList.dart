class EPollDynamicList {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  EPollDynamicList(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  EPollDynamicList.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  String? epollingCategoryName;
  String? description;
  String? iconUrl;
  int? isDefault;
  int? recStatus;
  String? recStatusname;
  List<PropertyEpollingRest>? propertyEpollingRest;

  Result(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.epollingCategoryName,
        this.description,
        this.iconUrl,
        this.isDefault,
        this.recStatus,
        this.recStatusname,
        this.propertyEpollingRest});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    epollingCategoryName = json['epolling_category_name'];
    description = json['description'];
    iconUrl = json['icon_url'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    if (json['propertyEpollingRest'] != null) {
      propertyEpollingRest = <PropertyEpollingRest>[];
      json['propertyEpollingRest'].forEach((v) {
        propertyEpollingRest!.add(new PropertyEpollingRest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['epolling_category_name'] = this.epollingCategoryName;
    data['description'] = this.description;
    data['icon_url'] = this.iconUrl;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    if (this.propertyEpollingRest != null) {
      data['propertyEpollingRest'] =
          this.propertyEpollingRest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyEpollingRest {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? admModuleId;
  String? epollingName;
  String? epollingDispName;
  int? epollingCategoryId;
  int? displaySeqno;
  String? iconUrl;
  int? isDefault;
  int? recStatus;
  String? moduleName;
  String? recStatusname;
  List<PropertyEpollingCategoryFieldsRest>? propertyEpollingCategoryFieldsRest;
  String? epollingCategoryName;

  PropertyEpollingRest(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.admModuleId,
        this.epollingName,
        this.epollingDispName,
        this.epollingCategoryId,
        this.displaySeqno,
        this.iconUrl,
        this.isDefault,
        this.recStatus,
        this.moduleName,
        this.recStatusname,
        this.propertyEpollingCategoryFieldsRest,
        this.epollingCategoryName});

  PropertyEpollingRest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    admModuleId = json['adm_module_id'];
    epollingName = json['epolling_name'];
    epollingDispName = json['epolling_disp_name'];
    epollingCategoryId = json['epolling_category_id'];
    displaySeqno = json['display_seqno'];
    iconUrl = json['icon_url'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    moduleName = json['moduleName'];
    recStatusname = json['recStatusname'];
    if (json['propertyEpollingCategoryFieldsRest'] != null) {
      propertyEpollingCategoryFieldsRest =
      <PropertyEpollingCategoryFieldsRest>[];
      json['propertyEpollingCategoryFieldsRest'].forEach((v) {
        propertyEpollingCategoryFieldsRest!
            .add(new PropertyEpollingCategoryFieldsRest.fromJson(v));
      });
    }
    epollingCategoryName = json['epollingCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['adm_module_id'] = this.admModuleId;
    data['epolling_name'] = this.epollingName;
    data['epolling_disp_name'] = this.epollingDispName;
    data['epolling_category_id'] = this.epollingCategoryId;
    data['display_seqno'] = this.displaySeqno;
    data['icon_url'] = this.iconUrl;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['moduleName'] = this.moduleName;
    data['recStatusname'] = this.recStatusname;
    if (this.propertyEpollingCategoryFieldsRest != null) {
      data['propertyEpollingCategoryFieldsRest'] = this
          .propertyEpollingCategoryFieldsRest!
          .map((v) => v.toJson())
          .toList();
    }
    data['epollingCategoryName'] = this.epollingCategoryName;
    return data;
  }
}

class PropertyEpollingCategoryFieldsRest {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? epollingcatGroupId;
  int? admModuleId;
  int? epollingId;
  int? fieldId;
  String? fieldDispName;
  int? isMandatory;
  int? displaySeqno;
  int? isList;
  int? isDefault;
  int? recStatus;
  String? categoryName;
  String? fieldKeyValue;
  String? moduleName;
  String? epollingName;
  String? fieldTypeName;
  String? recStatusname;
  List<PropertyEpollingDropdownFieldsRest>? propertyEpollingDropdownFieldsRest;

  PropertyEpollingCategoryFieldsRest(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.epollingcatGroupId,
        this.admModuleId,
        this.epollingId,
        this.fieldId,
        this.fieldDispName,
        this.isMandatory,
        this.displaySeqno,
        this.isList,
        this.isDefault,
        this.recStatus,
        this.categoryName,
        this.fieldKeyValue,
        this.moduleName,
        this.epollingName,
        this.fieldTypeName,
        this.recStatusname,
        this.propertyEpollingDropdownFieldsRest});

  PropertyEpollingCategoryFieldsRest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    epollingcatGroupId = json['epollingcat_group_id'];
    admModuleId = json['adm_module_id'];
    epollingId = json['epolling_id'];
    fieldId = json['field_id'];
    fieldDispName = json['field_disp_name'];
    isMandatory = json['is_mandatory'];
    displaySeqno = json['display_seqno'];
    isList = json['is_list'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    categoryName = json['categoryName'];
    fieldKeyValue = json['fieldKeyValue'];
    moduleName = json['moduleName'];
    epollingName = json['epollingName'];
    fieldTypeName = json['fieldTypeName'];
    recStatusname = json['recStatusname'];
    if (json['propertyEpollingDropdownFieldsRest'] != null) {
      propertyEpollingDropdownFieldsRest =
      <PropertyEpollingDropdownFieldsRest>[];
      json['propertyEpollingDropdownFieldsRest'].forEach((v) {
        propertyEpollingDropdownFieldsRest!
            .add(new PropertyEpollingDropdownFieldsRest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['epollingcat_group_id'] = this.epollingcatGroupId;
    data['adm_module_id'] = this.admModuleId;
    data['epolling_id'] = this.epollingId;
    data['field_id'] = this.fieldId;
    data['field_disp_name'] = this.fieldDispName;
    data['is_mandatory'] = this.isMandatory;
    data['display_seqno'] = this.displaySeqno;
    data['is_list'] = this.isList;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['categoryName'] = this.categoryName;
    data['fieldKeyValue'] = this.fieldKeyValue;
    data['moduleName'] = this.moduleName;
    data['epollingName'] = this.epollingName;
    data['fieldTypeName'] = this.fieldTypeName;
    data['recStatusname'] = this.recStatusname;
    if (this.propertyEpollingDropdownFieldsRest != null) {
      data['propertyEpollingDropdownFieldsRest'] = this
          .propertyEpollingDropdownFieldsRest!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class PropertyEpollingDropdownFieldsRest {
  int? id;
  int? createdBy;
  String? createdOn;
  int? epollingCatfieldId;
  int? fieldType;
  String? fieldDispName;
  int? displaySeqno;
  int? isDefault;
  int? recStatus;
  String? fieldTypeName;
  String? fieldTypeNameconfigKeyValue;
  String? dropdownMenufieldName;
  String? recStatusname;
  bool? checked = false;

  PropertyEpollingDropdownFieldsRest(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.epollingCatfieldId,
        this.fieldType,
        this.fieldDispName,
        this.displaySeqno,
        this.isDefault,
        this.recStatus,
        this.fieldTypeName,
        this.fieldTypeNameconfigKeyValue,
        this.dropdownMenufieldName,
        this.checked,
        this.recStatusname});

  PropertyEpollingDropdownFieldsRest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    epollingCatfieldId = json['epolling_catfield_id'];
    fieldType = json['field_type'];
    fieldDispName = json['field_disp_name'];
    displaySeqno = json['display_seqno'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    fieldTypeName = json['fieldTypeName'];
    fieldTypeNameconfigKeyValue = json['fieldTypeNameconfigKeyValue'];
    dropdownMenufieldName = json['dropdownMenufieldName'];
    recStatusname = json['recStatusname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['epolling_catfield_id'] = this.epollingCatfieldId;
    data['field_type'] = this.fieldType;
    data['field_disp_name'] = this.fieldDispName;
    data['display_seqno'] = this.displaySeqno;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['fieldTypeName'] = this.fieldTypeName;
    data['fieldTypeNameconfigKeyValue'] = this.fieldTypeNameconfigKeyValue;
    data['dropdownMenufieldName'] = this.dropdownMenufieldName;
    data['recStatusname'] = this.recStatusname;
    return data;
  }
}
