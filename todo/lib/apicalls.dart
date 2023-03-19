import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ApiCalls with ChangeNotifier {
  var baseUrl = 'http://127.0.0.1:8000/';

  List todoList = [];

  List get todoListData {
    return todoList;
  }

  Future<int> getTodo() async {
    var url = Uri.parse('$baseUrl/todo/mytodo-list/');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        // body: json.encode(batchCode),
      );

      if (kDebugMode) {
        print(response.statusCode.toString());
        print(response.body.toString());
      }

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        todoList = responseData;
        notifyListeners();
        return response.statusCode;
      }
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> postTodo(var data) async {
    var url = Uri.parse('$baseUrl/todo/mytodo-list/');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );

      if (kDebugMode) {
        print(response.statusCode.toString());
        print(response.body.toString());
      }

      // if (response.statusCode == 200) {
      //   var responseData = json.decode(response.body);

      //   todoList = responseData;
      //   notifyListeners();
      //   return response.statusCode;
      // }
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editTodo(var data, var id) async {
    var url = Uri.parse('$baseUrl/todo/mytodo-details/$id/');
    try {
      var response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );

      if (kDebugMode) {
        print(response.statusCode.toString());
        print(response.body.toString());
      }

      // if (response.statusCode == 200) {
      //   var responseData = json.decode(response.body);

      //   todoList = responseData;
      //   notifyListeners();
      //   return response.statusCode;
      // }
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
