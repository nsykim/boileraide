import 'package:flutter/material.dart';
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
            backgroundColor: const Color(0xff202020),
              title: Row (
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
            ],)
            
          ),
          body: Container(
            // margin: const EdgeInsets.all(50),
            // padding: const EdgeInsets.all(50),
            color: const Color.fromARGB(68, 134, 148, 155),
            child: const Text('placeholder'),
          )),
    );
  }
}
