import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signin/UIConstant/theme.dart';
import 'package:signin/model/todo.dart';
import 'package:signin/provider/todo.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({Key? key}) : super(key: key);

  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _textFieldController = TextEditingController();
  late TextEditingController _editFieldController;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    var readTodo = provider.readTodo();

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
          title: Text("Tasks List"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_box,
                size: 38,
              ),
              onPressed: () {
                _addList(context);
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
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
              print("list from here---$list");
//
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
                            // subtitle: Text(
                            //   'Task 1',
                            //   style: TextStyle(color: Color(0XFFA569BD)),
                            // ),
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
        ));
  }

//add list
  _addList(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
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
                },
              ),
              TextButton(
                child: const Text(
                  'Add',
                  style: TextStyle(color: UIConstant.blue, fontSize: 18),
                ),
                onPressed: () {
                  if (_textFieldController.text.isEmpty) {
                    return UIConstant().ToastMassage("enter task list");
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
    setState(() {
      _editFieldController = TextEditingController(
        text: todoTitle,
      );
    });
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Edit List',
              style: TextStyle(
                  color: UIConstant.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            content: TextField(
              controller: _editFieldController,
            ),
            actions: <Widget>[
              TextButton(
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
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: UIConstant.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                onPressed: () {
                  // print("idd---$todoId");
                  // print(("editcontroller--${_editFieldController.text}"));
                  final provider =
                      Provider.of<TodosProvider>(context, listen: false);
                  provider.updateTodo(todoId, _editFieldController.text);

                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

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
        provider.removeTodo(id, context);

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

  //delete list

}
