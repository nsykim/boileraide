import 'package:flutter/material.dart';
import 'package:app/functionality/chat_repo.dart';
import 'package:app/pages/chat_layout.dart';
import 'package:app/functionality/messages.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
    _generateNewID();
  }

  Future<void> _generateNewID() async {
    if (_chatID == 0) {
      int maxID = await _chatRepo.getMaxID(); //get max ID if chatID is 0 (assumed uninitialized)
      if (maxID  != 0) { //returns 0 if search returns NULL (first)
          setState(() {
            _chatID = maxID + 1;
          });
        }
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
                    itemBuilder : (context, index) {
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
    ]));
  }
}
