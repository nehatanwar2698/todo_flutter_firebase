import 'package:cloud_firestore/cloud_firestore.dart';
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
    var collection = FirebaseFirestore.instance.collection('todo');

    var querySnapshot = await collection.get();
    List<dynamic> taskList = [];

    List<QueryDocumentSnapshot> list = querySnapshot.docs;

    print("list--$list");
    return list;
  }

  static deleteTodo(String todoId) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todoId);
    print("doctodo $docTodo");

    await docTodo.delete();
  }

  static void updateTodo(Todo todo) async {
    final docTodo = FirebaseFirestore.instance.collection('todo').doc(todo.id);

    await docTodo.update(todo.toJson());
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
