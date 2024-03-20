import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart'; //used store chat data
import 'package:path_provider/path_provider.dart';
import 'messages.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepo {
  //late means it will be initalized before it's used.
  late final Database db;
  bool _initalized = false;
  ChatRepo._(); //private constructor
  static final ChatRepo _instance = ChatRepo._();
  factory ChatRepo() => _instance; //just makes sure there is only ever one
  Logger logger = Logger();

  Future<void> initializeDatabase() async {
    //opens or creates if it doesn't already exist
    //gets dynamic path to app storage... won't be deleted when app is deleted
    if (!_initalized) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final dbPath = '${appDocumentDir.path}/chat_database.db';
      db = await databaseFactoryIo.openDatabase(dbPath);
      _initalized = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ID', 1); //set ID to 1 at beginning
      //initialize to 1... save 0 to store chatlog names
    }
  }

  Future<int> _getCurrentID() async {
    final prefs = await SharedPreferences.getInstance();
    final int? ID = prefs.getInt('ID');
    if (ID == null) {
      throw Exception('no ID found!');
    } else {
      return ID;
    }
  }

  Future<int> _updateChatID() async {
    //update shared preferences to save this after app is closed
    final prefs = await SharedPreferences.getInstance();

    final currentID = prefs.getInt('ID');
    final newID = currentID! + 1;
    await prefs.setInt('ID', newID);
    return newID;
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
    try {
      print('Storing message: $message'); // Log the message being stored
      StoreRef<int, Map<String, dynamic>> store =
          intMapStoreFactory.store('chat_${message.chatID}');
      await store.add(db, message.toJson());
      print('Message stored successfully'); // Log successful message storage
    } catch (e) {
      print('Error storing message: $e'); // Log error storing the message
      logger.e('Error storing message: $e'); // Log error using loggerthe
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
