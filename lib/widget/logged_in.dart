import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:signin/UIConstant/theme.dart';
import 'package:signin/page/add_task.dart';
import 'package:signin/provider/todo.dart';
import 'package:signin/widget/sub_task.dart';
import 'package:signin/page/view_tasklist.dart';
import 'package:signin/page/profile.dart';
import 'package:signin/provider/google_signin.dart';

class LoggedIn extends StatefulWidget {
  const LoggedIn({Key? key}) : super(key: key);

  @override
  _LoggedInState createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    // print(user);
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome " + user!.displayName!),
        centerTitle: true,
        backgroundColor: UIConstant.blue,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(bodyColor: Colors.black),
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              color: UIConstant.blue,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Profile")
                      ],
                    )),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Tasks List")
                      ],
                    )),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Logout")
                      ],
                    )),
              ],
              onSelected: (item) => SelectedItem(context, item),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("todo")
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError) return Text("Some Error Occur");
          if (querySnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final list = querySnapshot.data!.docs;
            print("list from here---$list");
//
            return Container(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: Card(
                        color: UIConstant.blue,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(list[index]['title'],
                              style: TextStyle(
                                  color: UIConstant.white, fontSize: 22)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainList(
                                    task_id: list[index]['id'],
                                    taskname: list[index]['title']),
                              ),
                            );
                          },

                          // children: _getChildren(mainTask.length,
                        ),
                      ),
                    );
                  }),
            );
          }
        },
      )
      // body: SingleChildScrollView(
      //   child: SafeArea(
      //     child: Column(
      //       children: [
      //         Card(
      //           margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 Expanded(
      //                   child: Column(
      //                     children: [
      //                       Text(
      //                         "Total Task",
      //                         style: TextStyle(
      //                             color: UIConstant.blue,
      //                             fontSize: 18.0,
      //                             fontWeight: FontWeight.w600),
      //                       ),
      //                       SizedBox(
      //                         height: 7,
      //                       ),
      //                       Text(
      //                         "15",
      //                         style: TextStyle(
      //                             color: Colors.black,
      //                             fontSize: 18.0,
      //                             fontWeight: FontWeight.w300),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //                 Expanded(
      //                   child: Column(
      //                     children: [
      //                       Text(
      //                         "Finished Task",
      //                         style: TextStyle(
      //                             color: Colors.black54,
      //                             fontSize: 18.0,
      //                             fontWeight: FontWeight.w600),
      //                       ),
      //                       SizedBox(
      //                         height: 7,
      //                       ),
      //                       Text(
      //                         "20",
      //                         style: TextStyle(
      //                             color: Colors.black,
      //                             fontSize: 18.0,
      //                             fontWeight: FontWeight.w300),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      ,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTask()));
          print("Add task");
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
        backgroundColor: UIConstant.blue,
      ),
    );
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Profile()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ViewTask()));
        print("Add task");

        break;
      case 2:
        print("User Logged out");

        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.logout(context);

        break;
    }
  }
}
