import 'package:flutter/cupertino.dart';
import 'package:signin/api/firebase_api.dart';
import 'package:signin/model/task.dart';
import 'package:signin/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  void addTodo(Todo todo) => FirebaseApi.createTodo(todo);
  bool fetchdata = true;

  Future readTodo() {
    return FirebaseApi.readTodo();
  }

  Future AllTask(email) async {
    return await FirebaseApi.AllTask(email);
  }

  void removeTodo(String id, context) {
    FirebaseApi.deleteTodo(id, context);
    notifyListeners();
  }

  void updateTodo(String id, String title) {
    FirebaseApi.updateTodo(id, title);
    notifyListeners();
  }

  void removeSubTodo(String id, context) {
    FirebaseApi.deleteSubTodo(id, context);
    notifyListeners();
  }

  void addSubTodo(SubTask task) => FirebaseApi.createSubTodo(task);
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
