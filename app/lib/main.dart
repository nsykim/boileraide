import 'package:flutter/material.dart';
import 'package:app/pages/home.dart';
// import 'openai_service.dart';
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

//NOAH U CAN UNCOMMENT THIS PART TO TEST IT I THINK AND COMMENT OUT UR CODE ALSO MAKE SURE TO UNCOMMENT THE IMPORT STUFF I THINK THIS SHOULD WORK BUT IF NOT THEN I GOTTA SET UP THE ENVIRONMENT
//YOU ALSO MIGHT NEED TO DO SOME BUGFIXING BUT IDK J READ ERROR MESSAGES IF THERE ARE ANY

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
  
// }

// class _MyAppState extends State<MyApp> {
//   final TextEditingController _controller = TextEditingController();
//   String _response = '';

//   void _getResponse() async {
//     final openAIService = OpenAIService();
//     final response = await openAIService.sendPrompt(_controller.text);
//     setState(() {
//       _response = response;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('ChatGPT Flutter App'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(labelText: 'Enter your prompt'),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _getResponse,
//               child: const Text('Send'),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(_response),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//TODO: need to make HomePage which will popup first. then need to route
//Home page to chat page on a button push which we can configure later
//to make it better :)

