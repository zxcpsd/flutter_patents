import 'package:flutter/material.dart';
import 'package:patents/models/searchModes.dart';
import 'package:patents/models/searchWidget.dart';
import 'package:patents/util/dbHelper.dart';
import 'package:patents/models/patent.dart';
import 'package:provider/provider.dart';

import '../models/inventor.dart';
import '../util/netHelper.dart';

final globalKey = GlobalKey<ScaffoldState>();

class SearchTab extends StatelessWidget {
  final txtId = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtDateFrom = TextEditingController();
  final txtDateTo = TextEditingController();
  final txtTitle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flex(
          direction: MediaQuery.of(context).orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Find patent by id'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        content: Container(
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.landscape)
                              ? MediaQuery.of(context).size.height * 0.5
                              : MediaQuery.of(context).size.height * 0.2,
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  TextField(
                                    controller: txtId,
                                    decoration:
                                        InputDecoration(hintText: 'Patent id'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(14),
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider<
                                                            SearchWidgetModel>(
                                                        create: (context) =>
                                                            SearchWidgetModel(
                                                                txtId.text,
                                                                SearchMode
                                                                    .byId),
                                                        child:
                                                            SearchWidget())));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Icon(Icons.search),
                                          Text('Search')
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: SearchIcon('id'),
            ),
            FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.all(10.0),
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Find patent by title'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextField(
                                      controller: txtTitle,
                                      decoration: InputDecoration(
                                          hintText: 'Patent title'),
                                    ),
                                    Padding(padding: EdgeInsets.all(15)),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider<
                                                          SearchWidgetModel>(
                                                        create: (context) =>
                                                            SearchWidgetModel(
                                                                txtTitle.text
                                                                    .split(' '),
                                                                SearchMode
                                                                    .byTitle),
                                                        child: SearchWidget(),
                                                      )));
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.search),
                                            Text('Search')
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: SearchIcon('title')),
            FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.all(10.0),
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Find patent by author and date'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextField(
                                      controller: txtFirstName,
                                      decoration: InputDecoration(
                                          hintText: 'Patent author first name'),
                                    ),
                                    TextField(
                                      controller: txtLastName,
                                      decoration: InputDecoration(
                                          hintText: 'Patent author last name'),
                                    ),
                                    TextField(
                                      controller: txtDateFrom,
                                      decoration: InputDecoration(
                                          hintText: 'Date from: YYYY-MM-DD'),
                                    ),
                                    TextField(
                                      controller: txtDateTo,
                                      decoration: InputDecoration(
                                          hintText: 'Date to: YYYY-MM-DD'),
                                    ),
                                    Padding(padding: EdgeInsets.all(15)),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider<
                                                          SearchWidgetModel>(
                                                        create: (context) =>
                                                            SearchWidgetModel({
                                                          "firstName":
                                                              txtFirstName.text,
                                                          "lastName":
                                                              txtLastName.text,
                                                          "dateTo":
                                                              txtDateTo.text,
                                                          "dateFrom":
                                                              txtDateFrom.text,
                                                        }, SearchMode.byParams),
                                                        child: SearchWidget(),
                                                      )));
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.search),
                                            Text('Search')
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: SearchIcon('author and date')),
          ]),
    );
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchWidgetModel>(
      builder: (context, model, child) => Scaffold(
          key: globalKey,
          appBar: AppBar(
            title: Text('Search results'),
          ),
          body: (!model.isExecuted)
              ? Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: CircularProgressIndicator()))
              : (model.list.length == 0)
                  ? Center(
                      child:
                          Text('Nothing found', style: TextStyle(fontSize: 25)))
                  : Column(
                      children: [
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (model.isUpdateExecuted &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent &&
                                  (NetHelper.currentTotalCount -
                                          model.pages * 50 >
                                      0)) {
                                model.startLoading();
                              }
                              return true;
                            },
                            child: ListView.builder(
                              itemCount: (model.list.length),
                              itemBuilder: (BuildContext context, int index) {
                                PatentWithAuthors patent = model.list[index];
                                return ListTile(
                                    title: Text(patent.title),
                                    subtitle: Text(
                                      Inventor.getAuthorsSubtitle(
                                          patent.authors),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(patent.title),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(patent.description ==
                                                            null
                                                        ? ''
                                                        : patent.description),
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(patent.date),
                                                        SaveButton(patent),
                                                        Text(patent.patentId)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    });
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: model.isUpdateExecuted ? 0 : 50.0,
                          color: Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.grey[100],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text((model.currentCount != 1)
                                  ? '${model.currentCount} items total'
                                  : '1 item total'),
                            ],
                          ),
                        )
                      ],
                    )),
    );
  }
}

class SearchIcon extends StatelessWidget {
  final String text;
  SearchIcon(this.text);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.search, size: 50),
        Text('Search by $text', style: TextStyle(fontSize: 24))
      ],
    );
  }
}

class SaveButton extends StatelessWidget {
  final PatentWithAuthors patent;
  SaveButton(this.patent);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.grey[100],
        child: Text('Save'),
        onPressed: () {
          DbHelper helper = DbHelper();
          helper.insertPatent(patent);
          Navigator.of(context).pop();
          globalKey.currentState.showSnackBar(
              SnackBar(content: Text('${patent.patentId} saved')));
        });
  }
}
