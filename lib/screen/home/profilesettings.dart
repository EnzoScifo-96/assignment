import 'package:Seller/shared/constant.dart';

import 'package:flutter/material.dart';

class SettingsForm2 extends StatefulWidget {
  @override
  _SettingsForm2State createState() => _SettingsForm2State();
}

class _SettingsForm2State extends State<SettingsForm2> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentUserName;
  String _currentServices;
  String _currentArea;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Update your Profile.',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) => val.isEmpty ? 'Please enter a name' : null,
            onChanged: (val) => setState(() => _currentUserName = val),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) =>
                val.isEmpty ? 'Please state your services' : null,
            onChanged: (val) => setState(() => _currentServices = val),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            decoration: textInputDecoration,
            validator: (val) => val.isEmpty ? 'Please enter your region' : null,
            onChanged: (val) => setState(() => _currentArea = val),
          ),
          SizedBox(height: 10.0),
          RaisedButton(
              color: Colors.pink[400],
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {}),
        ],
      ),
    );
  }
}
