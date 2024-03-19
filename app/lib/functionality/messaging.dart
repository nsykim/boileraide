import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/functionality/messages.dart';
import 'package:intl/intl.dart';

class MessagingWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: chatRepo.getAllMessages(chatID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final messages = snapshot.data ?? [];
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (scrollController.hasClients) {
              Future.delayed(const Duration(milliseconds: 100), () {
                 scrollController.jumpTo(scrollController.position.maxScrollExtent);
              });
            }
          });
          return ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.66),
                      decoration: BoxDecoration(
                        color: message.isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.only(
                          right: 12.0, top: 12.0, bottom: 12.0, left: 8.0),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: message.isUser ? Colors.white : Colors.black,
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
    );
  }
}
