import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';
import '../seldom_app.dart';
import '../widgets/toast.dart';

class HttpServices {
  String baseUrl = Env().baseUrl;

  Future getWithToken(endpoint, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: <String, String>{
        'Accept-Language': 'EN-US',
        'Authorization': "Bearer ${prefs.getString(prefKey.token)}"
      });
      var data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      return {
        "status": 700,
        "data": {"message": "Internal Server Error"}
      };
    }
  }

  Future postWithToken(endpoint, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http
          .post(Uri.parse('$baseUrl$endpoint'), headers: <String, String>{
        'Accept-Language': 'EN-US',
        'Authorization': "Bearer ${prefs.getString(prefKey.token)}"
      });
      var data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      return {
        "status": 700,
        "data": {"message": "Internal Server Error"}
      };
    }
  }

  Future get(String url, BuildContext? context) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl$url'), headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      var data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      showToast("Internal Server Error");
    }
  }

  Future post(endpoint, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http
          .post(Uri.parse('$baseUrl$endpoint'), headers: <String, String>{
        'Accept-Language': 'EN-US',
        'Authorization': 'Bearer ${prefs.getString(prefKey.token)}'
      });
      var data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      return {
        "status": 700,
        "data": {"message": "Internal Server Error"}
      };
    }
  }

  Future authBoardPost(endpoint, body) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl$endpoint'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body));
      var data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      return {
        "status": 700,
        "data": {"message": "Internal Server Error"}
      };
    }
  }

  Future postWithAttachments(
      endpoint, Map<String, String> body, filePaths) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    request.fields.addAll(body);

    if (filePaths.isNotEmpty) {
      request.files
          .add(await http.MultipartFile.fromPath('attachment', filePaths));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        return {
          "status": response.statusCode,
          "data": await response.stream.bytesToString()
        };
      } else {
        return {"status": response.statusCode, "data": response.reasonPhrase};
      }
    } catch (e) {
      showToast('Error uploading file: $e');
    }
  }

  Future postWIthTokenAndBody(endpoint, body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    request.fields.addAll(body);
    request.headers.addAll({
      'Accept-Language': 'EN-US',
      'Authorization': 'Bearer ${prefs.getString(prefKey.token)}'
    });

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var dataNew = await response.stream.bytesToString();
        return {
          "status": response.statusCode,
          "data": json.decode(dataNew)
        };
      } else {
        return {"status": response.statusCode, "data": response.reasonPhrase};
      }
    } catch (e) {
      showToast('Error : $e');
    }
  }
}
