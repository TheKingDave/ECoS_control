import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'consts.dart';
import 'switches/switches.dart';
import 'train/demoTrainControl.dart';
import 'train/trainFunctions.dart';

class ConnectedScreen extends StatefulWidget {
  final String ecosName;
  
  ConnectedScreen(this.ecosName);
  
  @override
  State<StatefulWidget> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> with SingleTickerProviderStateMixin {
  static List<Tab> _tabs = <Tab>[
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
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.ecosName),
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
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
}