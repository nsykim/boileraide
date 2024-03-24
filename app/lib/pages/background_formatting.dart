import 'package:app/pages/saved_chats_page.dart';
import 'package:app/pages/new_chat_page.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/pages/recipes_page.dart';
import 'package:app/functionality/test.dart';

class ChatsPageLayout extends StatefulWidget {
  final Widget body;

  const ChatsPageLayout({Key? key, required this.body}) : super(key: key);

  @override
  State<ChatsPageLayout> createState() => _ChatsPageLayoutState();
}

class _ChatsPageLayoutState extends State<ChatsPageLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2;
    _loadSavedIndex(); // Call the method to load the saved index
  }

  void _loadSavedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex =
        prefs.getInt('selectedIndex') ?? 2; // Default to 2 if no value is saved
    setState(() {
      _selectedIndex = savedIndex;
    });
  }

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

  void _onItemTapped(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('index: $index selectedIndex: $_selectedIndex');
    if (index != _selectedIndex) {
      if (index != 0 && _selectedIndex == 0) {
        bool confirmed = await _confirmLeave(context);
        if (confirmed) {
          prefs.setInt('selectedIndex', index);
          _navigateToIndex(index);
        }
      } else {
        prefs.setInt('selectedIndex', index);
        _navigateToIndex(index);
      }
    }
  }

  void _navigateToIndex(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (index) {
            case 0:
              return const NewChatPage();
            case 1:
              return const RecipePage();
            case 2:
              return const SavedChatsPage();
            default:
              // Navigate to some default page or handle other cases
              return Container();
          }
        },
      ),
    ).then((_) {
      setState(() {
        _selectedIndex = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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

      body: flutter.Column(
        children: [
          Expanded(child: widget.body),
          const DatabaseManagementWidget(), // Add the widget here
        ],
      ),

      //REMOVE THIS WHEN DONE TESTING

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff202020),
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xffD0ad50),
        unselectedItemColor: const Color(0xffD0ad50),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble,
            ),
            label: 'New Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark,
            ),
            label: 'Saved Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.timer,
            ),
            label: 'Previous Chats',
          ),
        ],
      ),
    );
  }
}
