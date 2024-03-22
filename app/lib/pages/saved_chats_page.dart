import 'package:flutter/material.dart';
import 'package:app/pages/background_formatting.dart'; // Importing the ChatsPageLayout widget

class SavedChatsPage extends StatelessWidget {

  const SavedChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChatsPageLayout(
      body: Center(
        child: Text(
          'Saved Chats Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
