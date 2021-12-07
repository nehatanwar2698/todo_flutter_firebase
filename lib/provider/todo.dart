import 'package:flutter/cupertino.dart';
import 'package:signin/api/firebase_api.dart';
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

  Future readTodo() => FirebaseApi.readTodo();

  void removeTodo(String id) {
    FirebaseApi.deleteTodo(id);
    notifyListeners();
  }

  void updateTodo(Todo todo, String title) {
    todo.title = title;

    FirebaseApi.updateTodo(todo);
    notifyListeners();
  }

  // bool toggleTodoStatus(Todo todo) {
  //   todo.isDone = !todo.isDone;
  //   FirebaseApi.updateTodo(todo);

  //   return todo.isDone;
  // }

  // void updateTodo(Todo todo, String title, String description) {
  //   todo.title = title;
  //   todo.description = description;

  //   FirebaseApi.updateTodo(todo);
  // }

}
