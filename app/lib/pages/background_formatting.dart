import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/functionality/test.dart';

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
                backgroundColor: const Color(0xff202020),
                title: Text(
                  'Exit the chat?',
                  style: GoogleFonts.poppins(
                    color: const Color(0xffD0ad50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text('It will be saved in Previous Chats',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    )),
                actions: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No',
                                style: GoogleFonts.poppins(
                                  color: Colors.cyan,
                                )),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Yes',
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                )),
                          ),
                        )
                      ])
                ]));
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    // key: key, //get rid of the annoying warning
    return Scaffold(
      backgroundColor: const Color(0xff202020),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color(0xff202020),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_trans.png',
                height: 30,
              ),
              const SizedBox(width: 8),
              Text(
                'boileraide',
                style: GoogleFonts.poppins(
                  color: const Color(0xffD0ad50),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )),
      // body: widget.body,

      //REMOVE THIS WHEN DONE TESTING

      body: Column(
        children: [
          Expanded(child: widget.body),
          const DatabaseManagementWidget(), // Add the widget here
        ],
      ),

      //REMOVE THIS WHEN DONE TESTING

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
        unselectedItemColor: const Color.fromARGB(255, 113, 83, 5),
      ),
      // ),
    );
  }
}
