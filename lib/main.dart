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

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = new PageController();
  /*TabController _tabController = new TabController(
    length: 2,
    vsync: ,
  );*/

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
          tabs: <Widget> [
            new Tab(
              text: 'Lists',
              icon: new Icon(Icons.dehaze),
            ),
            new Tab(
              text: 'Schedule',
              icon: new Icon(Icons.event),
            )
          ],
          indicatorColor: Colors.red[500],
        ),
      ),
      body: new PageView(
          controller: _pageController,
          physics: new PageScrollPhysics(),
          children: <Widget>[
            new Center(
              child: new Text("Page 0"),
            ),
            new Center(
              child: new Text("Page 1"),
            ),
          ],
      ),
        floatingActionButton: new FloatingActionButton(
            onPressed: null,
            child: new Icon(Icons.add),
        ),
    );
  }

  void changePage<int>(int value) {
    _controller.animateToPage(value);
    //print('Page Changed');
    return;
  }
}

