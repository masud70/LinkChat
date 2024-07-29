class Message {
  int? id;
  int? toId;
  int? fromId;
  String? content;
  DateTime? dateTime;

  Message({
    this.toId,
    this.fromId,
    this.content,
    this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'toId': toId,
      'fromId': fromId,
      'content': content,
      'timestamp': dateTime?.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      toId: map['toId'],
      fromId: map['fromId'],
      content: map['content'],
      dateTime: DateTime.parse(map['timestamp']),
    );
  }
}
