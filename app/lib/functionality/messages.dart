// import 'package:drift/drift.dart';

// @DriftTable(tableName: 'messages')
// class Message {
//   @DriftPrimaryKey()
//   final String id; // each individual message id
//   final String content; // content of each message
//   final DateTime timestamp; // when message was sent
//   final bool isUser; // user or model talking

//   Message({
//     required this.id,
//     required this.content,
//     required this.timestamp,
//     required this.isUser,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'content': content,
//       'timestamp': timestamp,
//       'isUser': isUser,
//     };
//   }

//   factory Message.fromJson(Map<String, dynamic> json) {
//     //convert JSON to message
//     return Message(
//       id: json['id'] as String,
//       content: json['content'] as String,
//       timestamp: DateTime.parse(json['timestamp']
//           as String), //need to do it like this because no direct conversion between json and DateTime
//       isUser: json['isUser'] as bool,
//     );
//   }
// }

import 'package:drift/drift.dart';

@DriftTable(tableName: 'messages')
class Message {
  @DriftPrimaryKey()
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

  factory Message.fromJson(Map<String, dynamic> json) { //convert JSON to message 
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: json['isUser'] as bool,
    );
  }
}