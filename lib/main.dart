import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:signin/page/home_page.dart';
import 'package:signin/provider/google_signin.dart';
import 'package:signin/provider/todo.dart';
import 'package:signin/widget/signup.dart';

Future main() async {
  Provider.debugCheckInvalidValueType = null;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
        Provider<TodosProvider>(create: (_) => TodosProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto-Regular',
        ),
        home: HomePage(),
      ),
    );
  }
}
