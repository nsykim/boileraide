import 'package:app/pages/chat.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       home: Scaffold(
//           backgroundColor:const Color.fromARGB(255, 251, 218, 117),
//           body:
//           Center(
//             child: Column(children: [
//               const Text('Welcome to BoilerAide!',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   )),
//               const Text('Realize Your Culinary Imagination',
//                   style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
//               const Text('A Purdue ECE49595-NL Project',
//                   style: TextStyle(
//                     fontSize: 10,
//                   )),
//               Expanded(
//                   child: ElevatedButton(
//                 style: const ButtonStyle(
//                   padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 60, horizontal: 5)),
//                 ),
//                 onPressed: () {
//                   //go to chat page
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ChatPage(),
//                     ),
//                   );
//                 },
//                 child: const Text('Get Started'),
//               ))
//             ]),
//           )
//           ),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 251, 242, 117),
        body: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the children vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the children horizontally
            children: [
              Text(
                'Welcome to BoilerAide!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                'Realize Your Culinary Imagination',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              const Text(
                'A Purdue ECE49595-NL Project',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 20, // Adjust this height according to your preference
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  // Go to chat page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatPage(),
                    ),
                  );
                },
                child: const Text('Get Started',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
