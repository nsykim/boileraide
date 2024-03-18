import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart'; //used store chat data
// import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'messages.dart';

class ChatRepo {
  //late means it will be initalized before it's used.
  late final Database db;
  //list of chatIDs so we know if this is a new chat and need to open a new store
  final Set<int> chatIDs = {};
  bool _initalized = false;
  ChatRepo._(); //private constructor
  static final ChatRepo _instance = ChatRepo._();

  factory ChatRepo() => _instance; //just makes sure there is only ever one


  Future<void> initializeDatabase() async {
    //opens or creates if it doesn't already exist
    //gets dynamic path to app storage... won't be deleted when app is deleted
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = '${appDocumentDir.path}/chat_database.db';
    db = await databaseFactoryIo.openDatabase(dbPath);
    _initalized = true;
  }

  Future<void> initalizeIfNeeded() async {
    if (!_initalized) {
      await initializeDatabase();
      _initalized = true;
    }
  }

  Future<bool> createNewStore(Message message) async {
    if (!chatIDs.contains(message.chatID)) {
      chatIDs.add(message.chatID);
      StoreRef<int, Map<String, dynamic>> store =
          intMapStoreFactory.store('chat_$message.chatID');
      await store.add(
          db,
          message
              .toJson()); //store Json of message in store which is in database db
      return true; //new store is created, first message stored
    } else {
      return false; //store already existed, need to store message
    }
  }

  Future<void> storeMessage(Message message) async {
    if (!(await createNewStore(message))) {
      //if false, need to store the message still
      StoreRef<int, Map<String, dynamic>> store =
          intMapStoreFactory.store('chat_${message.chatID}');
      await store.add(db, message.toJson());
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

  Future<int> getMaxID() async {
    //go to this store
    if (db == null) {
      throw Exception("Database has not been initalized yet");
    }
    final store = intMapStoreFactory.store('chat_store');
    final finder = Finder(sortOrders: [SortOrder('chatID', false)]);
    final snapshot = await store.findFirst(db, finder: finder);
    if (snapshot != null) {
      final chatID = snapshot.value['chatID'] as int?;
      //? operator used to access something that might be null. returns null if is null or returns object if not
      if (chatID != null) {
        return chatID;
      }
    }
    return 0;
  }
}
