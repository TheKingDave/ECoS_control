import 'train/trainControl.dart';

import 'train/trainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'switches/switches.dart';

class ConnectedScreen extends StatefulWidget {
  final String ecosName;

  ConnectedScreen(this.ecosName);

  @override
  State<StatefulWidget> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen>
    with SingleTickerProviderStateMixin {
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
                    TrainScreen(),
                    Switches(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Theme.of(context).highlightColor,
                            width: 2))),
                child: TrainControl(),
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
