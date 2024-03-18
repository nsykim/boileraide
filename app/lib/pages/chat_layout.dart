import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsPageLayout extends StatelessWidget {
  final Widget body;

  const ChatsPageLayout({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  '  boileraide',
                  style: GoogleFonts.poppins(
                    color: const Color(0xffD0ad50),
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )),
        body: Container(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xff202020),
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
      ),
    );
  }
}
