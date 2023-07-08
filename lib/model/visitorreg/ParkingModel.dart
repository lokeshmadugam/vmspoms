// class ParkingModel {
//   int? status;
//   String? message;
//   UnOccupied? unOccupied;
//   List<Null>? occupied;
//
//   ParkingModel({this.status, this.message, this.unOccupied, this.occupied});
//
//   ParkingModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     unOccupied = json['unOccupied'] != null
//         ? new UnOccupied.fromJson(json['unOccupied'])
//         : null;
//     if (json['occupied'] != null) {
//       occupied = <Null>[];
//       json['occupied'].forEach((v) {
//         occupied!.add(new Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.unOccupied != null) {
//       data['unOccupied'] = this.unOccupied!.toJson();
//     }
//     if (this.occupied != null) {
//       data['occupied'] = this.occupied!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class UnOccupied {
//   int? pageNumber;
//   int? pageSize;
//   int? totalPage;
//   int? itemCounts;
//   int? totalItemCounts;
//   String? orderBy;
//   String? orderByPropertyName;
//   List<Items>? items;
//
//   UnOccupied(
//       {this.pageNumber,
//         this.pageSize,
//         this.totalPage,
//         this.itemCounts,
//         this.totalItemCounts,
//         this.orderBy,
//         this.orderByPropertyName,
//         this.items});
//
//   UnOccupied.fromJson(Map<String, dynamic> json) {
//     pageNumber = json['pageNumber'];
//     pageSize = json['pageSize'];
//     totalPage = json['totalPage'];
//     itemCounts = json['itemCounts'];
//     totalItemCounts = json['totalItemCounts'];
//     orderBy = json['orderBy'];
//     orderByPropertyName = json['orderByPropertyName'];
//     if (json['items'] != null) {
//       items = <Items>[];
//       json['items'].forEach((v) {
//         items!.add(new Items.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pageNumber'] = this.pageNumber;
//     data['pageSize'] = this.pageSize;
//     data['totalPage'] = this.totalPage;
//     data['itemCounts'] = this.itemCounts;
//     data['totalItemCounts'] = this.totalItemCounts;
//     data['orderBy'] = this.orderBy;
//     data['orderByPropertyName'] = this.orderByPropertyName;
//     if (this.items != null) {
//       data['items'] = this.items!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Items {
//   int? id;
//   int? createdBy;
//   String? createdOn;
//   int? propertyId;
//   String? unitNo;
//   String? bayLocation;
//   String? bayNumber;
//   int? bayType;
//   String? bayUrlImg;
//   int? recStatus;
//   String? recStatusname;
//   String? bayTypeName;
//
//   Items(
//       {this.id,
//         this.createdBy,
//         this.createdOn,
//         this.propertyId,
//         this.unitNo,
//         this.bayLocation,
//         this.bayNumber,
//         this.bayType,
//         this.bayUrlImg,
//         this.recStatus,
//         this.recStatusname,
//         this.bayTypeName});
//
//   Items.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     createdBy = json['created_by'];
//     createdOn = json['created_on'];
//     propertyId = json['property_id'];
//     unitNo = json['unit_no'];
//     bayLocation = json['bay_location'];
//     bayNumber = json['bay_number'];
//     bayType = json['bay_type'];
//     bayUrlImg = json['bay_url_img'];
//     recStatus = json['rec_status'];
//     recStatusname = json['recStatusname'];
//     bayTypeName = json['bayTypeName'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['created_by'] = this.createdBy;
//     data['created_on'] = this.createdOn;
//     data['property_id'] = this.propertyId;
//     data['unit_no'] = this.unitNo;
//     data['bay_location'] = this.bayLocation;
//     data['bay_number'] = this.bayNumber;
//     data['bay_type'] = this.bayType;
//     data['bay_url_img'] = this.bayUrlImg;
//     data['rec_status'] = this.recStatus;
//     data['recStatusname'] = this.recStatusname;
//     data['bayTypeName'] = this.bayTypeName;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final parkingModel = parkingModelFromJson(jsonString);

import 'dart:convert';

ParkingModel parkingModelFromJson(String str) =>
    ParkingModel.fromJson(json.decode(str));

String parkingModelToJson(ParkingModel data) => json.encode(data.toJson());

class ParkingModel {
  int status;
  String message;
  UnOccupied unOccupied;
  List<dynamic> occupied;

  ParkingModel({
    required this.status,
    required this.message,
    required this.unOccupied,
    required this.occupied,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) => ParkingModel(
        status: json["status"],
        message: json["message"],
        unOccupied: UnOccupied.fromJson(json["unOccupied"]),
        occupied: List<dynamic>.from(json["occupied"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "unOccupied": unOccupied.toJson(),
        "occupied": List<dynamic>.from(occupied.map((x) => x)),
      };
}

class UnOccupied {
  int? pageNumber;
  int? pageSize;
  int? totalPage;
  int? itemCounts;
  int? totalItemCounts;
  String? orderBy;
  String? orderByPropertyName;
  List<ParkingItem>? items;

  UnOccupied({
    this.pageNumber,
    this.pageSize,
    this.totalPage,
    this.itemCounts,
    this.totalItemCounts,
    this.orderBy,
    this.orderByPropertyName,
    this.items,
  });

  factory UnOccupied.fromJson(Map<String, dynamic> json) => UnOccupied(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalPage: json["totalPage"],
        itemCounts: json["itemCounts"],
        totalItemCounts: json["totalItemCounts"],
        orderBy: json["orderBy"],
        orderByPropertyName: json["orderByPropertyName"],
        items: List<ParkingItem>.from(
            json["items"].map((x) => ParkingItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalPage": totalPage,
        "itemCounts": itemCounts,
        "totalItemCounts": totalItemCounts,
        "orderBy": orderBy,
        "orderByPropertyName": orderByPropertyName,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class ParkingItem {
  int? id;
  int? createdBy;
  DateTime? createdOn;
  int? propertyId;
  String? unitNo;
  String? bayLocation;
  String? bayNumber;
  int? bayType;
  String? bayUrlImg;
  int? recStatus;
  String? recStatusname;
  String? bayTypeName;

  ParkingItem({
    this.id,
    this.createdBy,
    this.createdOn,
    this.propertyId,
    this.unitNo,
    this.bayLocation,
    this.bayNumber,
    this.bayType,
    this.bayUrlImg,
    this.recStatus,
    this.recStatusname,
    this.bayTypeName,
  });

  factory ParkingItem.fromJson(Map<String, dynamic> json) => ParkingItem(
        id: json["id"],
        createdBy: json["created_by"],
        createdOn: DateTime.parse(json["created_on"]),
        propertyId: json["property_id"],
        unitNo: json["unit_no"],
        bayLocation: json["bay_location"],
        bayNumber: json["bay_number"],
        bayType: json["bay_type"],
        bayUrlImg: json["bay_url_img"],
        recStatus: json["rec_status"],
        recStatusname: json["recStatusname"],
        bayTypeName: json["bayTypeName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "created_on": createdOn?.toIso8601String(),
        "property_id": propertyId,
        "unit_no": unitNo,
        "bay_location": bayLocation,
        "bay_number": bayNumber,
        "bay_type": bayType,
        "bay_url_img": bayUrlImg,
        "rec_status": recStatus,
        "recStatusname": recStatusname,
        "bayTypeName": bayTypeName,
      };
}
