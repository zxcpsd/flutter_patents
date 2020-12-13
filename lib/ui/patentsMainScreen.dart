import 'package:flutter/material.dart';

import 'savedPatentsTab.dart';
import 'searchTab.dart';

class PatentsMainScreen extends StatefulWidget {
  @override
  _PatentsMainScreenState createState() => _PatentsMainScreenState();
}

class _PatentsMainScreenState extends State<PatentsMainScreen> {
  int _selectedIndex = 0;
  static const List<String> navbarStrings = ['Search', 'Saved Patents'];
  static List<Widget> _widgetOptions = <Widget>[
    SearchTab(),
    SavedPatentsTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patents'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: navbarStrings[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: navbarStrings[1],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
