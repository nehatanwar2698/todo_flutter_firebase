import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:signin/widget/logged_in.dart';
import 'package:signin/widget/signup.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return LoggedIn();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('something went wrong!'),
            );
          } else {
            return SignUpPage();
          }
        },
      ),
    );
  }
}
