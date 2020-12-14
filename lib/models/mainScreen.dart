import 'package:flutter/foundation.dart';

class MainScreenModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }

  static const List<String> navbarStrings = ['Search', 'Saved Patents'];
}
