import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/pages/new_chat_page.dart';

class ChatsPageLayout extends StatefulWidget {
  final Widget body;

  const ChatsPageLayout({Key? key, required this.body}) : super(key: key);

  @override
  State<ChatsPageLayout> createState() => _ChatsPageLayoutState();
}

class _ChatsPageLayoutState extends State<ChatsPageLayout> {
  int _selectedIndex = 0;

  Future<bool> _confirmLeave(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Are you sure you want to leave?'),
          content: const Text('This new chat will be saved in Previous Chats'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ]),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    // key: key, //get rid of the annoying warning
    return Scaffold(
      backgroundColor: const Color(0xff202020),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff202020),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_trans.png',
                height: 30,
              ),
              Text(
                '    boileraide',
                style: GoogleFonts.poppins(
                  color: const Color(0xffD0ad50),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff202020),
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index != 0 && _selectedIndex == 0) {
            //if on new chat and trying to go to different page
            final confirmed = await _confirmLeave(context);
            if (confirmed) {
              setState(() {
                _selectedIndex = index;
              });
            } 
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
          // if (index == 1) {
          //   Navigator.push(context, MaterialPageRoute(builder: (context => RecipesPage()),
          //   ));
          // } else if (index == 2) {
          //   Navigator.push(context, MaterialPageRoute(builder: (context => SavedChats()),
          //   ));
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'New Chat',
            // backgroundColor:Color(0xffD0ad50),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Previous Chats',
            // backgroundColor:Color(0xffD0ad50),
          ),
        ],
        selectedItemColor: const Color(0xffD0ad50),
        unselectedItemColor:
            const Color.fromARGB(255, 113, 83, 5), //remember to test!!!
      ),
      // ),
    );
  }
}
