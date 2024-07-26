import 'package:flutter/material.dart';
import 'package:link_chat/screens/chat_screen.dart';
import 'package:link_chat/screens/profile_screen.dart';
import 'package:link_chat/screens/search_screen.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//   static const routeName = '/';

  final List<Widget> _pages = const [
    SearchScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Link Chat',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Theme.of(context).primaryColor,
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.message),
            selectedIcon: Icon(
              Icons.message,
              color: Colors.white,
            ),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
