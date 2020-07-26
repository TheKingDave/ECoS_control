import 'package:ecos_control/switchIcon.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatelessWidget {
  final int _selectedIndex;
  final Function(int) _onItemTap;
  
  MainNavigation(this._selectedIndex, this._onItemTap);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.train),
          title: Text('Train')
        ),
        BottomNavigationBarItem(
          icon: SwitchIcon(),
          title: Text('Switch')
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTap,
    );
  }
  
  
}