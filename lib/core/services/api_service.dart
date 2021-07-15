import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

enum RequestTypes { GET, POST, PUT, PATCH, DELETE }

class ApiService {
  static final ApiService _apiService = ApiService._();

  factory ApiService() {
    return _apiService;
  }

  ApiService._();

  Future<dynamic> get({
    required String endpoint,
    Map<String, String> headers = const {}
  }) async {
    return request(method: RequestTypes.GET, endpoint: endpoint, extraHeaders: headers);
  }

  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String> headers = const {}
  }) async {
    return request(method: RequestTypes.POST, endpoint: endpoint, body: body, extraHeaders: headers);
  }

  Future<dynamic> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String> headers = const {}
  }) async {
    return request(method: RequestTypes.PUT, endpoint: endpoint, body: body, extraHeaders: headers);
  }

  Future<dynamic> patch({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String> headers = const {}
  }) async {
    return request(method: RequestTypes.PATCH, endpoint: endpoint, body: body, extraHeaders: headers);
  }

  Future<dynamic> delete({
    required String endpoint,
    Map<String, String> headers = const {}
  }) async {
    return request(method: RequestTypes.DELETE, endpoint: endpoint, extraHeaders: headers);
  }

  Future<dynamic> request({
    required RequestTypes method,
    required String endpoint,
    Map<String, dynamic> body = const {},
    Map<String, String> extraHeaders = const {},
  }) async {
    final uri = Uri.parse(endpoint);
    var headers = <String, String>{'Content-Type': 'application/json'};

    if (extraHeaders.isNotEmpty) {
      headers.addAll(extraHeaders);
    }

    Response response;

    try {
      switch (method) {
        case RequestTypes.GET:
          response = await http.get(uri, headers: headers);
          break;
        case RequestTypes.POST:
          response =
              await http.post(uri, body: json.encode(body), headers: headers);
          break;
        case RequestTypes.PUT:
          response =
              await http.put(uri, body: json.encode(body), headers: headers);
          break;
        case RequestTypes.PATCH:
          response =
              await http.patch(uri, body: json.encode(body), headers: headers);
          break;
        case RequestTypes.DELETE:
          response = await http.delete(uri, headers: headers);
          break;
      }
      return json.decode(response.body);
    } catch (e) {
      return throw Exception('No internet connection!');
    }
  }
}
