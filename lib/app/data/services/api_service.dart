import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:frontend_waste_management/app/data/models/review_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

class ApiServices {
  static final Client client = Client();

  Future<Response> get(String url) async {
    Uri uri = Uri.parse(url);
    var response = await client.get(uri, headers: {
      "Access-Control-Allow-Origin": "*",
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GetStorage().read('token')}',
      'Content-Type': 'application/json',
    });
    return response;
  }

  Future<Response> post(String url, Map<String, dynamic> body,
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
    return response;
  }

  Future<Response> put(String url, Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url);
    var response = await client.put(uri, body: jsonEncode(body));
    return response;
  }

  Future<Response> delete(String url) async {
    Uri uri = Uri.parse(url);
    var response = await client.delete(uri);
    return response;
  }

  Future<String> uploadFile(String url, String username, double longitude,
      double latitude, bool fromCamera, bool isPile, File file) async {
    Uri uri = Uri.parse(
        '$url?username=$username&longitude=$longitude&latitude=$latitude&from_camera=$fromCamera&use_garbage_pile_model=$isPile');
    var request = MultipartRequest('POST', uri)
      ..files.add(await MultipartFile.fromPath('file', file.path))
      ..headers.addAll({
        "Access-Control-Allow-Origin": "*",
        'Accept': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('token')}',
      });
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    return responseBody;
  }

  Future<String> postSampahV2(String url, ReviewModel data) async {
    Uri uri = Uri.parse(
        '$url-v2?lang=${Uri.encodeComponent(data.lang!)}&longitude=${data.longitude}&latitude=${data.latitude}&address=${Uri.encodeComponent(data.address!)}&capture_date=${data.captureDate}&use_garbage_pile_model=${data.useGarbagePileModel}');
    var request = MultipartRequest('POST', uri)
      ..files.add(await MultipartFile.fromPath('file', data.imagePath!))
      ..headers.addAll({
        "Access-Control-Allow-Origin": "*",
        'Accept': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('token')}',
      });
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    return responseBody;
  }
}
