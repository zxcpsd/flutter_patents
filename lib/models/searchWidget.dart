import 'package:flutter/foundation.dart';
import 'package:patents/util/netHelper.dart';

import 'patent.dart';
import 'searchModes.dart';

class SearchWidgetModel extends ChangeNotifier {
  final dynamic query;
  final SearchMode mode;
  int pages = 1;
  List<PatentWithAuthors> list;
  bool isExecuted = false;
  bool isUpdateExecuted = true;
  int get currentCount => NetHelper.currentTotalCount;
  SearchWidgetModel(this.query, this.mode) : list = List<PatentWithAuthors>() {
    switch (mode) {
      case SearchMode.byId:
        NetHelper.getPatent(query).then((value) {
          if (value != null) list.add(value);
          isExecuted = true;
          notifyListeners();
        });
        break;
      case SearchMode.byParams:
        NetHelper.getPatents(
                query["firstName"] == '' ? null : query["firstName"],
                query["lastName"] == '' ? null : query["lastName"],
                query["dateFrom"] == '' ? null : query["dateFrom"],
                query["dateTo"] == '' ? null : query["dateTo"])
            .then((value) {
          if (value != null) list = value;
          isExecuted = true;
          notifyListeners();
        });
        break;
      case SearchMode.byTitle:
        NetHelper.getPatentsByStringQueryList(query).then((value) {
          if (value != null) list = value;
          isExecuted = true;
          notifyListeners();
        });
        break;
    }
  }
  void startLoading() {
    isUpdateExecuted = false;
    notifyListeners();
    loadMore();
  }

  void loadMore() {
    switch (mode) {
      case SearchMode.byId:
        return;
      case SearchMode.byParams:
        NetHelper.getPatents(
                query["firstName"] == '' ? null : query["firstName"],
                query["lastName"] == '' ? null : query["lastName"],
                query["dateFrom"] == '' ? null : query["dateFrom"],
                query["dateTo"] == '' ? null : query["dateTo"],
                ++pages)
            .then((value) {
          if (value != null) list.addAll(value);
          list = list;
          isUpdateExecuted = true;
          notifyListeners();
        });
        break;
      case SearchMode.byTitle:
        NetHelper.getPatentsByStringQueryList(query, ++pages).then((value) {
          if (value != null) list.addAll(value);
          list = list;
          isUpdateExecuted = true;
          notifyListeners();
        });
        break;
    }
  }
}
