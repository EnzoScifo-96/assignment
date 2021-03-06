import 'package:Seller/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:Seller/screen/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
        value: AuthService().user,
        child: MaterialApp(
          title: 'FlutterChat',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff145C9E),
            scaffoldBackgroundColor: Color(0xff1F1F1F),
            accentColor: Color(0xff007EF4),
            fontFamily: "OverpassRegular",
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Wrapper(),
        ));
  }
}
