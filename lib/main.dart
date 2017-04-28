import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(new MaterialApp(
    title: 'Lists',
    theme: new ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see
      // the application has a blue toolbar. Then, without quitting
      // the app, try changing the primarySwatch below to Colors.green
      // and then invoke "hot reload" (press "r" in the console where
      // you ran "flutter run", or press Run > Hot Reload App in IntelliJ).
      // Notice that the counter didn't reset back to zero -- the application
      // is not restarted.
      primarySwatch: Colors.blue,
    ),
    home: new MyHomePage(title: 'Lists'),
    //showPerformanceOverlay: true,
  ));
}

//////
// For Home Page that displays list and schedule
//////

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful,
  // meaning that it has a State object (defined below) that contains
  // fields that affect how it looks.

  // This class is the configuration for the state. It holds the
  // values (in this case the title) provided by the parent (in this
  // case the App widget) and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(
      text: 'General',
      icon: new Icon(Icons.dehaze),
    ),
    new Tab(
      text: 'Schedule',
      icon: new Icon(Icons.event),
    )
  ];

  Map<EventItem, List<MyListItem>> listItems = new Map<EventItem,
      List<MyListItem>>(); // Stores list items for every list

  List<EventItem> myLists = [
    new EventItem(title: "Hello", date: new DateTime.now()),
    new EventItem(title: "World", date: new DateTime.now()),
    new EventItem(title: "DEADBEEF", date: new DateTime.now()),
  ];
  List<EventItem> mySchedule = [
    new EventItem(title: "Hello", date: new DateTime.now()),
    new EventItem(title: "World", date: new DateTime.now().add(new Duration(days: 3))),
    new EventItem(title: "DEADBEEF", date: new DateTime.now().subtract(new Duration(days: 4))),
    new EventItem(title: "Just testies", date: new DateTime.now().subtract(new Duration(days: 12))),
  ];

  TabController _tabController;

  void _handleListItemsChanged(EventItem event, List<MyListItem> list) {
    listItems[event] = list;
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
    // TODO:
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance
    // as done by the _incrementCounter method above.
    // The Flutter framework has been optimized to make rerunning
    // build methods fast, so that you can just rebuild anything that
    // needs updating rather than having to individually change
    // instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that
        // was created by the App.build method, and use it to set
        // our appbar title.
        title: new Text(widget.title),
        bottom: new TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new MyLists(myLists, listItems, _handleListItemsChanged),
          new MySchedule(mySchedule, listItems, _handleListItemsChanged),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          EventItem newListName =
              await Navigator.of(context).push(new MaterialPageRoute<EventItem>(
            builder: (BuildContext context) {
              return new NewListPage();
            },
          ));

          if (newListName != null) {
            setState(() {
              myLists.add(newListName);
            });

            listItems[newListName] = new List();

            Navigator.of(context).push(new MaterialPageRoute<List<MyListItem>>(
                builder: (BuildContext context) {
              return new ListPage(
                listItems: listItems[newListName],
                listTitle: newListName.title,
              );
            }));
          }
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}

class EventItem {
  const EventItem({this.title, this.date});

  final String title;
  final DateTime date;
}

class MySchedule extends StatelessWidget {
  MySchedule(this.schedule, this.listItems, this.onListItemChanged);

  List<EventItem> schedule;
  Map<EventItem, List<MyListItem>> listItems;
  ListItemsChangedCallback onListItemChanged;

  // Instantiation of all necessary DateTimes
  DateTime tomorrow = new DateTime.now().add(new Duration(days: 1));
  DateTime today = new DateTime.now();
  DateTime beginLastWeek = new DateTime.now().subtract(new Duration(days: 7));

