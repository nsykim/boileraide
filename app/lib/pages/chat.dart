import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xff202020),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xff202020),
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
                label: 'Chat',
                // backgroundColor:Color(0xffD0ad50),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
            ],
             selectedItemColor: const Color(0xffD0ad50),
             unselectedItemColor: const Color.fromARGB(255, 113, 83, 5),
             ),
      ),
    );
  }
}
