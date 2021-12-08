import 'package:flutter/cupertino.dart';
import 'package:signin/api/firebase_api.dart';
import 'package:signin/model/task.dart';
import 'package:signin/model/todo.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  // List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();

  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  void setTodos(List<Todo> todos) =>
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _todos = todos;
        notifyListeners();
      });

  void addTodo(Todo todo) => FirebaseApi.createTodo(todo);
  bool fetchdata = true;

  Future readTodo() {
    return FirebaseApi.readTodo();
  }

  void removeTodo(String id, context) {
    FirebaseApi.deleteTodo(id, context);
    notifyListeners();
  }

  void updateTodo(String id, String title) {
    FirebaseApi.updateTodo(id, title);
    notifyListeners();
  }

  void addSubTodo(Task task) => FirebaseApi.createSubTodo(task);
}