  Future scheduleItemOnTap(EventItem event, BuildContext context) async {
    List<MyListItem> newListOfList = await Navigator.of(context).push(new MaterialPageRoute<List<MyListItem>>(
      builder: ((BuildContext context) {
        return new ListPage(
            listItems: itemLists[event],
          listTitle: event.title,
        );
      }),
    ));

    onListItemChanged(event, newListOfList);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getFutureSchedule() {
      List<Widget> futureSchedule = new List<Widget>();

      futureSchedule.addAll(schedule.map((EventItem event) {
        if (event.date.isAfter(today) &&
            (event.date.day >= tomorrow.day ||
            (event.date.month > tomorrow.month &&
            event.date.year >= tomorrow.year))) {
          return new ListTile(
              title: new Text(event.title),
              subtitle: new Text(
                  "${event.date.month}/${event.date.day}/${event.date.year}"),
              onTap: (){scheduleItemOnTap(event, context);},
          );
        }
      }).toList());

      futureSchedule.removeWhere((Widget event) => event == null);
      
      futureSchedule.insert(0, new ListTile(
				title: new Center(child: new Text("Future Pending")),
				subtitle: (futureSchedule.length == 0) ? new Center(child: new Text("Your future is clear and covered (:")) : null,
			));

      return futureSchedule;
    }

    List<Widget> getTodaySchedule() {
      List<Widget> todaySchedule = new List<Widget>();

      todaySchedule.addAll(schedule.map((EventItem event) {
        if (event.date.day == today.day &&
            event.date.month == today.month &&
            event.date.year == today.year) {
          return new ListTile(
              title: new Text(event.title),
              subtitle: new Text(
                  "${event.date.month}/${event.date.day}/${event.date.year}"),
              onTap: (){scheduleItemOnTap(event, context);},
          );
        }
      }).toList());

      todaySchedule.removeWhere((Widget widget) => widget == null);
			
			todaySchedule.insert(0, new ListTile(
				title: new Center(child: new Text("Pending Today")),
				subtitle: (todaySchedule.length == 0) ? new Center(child: new Text("Your day is cleared!")) : null,
			));

      return todaySchedule;
    }

    List<Widget> getPastWeekSchedule() {
      List<Widget> pastWeekSchedule = new List<Widget>();

      pastWeekSchedule.addAll(schedule.map((EventItem event) {
        if (event.date.day < today.day &&
            event.date.day >= beginLastWeek.day &&
            event.date.month <= today.month &&
            event.date.month >= beginLastWeek.month &&
            event.date.year <= today.year &&
            event.date.year >= beginLastWeek.year) {
          return new ListTile(
              title: new Text(event.title),
              subtitle: new Text(
                  "${event.date.month}/${event.date.day}/${event.date.year}"),
              onTap: (){scheduleItemOnTap(event, context);},
          );
        }
      }).toList());

      pastWeekSchedule.removeWhere((Widget widget) => widget == null);
			
			pastWeekSchedule.insert(0, new ListTile(
				title: new Center(child: new Text("Past Week")),
				subtitle: (pastWeekSchedule.length == 0) ? new Center(child: new Text("You haven't done much this past week ):")) : null,
			));

      return pastWeekSchedule;
    }

    List<Widget> getOlderSchedule() {
      List<Widget> olderSchedule = new List<Widget>();

      olderSchedule.addAll(schedule.map((EventItem event) {
        if (event.date.day < beginLastWeek.day &&
            event.date.month <= beginLastWeek.month &&
            event.date.year <= beginLastWeek.year) {
          return new ListTile(
              title: new Text(event.title),
              subtitle: new Text(
                  "${event.date.month}/${event.date.day}/${event.date.year}"),
              onTap: (){scheduleItemOnTap(event, context);},
          );
        }
      }).toList());

      olderSchedule.removeWhere((Widget widget) => widget == null);
			
			olderSchedule.insert(0, new ListTile(
				title: new Center(child: new Text("Older")),
				subtitle: (olderSchedule.length == 0) ? new Center(child: new Text("")) : null,
			));
			

      return olderSchedule;
    }

    return new ListView(
      children: <Widget>[
        new Card(
          child: new Column(
            children: getTodaySchedule(),
          ),
        ),
        new Card(
          child: new Column(
            children: getFutureSchedule(),
          ),
        ),
        new Card(
          child: new Column(
            children: getPastWeekSchedule(),
          ),
        ),
        new Card(
          child: new Column(
            children: getOlderSchedule(),
          ),
        ),
      ],
    );
  }
}

class MyLists extends StatelessWidget {
  MyLists(this.myLists, this.listItems, this.onListItemChanged);

  List<EventItem> myLists;
  Map<EventItem, List<MyListItem>> listItems;
  ListItemsChangedCallback onListItemChanged;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: myLists.map((EventItem event) {
        return new ListTile(
          title: new Text(event.title),
          subtitle: new Text(
              "${event.date.month}/${event.date.day}/${event.date.year}"),
          onTap: () async {
            List<MyListItem> newListOfList = await Navigator
                .of(context)
                .push(new MaterialPageRoute<List<MyListItem>>(
              builder: (BuildContext context) {
                return new ListPage(
                  listItems: itemLists[event],
                  listTitle: event.title,
                );
              },
            ));

            onListItemChanged(event, newListOfList);
          },
        );
      }).toList(),
    );
  }
}

