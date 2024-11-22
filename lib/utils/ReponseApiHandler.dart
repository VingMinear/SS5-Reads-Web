import 'package:homework3/utils/Utilty.dart';

ResponseModel checkResponse(Map value, {bool showError = true}) {
  var res = ResponseModel.instance;
  res.statusCode = value['code'] ?? 0;
  if (value['code'] == 200) {
    res.isSuccess = true;
    res.data = value['data'] ?? {};
  } else if (value['message'] != null && value['message'].isNotEmpty) {
    res.message = value['message'];
  } else if (value['error'] != null && value['error'].isNotEmpty) {
    res.message = value['error'];
  } else {
    res.message = 'Something went wrong!';
  }
  if (showError && res.isSuccess == false) {
    alertDialog(desc: res.message);
  }
  return res;
}

class ResponseModel {
  bool isSuccess;
  String message;
  int statusCode;
  dynamic data;
  static ResponseModel get instance =>
      ResponseModel(isSuccess: false, message: '', statusCode: 0, data: {});
  ResponseModel({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    required this.data,
  });
}
