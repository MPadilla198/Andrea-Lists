import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Andrea\'s Lists',
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
      home: new MyHomePage(title: 'Andrea\'s Lists'),
      //showPerformanceOverlay: true,
    );
  }
}

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(
      text: 'Lists',
      icon: new Icon(Icons.dehaze),
    ),
    new Tab(
      text: 'Schedule',
      icon: new Icon(Icons.event),
    )
  ];

  List<EventItem> myLists = [
    new EventItem(title: "Hello", date: new DateTime.now()),
    new EventItem(title: "World", date: new DateTime.now()),
    new EventItem(title: "DEADBEEF", date: new DateTime.now()),
  ];
  List<EventItem> mySchedule = [
    new EventItem(title: "Hello", date: new DateTime.now()),
    new EventItem(title: "World", date: new DateTime.now()),
    new EventItem(title: "DEADBEEF", date: new DateTime.now()),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
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
        title: new Text(config.title),
        bottom: new TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: new TabBarView(
          controller: _tabController,
          children: <Widget> [
            new MyLists(myLists),
            new MySchedule(mySchedule),
          ],
      ),
        floatingActionButton: new FloatingActionButton(
            onPressed: floatingActionButtonOnPress(),
            child: new Icon(Icons.add),
        ),
    );
  }

  void floatingActionButtonOnPress() {
    // TODO: Implement onPressed
  }
}

class EventItem {
  EventItem({@required this.title, this.date});

  String title;
  DateTime date;

  bool hasDate() {
    return date == null;
  }

  void setDate(DateTime date) {
    this.date = date;
  }
}

/*
class MySchedule extends StatefulWidget {
  MySchedule({Key key, this.lists}) : super(key: key);

  final List<EventItem> schedule;

  @override
  _MyScheduleState createState() => new _MyScheduleState();
}*/

class MySchedule extends StatelessWidget {
  MySchedule(this.schedule);

  List<EventItem> schedule;

  List<Widget> getTodaySchedule() {
    List<Widget> todaySchedule = [new ListTile(title: new Center(child: new Text("Today")))];

    todaySchedule.addAll(
        schedule.map((EventItem event) {
          if(event.date.day == new DateTime.now().day &&
              event.date.month == new DateTime.now().month &&
              event.date.year == new DateTime.now().year) {
            return new ListTile(
                title: new Text(event.title),
                subtitle: new Text("${event.date.month}/${event.date.day}/${event.date.year}"),
                onTap: null,
            );
          }
        }).toList()
    );

    return todaySchedule;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Card(
          child: new Column(
            children: getTodaySchedule(),
          ),
        ),
      ],
    );
  }
}

class MyLists extends StatelessWidget {
  MyLists(this.myLists);

  List<EventItem> myLists;

  Widget build(BuildContext context) {
    return new ListView(
      children: myLists.map((EventItem event) {
        return new ListTile(
          title: new Text(event.title),
          subtitle: new Text("${event.date.month}/${event.date.day}/${event.date.year}"),
          onTap: null,
        );
      }).toList(),
    );
  }
}