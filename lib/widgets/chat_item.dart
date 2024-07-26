import 'package:flutter/material.dart';
import 'package:link_chat/screens/message_screen.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({super.key});

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          MessageScreen.routeName,
          arguments: {
            'id': 1,
          },
        );
      },
      splashColor: Theme.of(context).primaryColor,
      child: const ListTile(
        leading: Icon(
          Icons.account_circle_outlined,
          size: 35,
        ),
        title: Text('Nishat Ahmed'),
        subtitle: Text('This is the subject of the chat'),
        trailing: Text('1h ago'),
      ),
    );
  }
}
