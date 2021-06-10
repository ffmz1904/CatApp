import 'dart:convert';

import 'package:http/http.dart' as http;

enum RequestTypes { GET, POST, PUT, PATCH, DELETE }

class ApiService {
  String endpoint;
  Map<String, dynamic> body = {};
  RequestTypes method = RequestTypes.GET;

  ApiService.get({required this.endpoint});

  ApiService.post({required this.endpoint, required this.body})
      : this.method = RequestTypes.POST;

  ApiService.put({required this.endpoint, required this.body})
      : this.method = RequestTypes.PUT;

  ApiService.patch({required this.endpoint, required this.body})
      : this.method = RequestTypes.PATCH;

  ApiService.delete({required this.endpoint})
      : this.method = RequestTypes.DELETE;

  Future request() async {
    var uri = Uri.parse(this.endpoint);
    var headers = {'Content-Type': 'application/json'};
    var response;

    switch (method) {
      case RequestTypes.GET:
        response = await http.get(uri, headers: headers);
        break;
      case RequestTypes.POST:
        response = await http.post(uri, body: this.body, headers: headers);
        break;
      case RequestTypes.PUT:
        response = await http.put(uri, body: this.body, headers: headers);
        break;
      case RequestTypes.PATCH:
        response = await http.patch(uri, body: this.body, headers: headers);
        break;
      case RequestTypes.DELETE:
        response = await http.delete(uri, headers: headers);
        break;
    }
    return json.decode(response.body);
  }
}
