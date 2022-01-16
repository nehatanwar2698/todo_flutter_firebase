import 'package:flutter/cupertino.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class SubTask {
  String id;
  String mainTodoId;
  String subTask;
  bool isDone;
  DateTime createdTime;
  String userEmail;
  String dateTime;

  SubTask(
      {this.id = '',
      this.mainTodoId = '',
      this.subTask = '',
      this.isDone = false,
      DateTime? createdTime,
      this.userEmail = '',
      this.dateTime = ''})
      : this.createdTime = createdTime ?? DateTime.now();

//upload to firebase  first convert into json then upload
  Map<String, dynamic> toJson() => {
        // 'description': description,
        'id': id,
        'mainTodoId': mainTodoId,
        'subSubTask': subTask,
        'isDone': isDone,
        'createdTime':
            "${createdTime.year.toString().padLeft(4, '0')}-${createdTime.month.toString().padLeft(2, '0')}-${createdTime.day.toString().padLeft(2, '0')} ${createdTime.hour.toString().padLeft(2, '0')}:${createdTime.minute.toString().padLeft(2, '0')}",
        'userEmail': userEmail,
        'dateTime': dateTime
      };
}
