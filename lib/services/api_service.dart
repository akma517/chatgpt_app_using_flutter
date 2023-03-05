import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_app_using_flutter/constants/secure_param.dart';
import 'package:chatgpt_app_using_flutter/models/chat_model.dart';
import 'package:chatgpt_app_using_flutter/models/models_model.dart';
import 'package:http/http.dart' as http;

import 'package:chatgpt_app_using_flutter/constants/constants.dart';

class ApiService {
  // 이용 가능한 AI Model들을 가져옴
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

  // chatGpt랑 일반 모델들의 api 레이아웃이 다름
  // model에 따른 상이한 레이아웃 통신
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response;
      if ([
        'gpt-3.5-turbo',
        'gpt-3.5-turbo-0301',
      ].contains(modelId)) {
        response = await http.post(Uri.parse("$CHAT_URI/completions"),
            headers: {
              "Authorization": "Bearer $API_KEY",
              "Content-Type": "application/json",
            },
            body: utf8.encode(jsonEncode({
              "model": modelId,
              "messages": [
                {
                  "role": "user",
                  "content": message,
                }
              ],
            })));
      } else {
        response = await http.post(Uri.parse("$BASE_URI/completions"),
            headers: {
              "Authorization": "Bearer $API_KEY",
              "Content-Type": "application/json",
            },
            body: utf8.encode(jsonEncode({
              "model": modelId,
              "prompt": message,
              "max_tokens": 500,
            })));
      }

      Map jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (jsonResponse["error"] != null) {
        log("jsonResponse['error'] : ${jsonResponse["error"]["message"]}");
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List<ChatModel> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        if ([
          'gpt-3.5-turbo',
          'gpt-3.5-turbo-0301',
        ].contains(modelId)) {
          chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
              msg: jsonResponse["choices"][index]["message"]["content"],
              chatIndex: 1,
            ),
          );
        } else {
          chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
              msg: jsonResponse["choices"][index]["text"],
              chatIndex: 1,
            ),
          );
        }
      }
      return chatList;
    } catch (error) {
      List<ChatModel> chatList = List.generate(
        1,
        (index) => ChatModel(
          msg:
              "죄송합니다.\n개발자의 api free trial 분이 모두 소진되어 이용이 불가능합니다.\n좋은 하루 되세요~!",
          chatIndex: 1,
        ),
      );
      return chatList;
    }
  }
}
