import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/pages/chat_layout.dart';
import 'package:app/functionality/messages.dart';
import 'package:google_fonts/google_fonts.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  //text editing controller is how text is managed by flutter... define as late->
  //so avoid potential issues related to widget lifecycle
  late final TextEditingController _messageController;
  //define but not initialize... this will be filled in in the initiate state (when the page is first loaded)
  late final ChatRepo _chatRepo;
  int _chatID = 0; //initalize to 0 in case this is the first chatID
  bool emptyChat = true;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    //superclass is stateful widget. makes sure that the initalization of super class is executed
    _scrollController = ScrollController();
    _chatRepo = ChatRepo();
    _initalizeChatRepo();
  }

  Future<void> _initalizeChatRepo() async {
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
      int maxID = await _chatRepo
          .getMaxID(); //get max ID if chatID is 0 (assumed uninitialized)
      if (maxID != 0) {
        //returns 0 if search returns NULL (first)
        setState(() {
          _chatID = maxID + 1;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    String content = _messageController.text.trim(); //message content
    //.trim removes leading and trailing whitespaces
    if (content.isNotEmpty) {
      //if contains info
      Message sent = Message(
          //fill out message class
          chatID: _chatID,
          content: content,
          timestamp: DateTime.now(),
          isUser: true);
      await _chatRepo.storeMessage(sent);
      //clear the chatbar
      _messageController.clear();
      setState(() {
        emptyChat = false;
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
      //ui update
    }
  }

  Future<void> _confirmReload() async {
    bool confirm = false;
    if (!emptyChat) {
      confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmation'),
          content:
              const Text('Are you sure you want to reload the chat window?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Reload'),
            ),
          ],
        ),
      );
    } else {
      confirm = true;
    }
    if (confirm) {
      setState(() {
        emptyChat = true;
        _chatID = 0;
      });
      _generateNewID();
    }
  }

  Widget build(BuildContext context) {
    return ChatsPageLayout(
        body: Column(children: [
      Expanded(
        child: FutureBuilder<List<Message>>(
          future: _chatRepo.getAllMessages(_chatID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              //error message
              return Text('Error: ${snapshot.error}');
            } else {
              final messages = snapshot.data ?? [];
              return ListView.builder(
                  shrinkWrap: true,
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
                                maxWidth: MediaQuery.of(context).size.width*0.66,
                              ),
                              decoration: BoxDecoration(
                                color: message.isUser
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.only(right: 12.0, top: 12.0, bottom: 12.0, left: 8.0),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: message.isUser
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: 'puffins',
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, top: 2.0),
                              child: Text(
                                message.timestamp.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 9.0,
                                ),
                              ),
                            ),
                          ],
                        ));
                  }
              );
            }
          },
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                    hintText: 'What sounds good...?',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 207, 207, 207),
                    )),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Color.fromARGB(255, 207, 207, 207),
              ),
            )
          ])),
    ]));
  }
}
