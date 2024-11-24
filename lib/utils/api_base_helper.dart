import 'dart:convert';
import 'dart:developer';
import 'package:homework3/utils/Log.dart';
import 'package:homework3/utils/ReponseApiHandler.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get_connect.dart';
import 'package:homework3/model/imagemodel.dart';
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
    required ImageModel dataImage,
  }) async {
    dynamic dataResponse;
    try {
      //Request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'multipart/form-data'});
      if (dataImage.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo', // This should match the field name expected in your Express route
            dataImage.bytes!,
            filename: dataImage.image.value.split('/').last,
            contentType:
                MediaType('image', 'jpeg'), // Change based on the file type
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        print(data);
        dataResponse = await json.decode(data);
      } else {
        var data = await response.stream.bytesToString();
        print(data);
        dataResponse = await json.decode(data);
        checkResponse(dataResponse);
      }
    } catch (e) {
      Log.error(e);
    }

    return dataResponse;
  }

  dynamic _returnResponse(Response response) {
    log("status code ${response.statusCode}");
    return json.decode(response.bodyString ?? '');
  }
}
