import 'package:flutter/cupertino.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  DateTime createdTime;
  String title;
  String id;
  String userEmail;
  bool isDone;

  Todo({
    DateTime? createdTime,
    this.title = '',
    this.userEmail = '',
    this.id = '',
    this.isDone = false,
  }) : this.createdTime = createdTime ?? DateTime.now();

//when data fetch from firebase it is in json format so it map data json to  todo format
  static Todo fromJson(Map<String, dynamic> json) => Todo(
        createdTime: DateTime.parse(json['createdTime']),
        id: json['id'],
        title: json['title'],
        userEmail: json['userEmail'],
        isDone: json['isDone'],
      );
//upload to firebase  first convert into json then upload
  Map<String, dynamic> toJson() => {
        'createdTime':
            "${createdTime.year.toString().padLeft(4, '0')}-${createdTime.month.toString().padLeft(2, '0')}-${createdTime.day.toString().padLeft(2, '0')} ${createdTime.hour.toString().padLeft(2, '0')}:${createdTime.minute.toString().padLeft(2, '0')}",

        // 'description': description,
        'id': id,
        'title': title,
        'userEmail': userEmail,
        'isDone': isDone,
      };
}
