import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signin/UIConstant/theme.dart';
import 'package:signin/page/add_task.dart';
import 'package:signin/page/profile.dart';
import 'package:signin/page/view_tasklist.dart';
import 'package:signin/provider/google_signin.dart';
import 'package:signin/provider/todo.dart';

class SubTask extends StatefulWidget {
  final String task_id;
  final String taskname;

  SubTask({Key? key, required this.task_id, required this.taskname})
      : super(key: key);

  @override
  State<SubTask> createState() => _SubTaskState();
}

class _SubTaskState extends State<SubTask> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome " + user!.displayName!),
        centerTitle: true,
        backgroundColor: UIConstant.blue,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_box,
              size: 38,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddTask()));
              print("Add  sub task");
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("tasklist")
            .where('mainTodoId', isEqualTo: widget.task_id.toString())
            .where('userEmail', isEqualTo: user!.email!)
            .where('isDone', isEqualTo: false)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError) return Text("Some Error Occur");
          if (querySnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 200.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
              ),
            );
          } else {
            final list = querySnapshot.data!.docs;

            print("list from here---$list");
            print(widget.task_id);

            return list.isEmpty
                ? Center(
                    child: Text(
                      "No Todos",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Sub Task Of  " + widget.taskname,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          children: list.map((DocumentSnapshot doc) {
                            bool done = doc['isDone'];
                            String date = doc['dateTime'];
                            DateTime d = DateTime.parse(date);
                            DateTime date_time = DateTime.now();
                            print(d);
                            print(d.isBefore(date_time)
                                ? "delayed"
                                : "not delayed");

                            print(d.isBefore(date_time));
                            return Padding(
                              padding: const EdgeInsets.only(top: 13.0),
                              child: Card(
                                color: d.isBefore(date_time)
                                    ? UIConstant.red
                                    : UIConstant.blue,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListTile(
                                  leading: Checkbox(
                                    activeColor: UIConstant.white,
                                    checkColor: UIConstant.blue,
                                    value: done,
                                    onChanged: (value) {
                                      bool newvalue = !done;
                                      print(newvalue);

                                      final docTodo = FirebaseFirestore.instance
                                          .collection('tasklist')
                                          .doc(doc['id'])
                                          .update({'isDone': newvalue})
                                          .then((value) =>
                                              print("task completed"))
                                          .catchError((error) => print(
                                              "Failed to update IsDone: $error"));

                                      print(docTodo);
                                      UIConstant.showSnackBar(
                                        context,
                                        newvalue
                                            ? 'Task completed'
                                            : 'Task marked incomplete',
                                      );

                                      // final provider =
                                      //     Provider.of<TodosProvider>(context,
                                      //         listen: false);
                                      // final isDone = provider
                                      //     .toggleTodoStatus(doc['isDone']);

                                      // Utils.showSnackBar(
                                      //   context,
                                      //   isDone ? 'Task completed' : 'Task marked incomplete',
                                      // );
                                    },
                                  ),
                                  title: Text(doc['subTask'],
                                      style: TextStyle(
                                          color: UIConstant.white,
                                          fontSize: 24)),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      doc['dateTime'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  trailing: Wrap(
                                    spacing: 12, // space between two icons
                                    children: <Widget>[
                                      // IconButton(
                                      //     icon: Icon(
                                      //       Icons.edit,
                                      //       color: UIConstant.white,
                                      //     ),
                                      //     onPressed: () {
                                      //       //  _editList(context,
                                      //       //         list[index]['id'], list[index]['title']),
                                      //     }), // icon-1
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: UIConstant.white,
                                        ),
                                        onPressed: () async {
                                          await showAlertDialog(
                                              context, doc['id']);
                                        },
                                      ), // icon-2
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
//delete sub task....

  showAlertDialog(BuildContext context, dynamic id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text(
        "CANCEL",
        style: TextStyle(
            color: UIConstant.blue, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "DELETE",
        style: TextStyle(
            color: UIConstant.blue, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onPressed: () {
        print("delete ");
        // final todo = Todo();

        final provider = Provider.of<TodosProvider>(context, listen: false);
        provider.removeSubTodo(id, context);

        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Are you sure?",
        style: TextStyle(
            color: UIConstant.blue, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: const Text("All task from the list will also be deleted"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
