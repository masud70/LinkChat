import 'package:flutter/material.dart';
import 'package:link/widgets/chat_item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
              ChatItem(),
            ],
          ),
        ),
      ),
    );
  }
}
