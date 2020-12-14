import 'package:flutter/material.dart';
import 'package:patents/models/savedPatents.dart';
import 'package:provider/provider.dart';

import '../models/patent.dart';

class SavedPatentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SavedPatentsModel(),
      child: Consumer<SavedPatentsModel>(
        builder: (context, model, child) => Container(
            child: ListView.builder(
                itemCount: (model.list != null) ? model.list.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  Patent patent = model.list[index];
                  return Dismissible(
                    key: Key(patent.patentId),
                    onDismissed: (direction) {
                      String strName = patent.patentId;
                      model.deletePatent(index);
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('$strName deleted')));
                    },
                    child: ListTile(
                      title: Text(patent.title),
                      subtitle: Text('${patent.date} ID:${patent.patentId}'),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(patent.title),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                content: Container(
                                    child: SingleChildScrollView(
                                        child: Text(patent.description))),
                              );
                            });
                      },
                    ),
                  );
                })),
      ),
    );
  }
}
