import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart'; //used store chat data
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'messages.dart';

class ChatRepo {
  //late means it will be initalized before it's used.
  late final Database db;
  //list of chatIDs so we know if this is a new chat and need to open a new store
  final List<int> chatIDs = [];

  ChatRepo() {
    //constructor... will create a new database called chat_database
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    //opens or creates if it doesn't already exist
    db = await databaseFactoryIo.openDatabase('chat_database.db');
  }

  Future<void> createNewStore(Message message) async {
    if (!chatIDs.contains(message.chatID)) {
      chatIDs.add(message.chatID);
      StoreRef<int, Map<String, dynamic>> store =
          intMapStoreFactory.store('chat_$message.chatID');
      await store
          .record(0)
          .put(db, {'dummy': 'data'}); //just put dummy data in form now
    }
  }

  Future<void> storeMessage(Message message) async {
    createNewStore(message); //make sure there is a store to hold messages
  }
}
