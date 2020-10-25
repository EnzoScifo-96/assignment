import 'package:Seller/helper/helperfunctions.dart';
import 'package:Seller/screen/wrapper.dart';
import 'package:Seller/service/auth.dart';
import 'package:Seller/service/database.dart';
import 'package:Seller/shared/constant.dart';
import 'package:Seller/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  DatabaseService databaseMethods = new DatabaseService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  // text field state
  String email = '';
  String password = '';
  String username = '';
  String services = '';
  String area = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.green[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text('Create an Account'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Username'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter an username' : null,
                      onChanged: (val) {
                        setState(() => username = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Service'),
                      validator: (val) =>
                          val.isEmpty ? 'State the services available' : null,
                      onChanged: (val) {
                        setState(() => services = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Area'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your area of operation' : null,
                      onChanged: (val) {
                        setState(() => area = val);
                      },
                    ),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    username, email, password);
                            Map<String, String> userDataMap = {
                              "userName": username,
                              "userEmail": email,
                              "services": services,
                              "area": area
                            };

                            databaseMethods.addUserInfo(userDataMap);
                            HelperFunctions.saveUserLoggedInSharedPreference(
                                true);
                            HelperFunctions.saveUserNameSharedPreference(
                                username);
                            HelperFunctions.saveUserEmailSharedPreference(
                                email);
                            HelperFunctions.saveUserServicesSharedPreference(
                                services);
                            HelperFunctions.saveUserAreaSharedPreference(area);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wrapper()));
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid email';
                              });
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
