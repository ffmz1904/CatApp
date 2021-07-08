import 'dart:convert';

import 'package:http/http.dart' as http;

enum RequestTypes { GET, POST, PUT, PATCH, DELETE }

class ApiService {
  String endpoint;
  Map<String, dynamic> body = {};
  Map<String, String>? headers;
  RequestTypes method = RequestTypes.GET;

  ApiService.get({required this.endpoint, this.headers});

  ApiService.post({required this.endpoint, required this.body, this.headers})
      : method = RequestTypes.POST;

  ApiService.put({required this.endpoint, required this.body, this.headers})
      : method = RequestTypes.PUT;

  ApiService.patch({required this.endpoint, required this.body, this.headers})
      : method = RequestTypes.PATCH;

  ApiService.delete({required this.endpoint, this.headers})
      : method = RequestTypes.DELETE;

  Future request() async {
    var uri = Uri.parse(endpoint);
    final headers = {'Content-Type': 'application/json'};

    if (this.headers != null) {
      headers.addAll(this.headers!);
    }

    var response;

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
      return throw Exception('No interner connection!');
    }
  }
}
