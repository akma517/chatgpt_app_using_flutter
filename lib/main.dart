import 'package:chatgpt_app_using_flutter/constants/constants.dart';
import 'package:chatgpt_app_using_flutter/providers/chats_provider.dart';
import 'package:chatgpt_app_using_flutter/providers/models_provider.dart';
import 'package:chatgpt_app_using_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatsProvider(),
        ),
      ],
      child: MaterialApp(
        title: "hushush's chatGPT",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
