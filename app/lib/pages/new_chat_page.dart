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
  // late int _chatID;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _chatRepo = ChatRepo();
    _scrollController = ScrollController();
  }


  @override
  Widget build(BuildContext context) {
    return ChatsPageLayout(
      body: MessagingWidget(
        scrollController: _scrollController,
        chatRepo: _chatRepo,
      ),
    );
  }
}
