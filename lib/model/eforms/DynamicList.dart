class DynamicList {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  Result? result;

  DynamicList(
      {this.status,
        this.megCategory,
        this.webMessage,
        this.mobMessage,
        this.result});

  DynamicList.fromJson(Map<String, dynamic> json) {
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
  String? eformCategoryName;
  String? description;
  String? iconUrl;
  int? isDefault;
  int? recStatus;
  String? recStatusname;
  List<PropertyEformsRest>? propertyEformsRest;

  Result(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.eformCategoryName,
        this.description,
        this.iconUrl,
        this.isDefault,
        this.recStatus,
        this.recStatusname,
        this.propertyEformsRest});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    eformCategoryName = json['eform_category_name'];
    description = json['description'];
    iconUrl = json['icon_url'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    recStatusname = json['recStatusname'];
    if (json['propertyEformsRest'] != null) {
      propertyEformsRest = <PropertyEformsRest>[];
      json['propertyEformsRest'].forEach((v) {
        propertyEformsRest!.add(new PropertyEformsRest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['eform_category_name'] = this.eformCategoryName;
    data['description'] = this.description;
    data['icon_url'] = this.iconUrl;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['recStatusname'] = this.recStatusname;
    if (this.propertyEformsRest != null) {
      data['propertyEformsRest'] =
          this.propertyEformsRest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyEformsRest {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? admModuleId;
  String? eformName;
  String? eformDispName;
  int? eformCategoryId;
  int? displaySeqno;
  String? iconUrl;
  int? isDefault;
  int? recStatus;
  String? moduleName;
  String? recStatusname;
  List<PropertyEformsCategoryFieldsRest>? propertyEformsCategoryFieldsRest;
  String? eformsCategoryName;

  PropertyEformsRest(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.admModuleId,
        this.eformName,
        this.eformDispName,
        this.eformCategoryId,
        this.displaySeqno,
        this.iconUrl,
        this.isDefault,
        this.recStatus,
        this.moduleName,
        this.recStatusname,
        this.propertyEformsCategoryFieldsRest,
        this.eformsCategoryName});

  PropertyEformsRest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    admModuleId = json['adm_module_id'];
    eformName = json['eform_name'];
    eformDispName = json['eform_disp_name'];
    eformCategoryId = json['eform_category_id'];
    displaySeqno = json['display_seqno'];
    iconUrl = json['icon_url'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    moduleName = json['moduleName'];
    recStatusname = json['recStatusname'];
    if (json['propertyEformsCategoryFieldsRest'] != null) {
      propertyEformsCategoryFieldsRest = <PropertyEformsCategoryFieldsRest>[];
      json['propertyEformsCategoryFieldsRest'].forEach((v) {
        propertyEformsCategoryFieldsRest!
            .add(new PropertyEformsCategoryFieldsRest.fromJson(v));
      });
    }
    eformsCategoryName = json['eformsCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['adm_module_id'] = this.admModuleId;
    data['eform_name'] = this.eformName;
    data['eform_disp_name'] = this.eformDispName;
    data['eform_category_id'] = this.eformCategoryId;
    data['display_seqno'] = this.displaySeqno;
    data['icon_url'] = this.iconUrl;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['moduleName'] = this.moduleName;
    data['recStatusname'] = this.recStatusname;
    if (this.propertyEformsCategoryFieldsRest != null) {
      data['propertyEformsCategoryFieldsRest'] = this
          .propertyEformsCategoryFieldsRest!
          .map((v) => v.toJson())
          .toList();
    }
    data['eformsCategoryName'] = this.eformsCategoryName;
    return data;
  }
}

class PropertyEformsCategoryFieldsRest {
  int? id;
  int? createdBy;
  String? createdOn;
  int? propertyId;
  int? eformcatGroupId;
  int? admModuleId;
  int? eformsId;
  int? fieldId;
  String? fieldDispName;
  int? isMandatory;
  int? displaySeqno;
  int? isList;
  int? isDefault;
  int? recStatus;
  String? categoryName;
  String? moduleName;
  String? eformName;
  String? fieldKeyValue;
  String? fieldTypeName;
  String? recStatusname;
  List<PropertyEformsDropdownFieldsRest>? propertyEformsDropdownFieldsRest;

  PropertyEformsCategoryFieldsRest(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.propertyId,
        this.eformcatGroupId,
        this.admModuleId,
        this.eformsId,
        this.fieldId,
        this.fieldDispName,
        this.isMandatory,
        this.displaySeqno,
        this.isList,
        this.isDefault,
        this.recStatus,
        this.categoryName,
        this.moduleName,
        this.eformName,
        this.fieldKeyValue,
        this.fieldTypeName,
        this.recStatusname,
        this.propertyEformsDropdownFieldsRest});

  PropertyEformsCategoryFieldsRest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    propertyId = json['property_id'];
    eformcatGroupId = json['eformcat_group_id'];
    admModuleId = json['adm_module_id'];
    eformsId = json['eforms_id'];
    fieldId = json['field_id'];
    fieldDispName = json['field_disp_name'];
    isMandatory = json['is_mandatory'];
    displaySeqno = json['display_seqno'];
    isList = json['is_list'];
    isDefault = json['is_default'];
    recStatus = json['rec_status'];
    categoryName = json['categoryName'];
    moduleName = json['moduleName'];
    eformName = json['eformName'];
    fieldKeyValue = json['fieldKeyValue'];
    fieldTypeName = json['fieldTypeName'];
    recStatusname = json['recStatusname'];
    if (json['propertyEformsDropdownFieldsRest'] != null) {
      propertyEformsDropdownFieldsRest = <PropertyEformsDropdownFieldsRest>[];
      json['propertyEformsDropdownFieldsRest'].forEach((v) {
        propertyEformsDropdownFieldsRest!
            .add(new PropertyEformsDropdownFieldsRest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['created_on'] = this.createdOn;
    data['property_id'] = this.propertyId;
    data['eformcat_group_id'] = this.eformcatGroupId;
    data['adm_module_id'] = this.admModuleId;
    data['eforms_id'] = this.eformsId;
    data['field_id'] = this.fieldId;
    data['field_disp_name'] = this.fieldDispName;
    data['is_mandatory'] = this.isMandatory;
    data['display_seqno'] = this.displaySeqno;
    data['is_list'] = this.isList;
    data['is_default'] = this.isDefault;
    data['rec_status'] = this.recStatus;
    data['categoryName'] = this.categoryName;
    data['moduleName'] = this.moduleName;
    data['eformName'] = this.eformName;
    data['fieldKeyValue'] = this.fieldKeyValue;
    data['fieldTypeName'] = this.fieldTypeName;
    data['recStatusname'] = this.recStatusname;
    if (this.propertyEformsDropdownFieldsRest != null) {
      data['propertyEformsDropdownFieldsRest'] = this
          .propertyEformsDropdownFieldsRest!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class PropertyEformsDropdownFieldsRest {
  int? id;
  int? createdBy;
  String? createdOn;
  int? eformsCatfieldId;
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

  PropertyEformsDropdownFieldsRest(
      {this.id,
        this.createdBy,
        this.createdOn,
        this.eformsCatfieldId,
        this.fieldType,
        this.fieldDispName,
        this.displaySeqno,
        this.isDefault,
        this.recStatus,
        this.fieldTypeName,
        this.fieldTypeNameconfigKeyValue,
        this.dropdownMenufieldName,
        this.recStatusname});

  PropertyEformsDropdownFieldsRest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    createdOn = json['created_on'];
    eformsCatfieldId = json['eforms_catfield_id'];
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
    data['eforms_catfield_id'] = this.eformsCatfieldId;
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
