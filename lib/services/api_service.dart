import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_app_using_flutter/constants/secure_param.dart';
import 'package:chatgpt_app_using_flutter/models/chat_model.dart';
import 'package:chatgpt_app_using_flutter/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URI/models"),
        headers: {"Authorization": "Bearer $API_KEY"},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse["error"] != null) {
        log("jsonResponse['error'] : ${jsonResponse["error"]["message"]}");
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List models = [];

      for (var value in jsonResponse["data"]) {
        models.add(value);
        log("models ${value['id']}");
      }
      return ModelsModel.modelsFromSnapshot(models);
    } catch (error) {
      log("models $error");
      rethrow;
    }
  }

  // send msg
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelid}) async {
    try {
      var response = await http.post(Uri.parse("$BASE_URI/completions"),
          headers: {
            "Authorization": "Bearer $API_KEY",
            "Content-Type": "application/json",
          },
          body: utf8.encode(jsonEncode({
            "model": modelid,
            "prompt": message,
            "max_tokens": 1000,
          })));

      Map jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (jsonResponse["error"] != null) {
        log("jsonResponse['error'] : ${jsonResponse["error"]["message"]}");
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List<ChatModel> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("models $error");
      rethrow;
    }
  }
}
