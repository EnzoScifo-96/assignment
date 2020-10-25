import 'package:Seller/helper/helperfunctions.dart';
import 'package:Seller/screen/wrapper.dart';
import 'package:Seller/service/auth.dart';
import 'package:Seller/service/database.dart';
import 'package:Seller/shared/constant.dart';
import 'package:Seller/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  // text field state
  String email = '';
  String password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.green[100],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text('Sign in to Seller CarEmerg'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
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
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password)
                                .then((result) async {
                              if (result != null) {
                                QuerySnapshot userInfoSnapshot =
                                    await DatabaseService().getUserInfo(
                                  email,
                                );

                                HelperFunctions
                                    .saveUserLoggedInSharedPreference(true);
                                HelperFunctions.saveUserNameSharedPreference(
                                    userInfoSnapshot.docs[0]
                                        .data()["userName"]);
                                HelperFunctions.saveUserEmailSharedPreference(
                                    userInfoSnapshot.docs[0]
                                        .data()["userEmail"]);
                                HelperFunctions
                                    .saveUserServicesSharedPreference(
                                        userInfoSnapshot.docs[0]
                                            .data()["services"]);
                                HelperFunctions.saveUserAreaSharedPreference(
                                    userInfoSnapshot.docs[0].data()["area"]);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper()));
                              } else {
                                setState(() {
                                  isLoading = false;
                                  //show snackbar
                                });
                              }
                            });
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
