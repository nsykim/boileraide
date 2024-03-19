import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/pages/chat_layout.dart';
import 'package:app/functionality/messaging.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  late final ChatRepo _chatRepo;
  late final ScrollController _scrollController;
  int _chatID = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    _chatRepo = ChatRepo();
    _initializeChatRepo();
  }

  Future<void> _initializeChatRepo() async {
    try {
      await _chatRepo.initializeDatabase();
      _generateNewID();
      setState(() {});
    } catch (e) {
      print('Initialization error $e');
    }
  }

  Future<void> _generateNewID() async {
    if (_chatID == 0) {
      int maxID = await _chatRepo.getMaxID();
      if (maxID != 0) {
        setState(() {
          _chatID = maxID + 1;
        });
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
