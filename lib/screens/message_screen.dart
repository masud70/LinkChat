import 'package:flutter/material.dart';
import 'package:link_chat/widgets/message_item.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/messages';
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final List<Widget> _messages = const [
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: true,
    ),
    MessageItem(
      self: false,
    ),
  ];
  String userInput = '';

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Messages',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).viewInsets.bottom -
                  75),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext ctx, int idx) {
                  return _messages[idx];
                },
              ),
            ),
            Container(
              height: 75,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(31, 238, 254, 255),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          userInput = value;
                        });
                      },
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(),
                        labelText: 'Write message...',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        floatingLabelStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        enabledBorder: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 10.0,
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.telegram_outlined,
                    size: 55,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
