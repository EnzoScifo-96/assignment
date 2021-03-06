import 'package:Seller/models/user.dart';
import 'package:Seller/service/database.dart';
import 'package:Seller/shared/constant.dart';
import 'package:Seller/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String _currentUserName;
  String _currentServices;
  String _currentArea;

  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
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
                    initialValue: userData.username,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentUserName = val),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: userData.services,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please state your services' : null,
                    onChanged: (val) => setState(() => _currentServices = val),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: userData.area,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter your region' : null,
                    onChanged: (val) => setState(() => _currentArea = val),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentServices ?? snapshot.data.services,
                            _currentUserName ?? snapshot.data.username,
                            _currentArea ?? snapshot.data.area,
                          );
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
