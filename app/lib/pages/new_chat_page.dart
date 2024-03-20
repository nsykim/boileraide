import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/pages/chat_layout.dart';
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
  int _chatID = 0;
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
       logger.d('Initializing ChatRepo');
      await _chatRepo.initializeDatabase();
      _generateNewID();
      setState(() {});
      logger.d('ChatRepo initialized successfully');
    } catch (e) {
      logger.e('Error initializing ChatRepo: $e');
    }
  }

  Future<void> _generateNewID() async {
    if (_chatID == 0) {
      int maxID = await _chatRepo.getMaxID();
      if (maxID != 0) {
        setState(() {
          _chatID = maxID + 1;
        });
         logger.d('New chat ID generated: $_chatID');
      }
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
