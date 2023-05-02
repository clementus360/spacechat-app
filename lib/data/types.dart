class Chat {
  final String id;
  final String name;
  final String receiver;
  final String? imageUrl;
  final List<Message> messages;

  Chat({
    required this.id,
    required this.name,
    required this.receiver,
    this.imageUrl,
    this.messages = const [],
  });
}

class Message {
  final String id;
  final String payload;
  final String chatId;
  final String sender;
  final String receiver;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.payload,
    required this.chatId,
    required this.sender,
    required this.receiver,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chatId'],
      payload: json['payload'],
      sender: json['sender'],
      receiver: json['receiver'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
