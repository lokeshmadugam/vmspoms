class PostApiResponse {
  int? status;
  int? megCategory;
  String? webMessage;
  String? mobMessage;
  var result;

  PostApiResponse(
      {this.status,
      this.megCategory,
      this.webMessage,
      this.mobMessage,
      this.result});

  PostApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['status'] is String) {
      status = int.parse(json['status']);
    } else if (json['status'] is int) {
      status = json['status'];
    }
    // status = json['status'];
    megCategory = json['megCategory'];
    webMessage = json['webMessage'];
    mobMessage = json['mobMessage'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['megCategory'] = this.megCategory;
    data['webMessage'] = this.webMessage;
    data['mobMessage'] = this.mobMessage;
    data['result'] = this.result;
    return data;
  }
}