//////
// Page for making new list
//////

class NewListPage extends StatefulWidget {
  @override
  _NewListPageState createState() => new _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  String _newListName;
  List<String> _savedListNames = <String>[
    "Don't Forget",
    "Shopping",
    "To-Do",
    "Work"
  ];

  @override
  void initState() {
    super.initState();
    // get _savedListNames from memory
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getListWidgets() {
      List<Widget> widgets = <Widget>[
        new Text(
          "CUSTOM LIST",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
        new Card(
            child: new Container(
                padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: new Column(children: <Widget>[
                  new TextField(
                    onChanged: (String value) {
                      _newListName = value;
                    },
                  ),
                  new Builder(
                    builder: (BuildContext context) {
                      return new RaisedButton(
                        child: new Text("CREATE LIST"),
                        onPressed: () {
                          if (_newListName != null) {
                            Navigator.of(context).pop(new EventItem(
                                title: _newListName, date: new DateTime.now()));
                          } else {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text("Your list needs a name"),
                                ));
                          }
                        },
                      );
                    },
                  )
                ]))),
        new Text(
          "QUICK LIST",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
      ];

      widgets.add(new Card(
        child: new Column(
          children: _savedListNames.map((String name) {
            return new ListTile(
              title: new Text(name),
              onTap: () {
                Navigator
                    .of(context)
                    .pop(new EventItem(title: name, date: new DateTime.now()));
              },
            );
          }).toList(),
        ),
      ));

      return widgets;
    }

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        title: new Text('New List'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.save_alt),
            onPressed: () {
              if (!_savedListNames.contains(_newListName) &&
                  _savedListNames != null) {
                setState(() {
                  _savedListNames.add(_newListName);
                });
              }
            },
          ),
        ],
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        children: getListWidgets(),
      ),
    );
  }
}

//TODO: Everything below this comment (It creates a page that allows the user to view the items within their individual lists
// NOTE: Code below is mostly borrowed from https://flutter.io/widgets-intro/ .
// This tutorial includes system for changing list items' states

class MyListItem {
  const MyListItem({this.title});
  final String title;
}

typedef void ListChangedCallback(MyListItem item, bool isDone);
typedef void ListItemsChangedCallback(EventItem event, List<MyListItem> list);

class MyListItemWidget extends StatelessWidget {
  MyListItemWidget({MyListItem item, this.isDone, this.onListChanged})
      : item = item,
        super(key: new ObjectKey(item));

  final MyListItem item;
  final bool isDone;
  final ListChangedCallback onListChanged;

  Color _getColor(BuildContext context) {
    return isDone ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!isDone) return null;

    return new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        onListChanged(item, !isDone);
      },
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(item.title[0]),
      ),
      title: new Text(item.title, style: _getTextStyle(context)),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.listItems, this.listTitle}) : super(key: key);

  final List<MyListItem> listItems;
  final String listTitle;

  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String _newListItemName;
  List<MyListItem> myListItems;
  Set<MyListItem> _list = new Set<MyListItem>();

  void _handleListChanged(MyListItem item, bool isDone) {
    setState(() {
      if (isDone)
        _list.add(item);
      else
        _list.remove(item);
    });
  }

  @override
  void initState() {
    super.initState();
    myListItems = widget.listItems;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[
      new Card(
          child: new Container(
              padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: new Column(children: <Widget>[
                new TextField(
                  onChanged: (String value) {
                    _newListItemName = value;
                  },
                ),
                new Builder(
                  builder: (BuildContext context) {
                    return new RaisedButton(
                      child: new Text("ADD"),
                      onPressed: () {
                        if (_newListItemName != null) {
                          setState(() {
                            myListItems
                                .add(new MyListItem(title: _newListItemName));
                          });
                        } else {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("Your List Item has no name!"),
                              ));
                        }
                      },
                    );
                  },
                )
              ]))),
    ];

    widgets.addAll(myListItems.map((MyListItem item) {
      return new MyListItemWidget(
        item: item,
        isDone: _list.contains(item),
        onListChanged: _handleListChanged,
      );
    }).toList());

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.listTitle),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.save),
            onPressed: () {
              Navigator.of(context).pop(myListItems);
            },
          ),
        ],
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widgets,
      ),
    );
  }
}
