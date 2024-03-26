class Message {
  // final int chatID; // ID for each chat

  final String content; // content of each message
  final DateTime timestamp; // when message was sent
  final bool isUser; // user or model talking

  Message({
    // required this.chatID,
    required this.content,
    required this.timestamp,
    required this.isUser,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'chatID': chatID,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    // Convert JSON to message with error handling
    // try {
      // Parse the timestamp
      DateTime timestamp = DateTime.parse(json['timestamp'] as String);

      // Ensure that the content is not null
      String? contentJson = json['content'];
      String content = contentJson ?? '';

      // Ensure that isUser is a boolean value
      bool isUser = json['isUser'] as bool? ?? false;

      return Message(
        content: content,
        timestamp: timestamp,
        isUser: isUser,
      );
  }
    // } catch (e) {
      // If an error occurs during parsing, return a default message
    //   return Message(
    //     content: 'Invalid Message',
    //     timestamp: DateTime.now(),
    //     isUser: false,
    //   );
    // }
  // }
}
//   factory Message.fromJson(Map<String, dynamic> json) {
//     //convert JSON to message
//     return Message(
//       // chatID: json['chatID'] as int,
//       content: json['content'] as String,
//       timestamp: DateTime.parse(json['timestamp'] as String),
//       isUser: json['isUser'] as bool,
//     );
//   }
// }
