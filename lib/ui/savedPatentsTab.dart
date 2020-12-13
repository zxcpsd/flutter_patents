import 'package:flutter/material.dart';

import '../util/dbHelper.dart';
import '../models/patent.dart';

class SavedPatentsTab extends StatefulWidget {
  @override
  _SavedPatentsTabState createState() => _SavedPatentsTabState();
}

class _SavedPatentsTabState extends State<SavedPatentsTab> {
  DbHelper helper;
  List<Patent> list;
  @override
  void initState() {
    helper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Container(
        child: ListView.builder(
            itemCount: (list != null) ? list.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(list[index].patentId),
                onDismissed: (direction) {
                  String strName = list[index].patentId;
                  helper.deletePatent(list[index]);
                  setState(
                    () {
                      list.removeAt(index);
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('$strName deleted')));
                    },
                  );
                },
                child: ListTile(
                  title: Text(list[index].title),
                  subtitle:
                      Text('${list[index].date} ID:${list[index].patentId}'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(list[index].title),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            content: Container(
                                child: SingleChildScrollView(
                                    child: Text(list[index].description))),
                          );
                        });
                  },
                ),
              );
            }));
  }

  Future getData() async {
    await helper.openDb();
    list = await helper.getPatents();
    setState(() {
      list = list;
    });
  }
}
