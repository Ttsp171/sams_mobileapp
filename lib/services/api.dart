import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../widgets/toast.dart';

class HttpServices {
  String baseUrl = Env().baseUrl;

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
}
