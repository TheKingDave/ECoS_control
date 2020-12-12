import 'package:flutter/services.dart';

import 'station.dart';
import 'package:flutter/material.dart';

class AddStationDialog extends StatefulWidget {
  _AddStationDialogState createState() => _AddStationDialogState();
}

class _AddStationDialogState extends State<AddStationDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  TextEditingController _addressController;
  TextEditingController _portController;

  FocusNode _addressFocus;
  FocusNode _portFocus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _portController =
        TextEditingController(text: StationInfo.defaultPort.toString());

    _addressFocus = FocusNode();
    _portFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _portController.dispose();

    _addressFocus.dispose();
    _portFocus.dispose();

    super.dispose();
  }

  void submitData(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final station = StationInfo(
        name: _nameController.text,
        address: _addressController.text,
        port: int.parse(_portController.text));
    Navigator.of(context).pop(station);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ECoS Station'),
        actions: <Widget>[
          FlatButton(
              child:
                  Text('Add', style: Theme.of(context).primaryTextTheme.button),
              onPressed: () => submitData(context))
        ],
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _addressFocus.requestFocus(),
              autofocus: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _portFocus.requestFocus(),
              focusNode: _addressFocus,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _portController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(labelText: 'Port'),
              textInputAction: TextInputAction.done,
              focusNode: _portFocus,
              onFieldSubmitted: (_) => submitData(context),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a port';
                }
                final port = int.parse(value);
                if (port < 0 || port > 65535) {
                  return 'The port must be between 0 and 65535';
                }
                return null;
              },
            )
          ],
        ),
      ),
    );
  }
}
