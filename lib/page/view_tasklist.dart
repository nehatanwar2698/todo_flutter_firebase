import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:signin/UIConstant/theme.dart';
import 'package:signin/model/todo.dart';

import 'package:signin/provider/google_signin.dart';
import 'package:signin/provider/todo.dart';

class ViewTask extends StatefulWidget {
  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  final todo = Todo();
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _editFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context, listen: false);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: UIConstant.blue,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: UIConstant.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Tasks List"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_box,
                size: 38,
              ),
              onPressed: () => _addList(context),
            )
          ],
        ),
        body: Container(
            child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("todo")
              .orderBy('createdTime', descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {
            if (querySnapshot.hasError) return Text("Some Error Occur");
            if (querySnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final list = querySnapshot.data!.docs;

              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: UIConstant.blue,
                          child: ListTile(
                            title: Text(
                              list[index]['title'],
                              style: TextStyle(
                                  color: UIConstant.white, fontSize: 22),
                            ),
                            subtitle: Text(
                              'Task 1',
                              style: TextStyle(color: Color(0XFFA569BD)),
                            ),
                            trailing: Wrap(
                              spacing: 12, // space between two icons
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: UIConstant.white,
                                  ),
                                  onPressed: () => _editList(context,
                                      list[index]['id'], list[index]['title']),
                                ), // icon-1
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: UIConstant.white,
                                  ),
                                  onPressed: () async {
                                    await showAlertDialog(
                                        context, list[index]['id']);
                                    print("Confirm Action");
                                  },
                                ), // icon-2
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        )));
  }

//add list
  _addList(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'New List',
              style: TextStyle(
                  color: UIConstant.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter List name"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // final provider =
                  //     Provider.of<TodosProvider>(context, listen: false);

                  // var readTodo = provider.readTodo();
                  // print(readTodo);
                },
              ),
              TextButton(
                child: Text(
                  'Add',
                  style: TextStyle(color: UIConstant.blue, fontSize: 18),
                ),
                onPressed: () {
                  // print(" added list ---" + _textFieldController.text);
                  if (_textFieldController.text.isEmpty) {
                    return;
                    // UIConstant.VMSToastMassage("Enter List Name");
                  } else {
                    final todo = Todo(
                      id: DateTime.now().toString(),
                      title: _textFieldController.text,
                      userEmail: user!.email!,
                      createdTime: DateTime.now(),
                    );
                    final provider =
                        Provider.of<TodosProvider>(context, listen: false);
                    provider.addTodo(todo);
                    _textFieldController.clear();

                    Navigator.of(context).pop();
                  }
                  // Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

//edit list
  _editList(BuildContext context, todoId, todoTitle) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit List',
              style: TextStyle(
                  color: UIConstant.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            content: TextField(
              controller: _editFieldController,
              decoration: InputDecoration(
                  // hintText: todoTitle,
                  ),
            ),
            actions: <Widget>[
              new TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: UIConstant.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: UIConstant.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                onPressed: () {
                  print("idd---$todoId");
                  final provider =
                      Provider.of<TodosProvider>(context, listen: false);
                  provider.updateTodo(todo, todo.title);

                  // Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  showAlertDialog(BuildContext context, dynamic id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "CANCEL",
        style: TextStyle(
            color: UIConstant.blue, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "DELETE",
        style: TextStyle(
            color: UIConstant.blue, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onPressed: () {
        print("delete ");
        // final todo = Todo();

        final provider = Provider.of<TodosProvider>(context, listen: false);
        provider.removeTodo(id);

        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Are you sure?",
        style: TextStyle(
            color: UIConstant.blue, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Text("all task from the list will also be deleted"),
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

  //delete list

}
