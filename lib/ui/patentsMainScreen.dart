import 'package:flutter/material.dart';
import 'package:patents/models/mainScreen.dart';
import 'package:provider/provider.dart';

import 'savedPatentsTab.dart';
import 'searchTab.dart';

class PatentsMainScreen extends StatelessWidget {
  static List<Widget> _widgetOptions = <Widget>[
    SearchTab(),
    SavedPatentsTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainScreenModel(),
      child: Consumer<MainScreenModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Patents'),
          ),
          body: _widgetOptions.elementAt(model.selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: MainScreenModel.navbarStrings[0],
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: MainScreenModel.navbarStrings[1],
              ),
            ],
            currentIndex: model.selectedIndex,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              model.selectedIndex = index;
            },
          ),
        ),
      ),
    );
  }
}
