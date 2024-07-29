import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final bool self;
  const MessageItem({this.self = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: self ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 3.0,
          horizontal: 4.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 3.0,
        ),
        decoration: BoxDecoration(
          color: self
              ? const Color.fromRGBO(255, 240, 240, 1)
              : const Color.fromRGBO(240, 255, 240, 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                        'Here goes the message data. You can select the message data to display.'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                    self ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.timer_outlined,
                    size: 12,
                    color: Colors.black38,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '12h ago',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
