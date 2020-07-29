import 'package:ecos_control/connectedScreen.dart';
import 'package:ecos_control/switches/switches.dart';
import 'package:ecos_control/unconnectedScreen.dart';

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
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return UnconnectedScreen();
  }
}
