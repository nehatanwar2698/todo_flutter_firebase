import 'package:flutter/cupertino.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  String title;
  String id;
  String userEmail;
  bool isDone;
  String userProfile;
  DateTime createdTime;

  Todo(
      {DateTime? createdTime,
      this.title = '',
      this.userEmail = '',
      this.id = '',
      this.isDone = false,
      this.userProfile = ''})
      : this.createdTime = createdTime ?? DateTime.now();

//when data fetch from firebase it is in json format so it map data json to  todo format
  static Todo fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        userEmail: json['userEmail'],
        userProfile: json['userProfile'],
        isDone: json['isDone'],
        createdTime: DateTime.parse(json['createdTime']),
      );
//upload to firebase  first convert into json then upload
  Map<String, dynamic> toJson() => {
        // 'description': description,
        'id': id,
        'title': title,
        'userEmail': userEmail,
        'isDone': isDone,
        'userProfile': userProfile,
        'createdTime':
            "${createdTime.year.toString().padLeft(4, '0')}-${createdTime.month.toString().padLeft(2, '0')}-${createdTime.day.toString().padLeft(2, '0')} ${createdTime.hour.toString().padLeft(2, '0')}:${createdTime.minute.toString().padLeft(2, '0')}",
      };
}
