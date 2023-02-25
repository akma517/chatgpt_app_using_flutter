import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_app_using_flutter/constants/constants.dart';
import 'package:chatgpt_app_using_flutter/providers/chats_provider.dart';
import 'package:chatgpt_app_using_flutter/services/assets_manager.dart';
import 'package:chatgpt_app_using_flutter/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.msg,
    required this.chatIndex,
  }) : super(key: key);
  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    final chatsProvider = Provider.of<ChatsProvider>(context);
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: chatIndex == 0
                        ? TextWidget(
                            label: msg,
                          )
                        : TextWidget(
                            label: msg,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          )

                    // DefaultTextStyle(
                    //     style: const TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 16,
                    //     ),
                    //     child: AnimatedTextKit(
                    //       isRepeatingAnimation: false,
                    //       repeatForever: false,
                    //       displayFullTextOnTap: true,
                    //       totalRepeatCount: 0,
                    //       animatedTexts: [
                    //         TyperAnimatedText(
                    //           msg.trim(),
                    //         ),
                    //       ],
                    //     ),
                    //   )
                    ),
                //SizedBox.shrink(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
