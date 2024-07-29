import 'package:link/db/db.dart';
import 'package:link/models/user.dart';
import 'package:link/util/utils.dart';
import 'package:link/models/message.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart'
    as n;

class MessageController {
  final DB _db = DB();
  final n.NearbyService? nearbyService;
  MessageController({this.nearbyService});

  Future<bool> sendMessage({
    required Message message,
  }) async {
    try {
      await _db.insertMessage(message);
      final result = await nearbyService!
          .sendMessage(message.toId.toString(), message.content!);

      Util.i(result);
      return true;
    } catch (e) {
      Util.i(e);
      return false;
    }
  }

  Future<void> handleReceivedMessage(Map<String, dynamic> data) async {
    try {
      String content = data['content'];
      int toId = int.parse(data['toId']);
      int fromId = int.parse(data['fromId']);

      Message message = Message(
        content: content,
        toId: toId,
        fromId: fromId,
      );

      User? currentUser = await _db.getUserById(message.toId!);
      if (currentUser != null && currentUser.id == toId) {
        Util.i('Received a new message from $fromId');
        await _db.insertMessage(message);
      } else {
        await nearbyService!.sendMessage(toId.toString(), content);
      }
    } catch (e) {
      Util.i('Error handling received message: $e');
    }
  }
}
