import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/pages/chat_layout.dart';
import 'package:app/functionality/messaging.dart';
import 'package:app/functionality/messages.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  late final TextEditingController _messageController;
  late final ChatRepo _chatRepo;
  int _chatID = 0;
  bool emptyChat = true;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
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

  Future<void> _sendMessage() async {
    String content = _messageController.text.trim();
    if (content.isNotEmpty) {
      Message sent = Message(
        chatID: _chatID,
        content: content,
        timestamp: DateTime.now(),
        isUser: true,
      );
      await _chatRepo.storeMessage(sent);
      _messageController.clear();
      setState(() {
        emptyChat = false;
      });

      await Future.delayed(const Duration(milliseconds: 50), () {
        if (_scrollController.hasClients) {
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent + 135);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatsPageLayout(
      body: Column(
        children: [
          Expanded(
            child: MessagingWidget(
              chatID: _chatID,
              chatRepo: _chatRepo,
              scrollController: _scrollController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 207, 207, 207)),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText:
                          emptyChat ? 'What sounds good?' : 'Tell me more...',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 207, 207, 207)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 207, 207, 207),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
