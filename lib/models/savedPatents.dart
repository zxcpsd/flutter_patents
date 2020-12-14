import 'package:flutter/foundation.dart';
import 'package:patents/models/patent.dart';
import 'package:patents/util/dbHelper.dart';

class SavedPatentsModel extends ChangeNotifier {
  DbHelper _helper;
  List<Patent> _list;
  List<Patent> get list => _list;
  SavedPatentsModel() {
    _helper = DbHelper();
    getData();
  }
  Future getData() async {
    await _helper.openDb();
    _list = await _helper.getPatents();
    notifyListeners();
  }

  void deletePatent(int index) {
    _helper.deletePatent(_list[index]);
    _list.removeAt(index);
    notifyListeners();
  }
}
