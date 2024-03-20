import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/pages/background_formatting.dart';
import 'package:app/functionality/messaging.dart';
import 'package:logger/logger.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  late final ChatRepo _chatRepo;
  late final ScrollController _scrollController;
  int _chatID = -1;
  final Logger logger = Logger();

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    _chatRepo = ChatRepo();
    _initializeChatRepo();
    logger.d('NewChatPage initialized. Chat ID: $_chatID');
  }

  Future<void> _initializeChatRepo() async {
    try {
      logger.d('Initalizing ChatRepo');
      _generateNewID();
      await _chatRepo.initializeDatabase();
      logger.d('New ID: $_chatID');
      setState(() {});
      logger.d('Initialized ChatRepo Successfully');
    } catch (e) {
      logger.e('Error initializing the Chat Repository with ID $_chatID: $e');
    }
  }

  Future<void> _generateNewID() async {
    if (_chatID == -1) {
      //not set then generate... should always be true
      _chatID = await _chatRepo.updateChatID();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatsPageLayout(
      body: MessagingWidget(
        scrollController: _scrollController,
        chatID: _chatID,
        chatRepo: _chatRepo,
      ),
    );
  }
}
