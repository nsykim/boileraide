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
  late int _chatID;
  final Logger logger = Logger();

  @override
  void initState() {
    _chatID = -1;
    super.initState();
    _chatRepo = ChatRepo.instance;
    _scrollController = ScrollController();
    // logger.d('NewChatPage initialized. Chat ID: $_chatID');
  }

  Future<void> _initializeChatRepo() async {
    if (_chatID == -1) {
      try {
        // logger.d('Initalizing ChatRepo');
        await _generateNewID();
        logger.d('Initializing new Store with ID: $_chatID');
        setState(() {});
        // logger.d('Initialized ChatRepo Successfully');
      } catch (e) {
        logger.e('Error initializing the Chat Repository with ID $_chatID: $e');
      }
    }
  }

  Future<void> _generateNewID() async {
    if (_chatID == -1) {
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
        initializeChatRepo: _initializeChatRepo,
      ),
    );
  }
}
