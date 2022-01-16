import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:signin/UIConstant/theme.dart';
import 'package:signin/widget/sub_task_list.dart';

class TodoListWidget extends StatefulWidget {
  TodoListWidget({Key? key}) : super(key: key);

  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("todo")
            .where('userEmail', isEqualTo: user!.email!)
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError) return Text("Some Error Occur");
          if (querySnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final list = querySnapshot.data!.docs;
            // print("list from here---$list");

//
            return list.isEmpty
                ? Center(
                    child: Text(
                      'No Todos',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Container(
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
                                      builder: (context) => SubTask(
                                        task_id: list[index]['id'],
                                        taskname: list[index]['title'],
                                      ),
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
      ),
    );
  }
}
