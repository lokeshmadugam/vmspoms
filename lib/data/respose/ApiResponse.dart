
import 'package:poms_app/data/respose/Status.dart';
class ApiResponse<T> {
  //Coming from eum class
  Status? status;
  //Dynamic function to take the data
  T? data;
  //message
  String? message;
  //constructor
  ApiResponse(this.status, this.data, this.message);

  //If data is loading then it'll take loading from status enum
  ApiResponse.loading() : status = Status.loading;
  ApiResponse.success(this.data) : status = Status.success;
  // ApiResponse.webMessage(this.data, this.message) : status = Status.webMessage;
  // ApiResponse.mobMessage(this.data, this.message) : status = Status.mobMessage;
  ApiResponse.error(this.message) : status = Status.error;
  //Override method
  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }


}
