import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:signin/provider/google_signin.dart';

class LoggedIn extends StatefulWidget {
  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      appBar: AppBar(
        title: Text('Logged In'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Logout',
              ))
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Welcome " + user!.displayName!,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              maxRadius: 30,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            const SizedBox(height: 6),
            Text(
              'Name: ' + user!.displayName!,
            ),
            SizedBox(height: 12),
            Text(
              'Email: ' + user!.email!,
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              icon: FaIcon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.red,
              ),
              label: Text('Logout'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.blue,
                    content: Text('Logout'),
                    duration: Duration(seconds: 1),
                  ),
                );
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                // print('Button Pressed');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
