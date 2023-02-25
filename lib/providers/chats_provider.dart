import 'package:chatgpt_app_using_flutter/models/chat_model.dart';
import 'package:chatgpt_app_using_flutter/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class ChatsProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(
      ChatModel(msg: msg, chatIndex: 0),
    );
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswer(
      {required String msg, required String chosenModelId}) async {
    chatList.addAll(
      await ApiService.sendMessage(
        message: msg,
        modelid: chosenModelId,
      ),
    );
    notifyListeners();
  }
}
