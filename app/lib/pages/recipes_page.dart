import 'package:flutter/material.dart';
import 'package:app/pages/background_formatting.dart'; // Importing the ChatsPageLayout widget

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return const ChatsPageLayout(
      body: Center(
        child: Text(
          'Recipe Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
