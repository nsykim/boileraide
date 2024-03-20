import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/functionality/messages.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class MessagingWidget extends StatefulWidget {
  final int chatID;
  final ChatRepo chatRepo;
  final ScrollController scrollController;

  const MessagingWidget({
    Key? key,
    required this.chatID,
    required this.chatRepo,
    required this.scrollController,
  }) : super(key: key);

  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  late final TextEditingController _messageController;
  bool firstChat = true;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.scrollController
            .jumpTo(widget.scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Message>>(
            future: widget.chatRepo.getAllMessages(widget.chatID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final messages = snapshot.data ?? [];
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _scrollToBottom(); // Move scroll to bottom after the list is built
                });
                return ListView.builder(
                  shrinkWrap: true,
                  controller: widget.scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: message.isUser
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.66),
                            decoration: BoxDecoration(
                              color: message.isUser
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.only(
                                right: 12.0,
                                top: 12.0,
                                bottom: 12.0,
                                left: 8.0),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: message.isUser
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: 'puffins',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0, top: 2.0),
                            child: Text(
                              DateFormat('yyyy-MM-dd hh:mm a')
                                  .format(message.timestamp),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 9.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
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
                        firstChat ? 'What sounds good?' : 'Tell me more...',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 207, 207, 207)),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  String content = _messageController.text.trim();
                  if (content.isNotEmpty) {
                    try {
                      print('ChatID: ${widget.chatID}');
                      print('Message content: ${_messageController.text}');
                      Message sent = Message(
                        chatID: widget.chatID,
                        content: content,
                        timestamp: DateTime.now(),
                        isUser: true,
                      );
                      await widget.chatRepo.storeMessage(sent);
                      setState(() {});
                      _messageController.clear();
                      _scrollToBottom();
                      firstChat = false;
                    } catch (e) {
                      logger.e(
                          "Error storing message: $e"); // Add this line for logging errors
                    }
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 207, 207, 207),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
