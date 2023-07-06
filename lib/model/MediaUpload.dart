// class MediaUpload {
//   String? originalName;
//   String? refName;
//
//   MediaUpload({this.originalName, this.refName});
//
//   MediaUpload.fromJson(Map<String, dynamic> json) {
//     originalName = json['originalName'];
//     refName = json['refName'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['originalName'] = this.originalName;
//     data['refName'] = this.refName;
//     return data;
//   }
// }

class MediaUpload {
  final String? originalName;
  final String? refName;

  MediaUpload({this.originalName, this.refName});

  factory MediaUpload.fromJson(Map<String, dynamic> json) {
    return MediaUpload(
      originalName: json['originalName'],
      refName: json['refName'],
    );
  }
}