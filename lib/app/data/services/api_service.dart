import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:get/get.dart' as getx;

class ApiServices {
  static final Client client = Client();

  Future<String> get(String url) async {
    Uri uri = Uri.parse(url);
    var response = await client.get(uri, headers: {
      "Access-Control-Allow-Origin": "*",
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GetStorage().read('token')}',
      'Content-Type': 'application/json',
    });
    checkAndThrowError(response);
    return response.body;
  }

  Future<String> post(String url, Map<String, dynamic> body,
      {String? contentType}) async {
    Uri uri = Uri.parse(url);
    var response = await client.post(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': contentType ?? 'application/json',
        'authorization': 'Bearer ${GetStorage().read('token')}',
      },
      body: contentType == null ? jsonEncode(body) : body,
    );
    checkAndThrowError(response);
    return response.body;
  }

  Future<String> put(String url, Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url);
    var response = await client.put(uri, body: jsonEncode(body));
    checkAndThrowError(response);
    return response.body;
  }

  Future<String> delete(String url) async {
    Uri uri = Uri.parse(url);
    var response = await client.delete(uri);
    checkAndThrowError(response);
    return response.body;
  }

  Future<String> uploadFile(String url, String username, double longitude,
      double latitude, File file) async {
    Uri uri = Uri.parse(
        '$url?username=$username&longitude=$longitude&latitude=$latitude');
    var request = MultipartRequest('POST', uri)
      ..files.add(await MultipartFile.fromPath('file', file.path))
      ..headers.addAll({
        "Access-Control-Allow-Origin": "*",
        'Accept': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('token')}',
      });
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    checkAndThrowError(Response(responseBody, response.statusCode));
    return responseBody;
  }

  static void checkAndThrowError(Response response) {
    if (response.statusCode != HttpStatus.ok) {
      String errorMsg;
      switch (response.statusCode) {
        case HttpStatus.unauthorized:
          errorMsg = 'Invalid credentials';
          break;
        case HttpStatus.notFound:
          errorMsg = 'Server not found';
          break;
        default:
          errorMsg = 'Something went wrong';
      }
      getx.Get.snackbar('Error', errorMsg);
      throw Exception(response.body);
    }
  }
}
