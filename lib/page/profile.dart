import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:signin/UIConstant/theme.dart';

import 'package:signin/provider/google_signin.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIConstant.blue,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: UIConstant.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 35,
          ),
          SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        left: 10,
                        top: 10,
                        child: CircleAvatar(
                          maxRadius: 40,
                          backgroundImage: NetworkImage(user!.photoURL!),
                        )),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  user!.displayName!,
                  style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  user!.email!,
                  style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 15,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Total Task",
                                style: TextStyle(
                                    color: UIConstant.blue,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "15",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Finished Task",
                                style: TextStyle(
                                    color: UIConstant.blue,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                "20",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
