import 'package:flutter/material.dart';
import 'package:patents/util/dbHelper.dart';
import 'package:patents/models/patent.dart';

import '../models/inventor.dart';
import '../util/netHelper.dart';

enum SearchMode { byId, byParams, byTitle }
final globalKey = GlobalKey<ScaffoldState>();

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<PatentWithAuthors> list;
  final txtId = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtDateFrom = TextEditingController();
  final txtDateTo = TextEditingController();
  final txtTitle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                Widget>[
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  SearchWidget(txtId.text,
                                                      SearchMode.byId)));
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
                                                    SearchWidget(
                                                        txtTitle.text
                                                            .split(' '),
                                                        SearchMode.byTitle)));
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
                                                    SearchWidget({
                                                      "firstName":
                                                          txtFirstName.text,
                                                      "lastName":
                                                          txtLastName.text,
                                                      "dateTo": txtDateTo.text,
                                                      "dateFrom":
                                                          txtDateFrom.text,
                                                    }, SearchMode.byParams)));
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
      )),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final dynamic query;
  final SearchMode mode;
  SearchWidget(this.query, this.mode);
  @override
  _SearchWidgetState createState() => _SearchWidgetState(query, mode);
}

class _SearchWidgetState extends State<SearchWidget> {
  final dynamic query;
  final SearchMode mode;
  int pages = 1;
  List<PatentWithAuthors> list = List<PatentWithAuthors>();
  bool isExecuted = false;
  bool isUpdateExecuted = true;
  _SearchWidgetState(this.query, this.mode);

  @override
  void initState() {
    switch (mode) {
      case SearchMode.byId:
        NetHelper.getPatent(query).then((value) {
          if (value != null) list.add(value);
          setState(() {
            isExecuted = true;
          });
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
          setState(() {
            isExecuted = true;
          });
        });
        break;
      case SearchMode.byTitle:
        NetHelper.getPatentsByStringQueryList(query).then((value) {
          if (value != null) list = value;
          setState(() {
            isExecuted = true;
          });
        });
        break;
    }
    super.initState();
  }

  void loadMore() async {
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
          setState(() {
            list = list;
            isUpdateExecuted = true;
          });
        });
        break;
      case SearchMode.byTitle:
        NetHelper.getPatentsByStringQueryList(query, ++pages).then((value) {
          if (value != null) list.addAll(value);
          setState(() {
            list = list;
            isUpdateExecuted = true;
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text('Search results'),
        ),
        body: (!isExecuted)
            ? Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: CircularProgressIndicator()))
            : (list.length == 0)
                ? Center(
                    child:
                        Text('Nothing found', style: TextStyle(fontSize: 25)))
                : Column(
                    children: [
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (isUpdateExecuted &&
                                scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent &&
                                (NetHelper.currentTotalCount - pages * 50 >
                                    0)) {
                              setState(() {
                                isUpdateExecuted = false;
                              });
                              loadMore();
                            }
                            return true;
                          },
                          child: ListView.builder(
                            itemCount: (list.length),
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                  title: Text(list[index].title),
                                  subtitle: Text(
                                    Inventor.getAuthorsSubtitle(
                                        list[index].authors),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(list[index].title),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      list[index].description ==
                                                              null
                                                          ? ''
                                                          : list[index]
                                                              .description),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(list[index].date),
                                                      SaveButton(list[index]),
                                                      Text(list[index].patentId)
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
                        height: isUpdateExecuted ? 0 : 50.0,
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
                            Text((NetHelper.currentTotalCount != 1)
                                ? '${NetHelper.currentTotalCount} items total'
                                : '1 item total'),
                          ],
                        ),
                      )
                    ],
                  ));
  }
}

class SearchIcon extends StatelessWidget {
  final String text;
  SearchIcon(this.text);
  @override
  Widget build(BuildContext context) {
    return Column(
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
