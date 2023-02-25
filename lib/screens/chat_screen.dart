import 'dart:developer';

import 'package:chatgpt_app_using_flutter/constants/constants.dart';
import 'package:chatgpt_app_using_flutter/providers/chats_provider.dart';
import 'package:chatgpt_app_using_flutter/providers/models_provider.dart';
import 'package:chatgpt_app_using_flutter/services/assets_manager.dart';
import 'package:chatgpt_app_using_flutter/services/services.dart';
import 'package:chatgpt_app_using_flutter/widgets/chat_widget.dart';
import 'package:chatgpt_app_using_flutter/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController scrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatsProvider = Provider.of<ChatsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Image.asset(AssetsManager.openaiLogo),
        title: const Text("hushush's ChatGPT"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: chatsProvider.getChatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatsProvider.getChatList[index].msg,
                      chatIndex: chatsProvider.getChatList[index].chatIndex,
                    );
                  }),
            ),
            // 다수의 자식들을 리턴할 때 사용하는 문법
            if (chatsProvider.isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 20,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) {
                          // TD-DO 메세지 보내기
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "무엇을 도와드릴까요?",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageGPT(
                          modelsProvider: modelsProvider,
                          chatsProvider: chatsProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    scrollController.animateTo(MediaQuery.of(context).size.height,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }

  Future<void> sendMessageGPT(
      {required ModelsProvider modelsProvider,
      required ChatsProvider chatsProvider}) async {
    if (chatsProvider.isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "메세지를 전송 중입니다."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(label: "메세지를 입력해 주세요."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      var msg = textEditingController.text;
      chatsProvider.setIsTyping(true);

      chatsProvider.addUserMessage(msg: msg);

      textEditingController.clear();
      focusNode.unfocus();

      scrollListToEnd();
      chatsProvider
          .sendMessageAndGetAnswer(
        msg: msg,
        chosenModelId: modelsProvider.getCurrentModel,
      )
          .then((value) {
        chatsProvider.setIsTyping(false);
        scrollListToEnd();
      });
    } catch (error) {
      log("error : $error");
    }
  }
}
