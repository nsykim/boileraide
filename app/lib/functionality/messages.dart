// messages.dart

class Message {
  final String id; // each individual message id
  final String content; // content of each message
  final DateTime timestamp; // when message was sent
  final bool isUser; // user or model talking

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String), //need to do it like this because no direct conversion between json and DateTime
      isUser: json['isUser'] as bool,
    );
  }
}
