// import 'package:sembast/sembast.dart';
// import 'package:sembast/sembast_io.dart'; //used store chat data
// import 'package:path_provider/path_provider.dart';
// import 'messages.dart';
// import 'package:logger/logger.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class ChatRepo {
//   late final Database db;
//   // bool _initialized = false;
//   Logger logger = Logger();

//   ChatRepo._();

//   static final ChatRepo _instance = ChatRepo._();
//   static ChatRepo get instance => _instance;

//   Future<void> initializeDatabase() async {
//     // logger.d('initalizing database');
//     final appDocumentDir = await getApplicationDocumentsDirectory();
//     final dbPath = '${appDocumentDir.path}/chat_database.db';
//     db = await databaseFactoryIo.openDatabase(dbPath);
//     await deleteStore();
//     await initStore();
//   }

//   Future<void> deleteStore() async {
//     final storeFinder = Finder(filter: Filter.byKey('chat'));
//     final store = intMapStoreFactory.store('chat');
//     final record = await store.findFirst(db, finder: storeFinder);
//     if (record != null) {
//       await store.delete(db);
//     }
//   }

//   Future<void> initStore() async {
//     final storeFinder = Finder(filter: Filter.byKey('chat'));
//     final store = intMapStoreFactory.store('chat');
//     final record = await store.findFirst(db, finder: storeFinder);
//     if (record == null) {
//       await store.add(db, {});
//     }
//   }

//   Future<void> storeMessage(Message message) async {
//     try {
//       print('Storing message: $message'); // Log the message being stored
//       StoreRef<int, Map<String, dynamic>> store =
//           intMapStoreFactory.store('chat');
//       await store.add(db, message.toJson());
//       // print('Message stored successfully'); // Log successful message storage
//     } catch (e) {
//       // print('Error storing message: $e'); // Log error storing the message
//       logger.e('Error storing message: $e'); // Log error using loggerthe
//     }
//   }

//   Future<List<Message>> getAllMessages() async {
//     //createa a store reference that we use to get the message log
//     final store = intMapStoreFactory.store('chat');

//     final finder = Finder(sortOrders: [SortOrder('timestamp')]);
//     final snapshot = await store.find(db, finder: finder);
//     final messages =
//         snapshot.map((record) => Message.fromJson(record.value)).toList();
//     return messages;
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'messages.dart';

class ChatRepo {
  late final String _filePath;
  late final Future<void> _initialization;

  ChatRepo() {
    _initialization = _initializeFilePath();
  }

  Future<void> _initializeFilePath() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      _filePath = '${appDocumentDir.path}/chat_logs.json';
    } catch (e) {
      print('Error initializing file path: $e');
    }
  }

  Future<void> deleteChatLogs() async {
    await _initialization;
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting chat logs: $e');
    }
  }

  Future<void> storeMessage(Message message) async {
    await _initialization;
    try {
      final file = File(_filePath);
      final List<Message> chatLogs = await getAllMessages();
      chatLogs.add(message);
      await file.writeAsString(jsonEncode(chatLogs.map((msg) => msg.toJson()).toList()));
    } catch (e) {
      print('Error storing message: $e');
    }
  }

  Future<List<Message>> getAllMessages() async {
    await _initialization;
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonData);
        return jsonList.map((json) => Message.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting all messages: $e');
    }
    return [];
  }
}
