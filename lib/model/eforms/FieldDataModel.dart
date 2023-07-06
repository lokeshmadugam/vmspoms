class FieldDataModel {
  int? id;
  int? fldDatatypeId;
  String? fieldDispName;
  String? fldValue;

  FieldDataModel(
      {this.id, this.fldDatatypeId, this.fieldDispName, this.fldValue});

  FieldDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fldDatatypeId = json['fld_datatype_id'];
    fieldDispName = json['field_disp_name'];
    fldValue = json['fld_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fld_datatype_id'] = this.fldDatatypeId;
    data['field_disp_name'] = this.fieldDispName;
    data['fld_value'] = this.fldValue;
    return data;
  }
}
