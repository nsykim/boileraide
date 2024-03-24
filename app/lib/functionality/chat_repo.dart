import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart'; //used store chat data
import 'package:path_provider/path_provider.dart';
import 'messages.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepo {
  late final Database db;
  bool _initialized = false;
  Logger logger = Logger();

  ChatRepo._() {
    if (!_initialized) {
      initializeDatabase();
      _initialized = true;
    }
  }

  static final ChatRepo _instance = ChatRepo._();
  static ChatRepo get instance => _instance;

  Future<void> initializeDatabase() async {
    // logger.d('initalizing database');
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = '${appDocumentDir.path}/chat_database.db';
    db = await databaseFactoryIo.openDatabase(dbPath);
    // logger.d('database initialized. Creating SharedPreferences instance');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ID', 0); //set ID to 1 at beginning
    // logger.d('SharedPreferences instance created. Creating store ID 0');
    //initialize to 1... save 0 to store chatlog names
    final mainStore = intMapStoreFactory.store('chat_0');
    await mainStore.add(db, {}); //where we will save chat names
    // logger.d('Initalized Database and chat name store');
  }

  Future<int> getCurrentID() async {
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('ID');
    if (id == null) {
      throw Exception('no ID found!');
    } else {
      return id;
    }
  }

  Future<void> deleteDatabaseFile() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = '${appDocumentDir.path}/chat_database.db';
    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
  }

  Future<bool> noChatLogs() async {
    // Check if the database file exists
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = '${appDocumentDir.path}/chat_database.db';
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      //first time opening app. no db file exists
      logger.d('database doesnt exist');
      return true;
    }

    // Loop from 1 to currentID to check if any stores have content
    final currentID = await getCurrentID();
    for (int i = 1; i <= currentID; i++) {
      final store = intMapStoreFactory.store('chat_$i');
      final snapshot = await store.findFirst(db);
      if (snapshot != null) {
        // If store contains content, close the database and return false (chat logs exist)
        await db.close();
        return false;
      }
    }
    return true;
  }

  Future<int> updateChatID() async {
    //update shared preferences to save this after app is closed
    final prefs = await SharedPreferences.getInstance();

    final currentID = prefs.getInt('ID');
    final newID = currentID! + 1;
    await prefs.setInt('ID', newID);
    return newID;
  }

  Future<void> initStore(int chatID) async {
    final storeFinder = Finder(filter: Filter.byKey(chatID));
    final store = intMapStoreFactory.store('chat_$chatID');
    final record = await store.findFirst(db, finder: storeFinder);
    if (record != null) {
      throw Exception('Chat ID is already in use!');
    } else {
      final newStore = intMapStoreFactory.store('chat_$chatID');
      await newStore.add(db, {});

      final mainStore = intMapStoreFactory.store('chat_0');
      await mainStore
          .add(db, {'chatID': chatID, 'chatName': 'Unnamed Chat $chatID'});
    }
  }

  Future<void> storeMessage(Message message) async {
    try {
      print('Storing message: $message'); // Log the message being stored
      StoreRef<int, Map<String, dynamic>> store =
          intMapStoreFactory.store('chat_${message.chatID}');
      await store.add(db, message.toJson());
      // print('Message stored successfully'); // Log successful message storage
    } catch (e) {
      // print('Error storing message: $e'); // Log error storing the message
      logger.e('Error storing message: $e'); // Log error using loggerthe
    }
  }

  Future<DateTime?> getLastMessageTime(int chatID) async {
    final store = intMapStoreFactory.store('chat_$chatID');
    final finder = Finder(sortOrders: [SortOrder('timestamp', false)]);
    final snapshot = await store.find(db, finder: finder);
    if (snapshot.isEmpty) {
      return null; //means deleted. should skip over
    } else {
      final timestamp = snapshot.first['timestamp'] as DateTime;
      return timestamp;
    }
  }

  Future<String?> getChatName(int chatID) async {
    final mainStore = intMapStoreFactory.store('chat_0'); //open name store
    final finder = Finder(
        filter: Filter.equals('chatID', chatID)); //find store with same chatID
    final recordSnapshots = await mainStore.find(db, finder: finder);
    if (recordSnapshots.isEmpty) {
      return null; //means it was deleted... do NOT allow for access
    } else {
      final record = recordSnapshots.first;
      return record['chatName'] as String?;
    }
  }

  Future<List<Message>> getAllMessages(int chatID) async {
    //createa a store reference that we use to get the message log
    final store = intMapStoreFactory.store('chat_$chatID');

    final finder = Finder(sortOrders: [SortOrder('timestamp')]);
    final snapshot = await store.find(db, finder: finder);
    final messages =
        snapshot.map((record) => Message.fromJson(record.value)).toList();
    return messages;
  }
}
