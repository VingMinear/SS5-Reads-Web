import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;

class ErrorModel {
  final int? statusCode;
  final dynamic bodyString;
  const ErrorModel({this.statusCode, this.bodyString});
}

enum METHODE {
  get,
  post,
  delete,
  update,
}

String baseurl = "http://ss5reads.jonward.com/";
// String baseurl = "http://10.0.2.2:3000/";

class ApiBaseHelper extends GetConnect {
  Future<dynamic> onNetworkRequesting({
    required String url,
    Map<String, String>? header,
    Map<String, dynamic>? body,
    required METHODE? methode,
    bool isUploadImage = false,
  }) async {
    var addOn = '';
    final fullUrl = "${baseurl}api/$addOn$url";
    log(fullUrl);
    log('body ${jsonEncode(body)}');
    try {
      switch (methode) {
        case METHODE.get:
          final response = await get(
            fullUrl,
            headers: header,
          );
          return _returnResponse(response);
        case METHODE.post:
          final response =
              await post(fullUrl, headers: header, json.encode(body));
          return _returnResponse(response);

        case METHODE.update:
          final response =
              await put(fullUrl, headers: header, json.encode(body));
          return _returnResponse(response);

        default:
          // TODO: Handle this case.
          break;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> postAsyncImage({
    required Map<String, String>? header,
    required String url,
    required String dataImage,
  }) async {
    dynamic dataResponse;

    //Request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        dataImage,
      ),
    );
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      dataResponse = await json.decode(data);
    }

    return dataResponse;
  }

  dynamic _returnResponse(Response response) {
    log("status code ${response.statusCode}");
    return json.decode(response.bodyString ?? '');
  }
}
