import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signin/UIConstant/theme.dart';
import 'package:signin/model/task.dart';
import 'package:signin/model/todo.dart';

class FirebaseApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<String> createTodo(Todo todo) async {
    print('added to firebase');
    final docTodo = FirebaseFirestore.instance.collection('todo').doc();

    todo.id = docTodo.id;
    await docTodo.set(todo.toJson());

    return docTodo.id;
  }

  static Future readTodo() async {
    var collection =
        FirebaseFirestore.instance.collection('todo').orderBy('createdTime');

    var querySnapshot = await collection.get();
    List<dynamic> taskList = [];

    List<QueryDocumentSnapshot> list = querySnapshot.docs.toList();

    print("list--$list");
    return list;
  }

  static deleteTodo(String todoId, context) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todoId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: UIConstant.blue,
        content: Text('Task Deleted'),
        duration: Duration(seconds: 1),
      ),
    );
    print("doctodo $docTodo");

    await docTodo
        .delete()
        .then((value) => print("Task Deleted"))
        .catchError((error) => print("Failed to delete Task: $error"));
  }

  static void updateTodo(String id, String title) async {
    final docTodo = FirebaseFirestore.instance
        .collection('todo')
        .doc(id)
        .update({'title': title})
        .then((value) => print("Task Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //sub task
  static Future<String> createSubTodo(Task task) async {
    print('Sub task  to firebase');
    final docTodo = FirebaseFirestore.instance.collection('tasklist').doc();

    task.id = docTodo.id;
    await docTodo
        .set(task.toJson())
        .then((value) => print("Sub Task Added"))
        .catchError((error) => print("Failed to add Sub Task: $error"));

    return docTodo.id;
  }
}
 





  // static Future<Todo> readTodo(Todo todo) async {
  //   var db = FirebaseFirestore.instance.collection('todo');
  //   var querySnapshot = await db.get();
  //   print("query---$querySnapshot");
  //   List<QueryDocumentSnapshot> list = querySnapshot.docs;
  //   print("hiii----$list");

  //   for (var queryDocumentSnapshot in querySnapshot.docs) {
  //     Map<String, dynamic> data = queryDocumentSnapshot.data();
  //     print(data);
  //     var id = data['id'];
  //     var title = data['title'];
  //     print("id--$id");
  //     print("title--$title");
  //   }
  //   return;
  // }
