import 'package:ecos_control/switches/switches.dart';

import 'consts.dart';
import 'train/demoTrainControl.dart';
import 'train/trainFunctions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor swatch = Colors.blue;

    return MaterialApp(
      title: 'ECoS Control',
      theme: ThemeData(
        primarySwatch: swatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: swatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,

        // fix dark theme issues
        primaryColor: swatch,
        primaryColorLight: swatch[100],
        primaryColorDark: swatch[700],
        toggleableActiveColor: swatch[600],
        accentColor: swatch[500],
      ),
      themeMode: ThemeMode.dark,
      home: MainPage(title: 'ECoS Control'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> _tabs = <Tab>[
    Tab(text: 'Trains', icon: Icon(Icons.train)),
    Tab(text: 'Switches', icon: Icon(Icons.call_split)),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TrainFunctions(),
                  Switches(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Theme.of(context).highlightColor, width: 2))),
              child: DemoTrainControl(
                number: 24,
                protocol: "DCC 128",
                name: "Schnelli",
                speed: 28,
                maxSpeed: 128,
                direction: Direction.forward,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
