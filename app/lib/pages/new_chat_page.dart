import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/pages/chat_layout.dart';
import 'package:app/functionality/messages.dart';

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

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    //superclass is stateful widget. makes sure that the initalization of super class is executed
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
      setState(() {});
      //ui update
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.timestamp.toString()),
                  );
                },
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
                  hintText: 'What sounds good to eat?',
                ),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
            )
          ])),
    ]));
  }
}
