import 'switchDisplay.dart';
import 'switchListState.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Switches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final con = Provider.of<SwitchListState>(context);

    return GridView.count(
      childAspectRatio: 59 / 100,
      crossAxisCount: 4,
      padding: EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: con.switches
          .map((e) =>
              ChangeNotifierProvider.value(value: e, child: SwitchDisplay()))
          .toList(growable: false),
    );
  }
}
