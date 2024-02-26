import 'package:flutter/material.dart';
import 'package:app/pages/home.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

//ROOT
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //display HomePage First
      home: const HomePage(),
    );
  }
}

//TODO: need to make HomePage which will popup first. then need to route
//Home page to chat page on a button push which we can configure later
//to make it better :)
