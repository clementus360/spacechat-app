class Chat {
  final int id;
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
  final int id;
  final String payload;
  final String sender;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.payload,
    required this.sender,
    required this.timestamp,
  });
}
