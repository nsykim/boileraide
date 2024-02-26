import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';


class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 251, 218, 117),
            title: 
            const Column(
              children: [
              Text('ECE49595-NL: BoilerAide',
                  style: TextStyle(
                    fontSize: 20,
                  )),
              Text(
                'Realize Your Culinary Imagination',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              // title: const Text('Realize Your Culinary Imagination')
            ]),
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