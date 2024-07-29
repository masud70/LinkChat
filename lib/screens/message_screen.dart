import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:link/controllers/auth_controller.dart';
import 'package:link/models/user.dart';
import 'package:link/util/utils.dart';
import 'package:link/widgets/message_item.dart';
import 'package:link/controllers/message_controller.dart';
import 'package:link/models/message.dart' as m;

class MessageScreen extends StatefulWidget {
  static const routeName = '/messages';
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final AuthController _auth = AuthController();
  Device? device;
  NearbyService? nearbyService;
  MessageController? mc;
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      device = args?['device'] as Device?;
      nearbyService = args?['nearbyService'] as NearbyService?;
      if (device != null && nearbyService != null) {
        Util.i(device!.deviceName);
        mc = MessageController(nearbyService: nearbyService!);
      } else {
        Util.i("Device or NearbyService is null.");
      }
      _initialize();
    });
  }

  Future<void> _initialize() async {
    try {
      user = await _auth.getUserByUsername('nishat');
    } catch (e) {
      Util.i('Error fetching user: $e');
    }
    setState(() {});
  }

  final List<Widget> _messages = const [
    MessageItem(self: true),
    MessageItem(self: false),
    MessageItem(self: true),
    MessageItem(self: false),
    MessageItem(self: true),
  ];

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Messages',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: Util.loader(
            size: 70,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    m.Message newMessage = m.Message(
      toId: user!.id,
      fromId: 1,
      content: '',
    );

    final appBar = AppBar(
      title: Text(
        user!.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
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
                        newMessage.content = value;
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
                  IconButton(
                    onPressed: () {
                      if (newMessage.content!.isNotEmpty) {
                        mc!.sendMessage(message: newMessage);
                      }
                    },
                    icon: const Icon(
                      Icons.telegram_outlined,
                      size: 55,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
