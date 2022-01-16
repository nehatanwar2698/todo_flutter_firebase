import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signin/UIConstant/theme.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:signin/model/task.dart';
import 'package:signin/provider/todo.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState   createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  User? user = FirebaseAuth.instance.currentUser;
  var _category;

  String valueChanged1 = DateTime.now().toString();

  String _valueSaved1 = '';
  TextEditingController _addTaskFieldController = TextEditingController();

  @override
  void initState() {
    String valueChanged1 = DateTime.now().toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
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
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: EdgeInsets.all(18.0),
            child: TextField(
              controller: _addTaskFieldController,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(bottom: 13),
                labelText: 'What is to be done?',
                hintStyle: TextStyle(height: 2, fontWeight: FontWeight.bold),
                hintText: 'Enter Task Here',
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 23, top: 20, bottom: 15),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Add to List",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('todo')
                      .where('userEmail', isEqualTo: user!.email!)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(
                        child: const CupertinoActivityIndicator(),
                      );

                    return Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                      child: DropdownButton(
                        hint: Text("Select Task",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        value: _category,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            _category = newValue;
                            var dropDown = false;
                            print("category " + _category);
                          });
                        },
                        icon: const Icon(Icons.arrow_downward),
                        iconEnabledColor: UIConstant.blue,
                        iconSize: 24,
                        elevation: 8,
                        isExpanded: true,
                        style: const TextStyle(
                          color: UIConstant.blue,
                          fontSize: 20,
                        ),
                        underline: Container(
                          height: 1,
                          color: Colors.black38,
                        ),
                        items: snapshot.data?.docs.map((document) {
                          return new DropdownMenuItem<String>(
                              value: (document.data() as dynamic)['id'] ?? '',
                              child: new Text(
                                (document.data() as dynamic)['title'],
                                style: TextStyle(fontSize: 20),
                              ));
                        }).toList(),
                      ),
                    );
                  })
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 23, top: 20, bottom: 15),
            alignment: Alignment.bottomLeft,
            child: Text(
              " Date & Time",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              // dateMask: 'yyyy,MMM,d',
              dateMask: 'd/MMM/yyyy',
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              // use24HourFormat: false,
              selectableDayPredicate: (date) {
                // Disable weekend days to select from the calendar
                // if (date.weekday == 6 || date.weekday == 7) {
                //   return false;
                // }

                return true;
              },
              onChanged: (val) {
                setState(() {
                  valueChanged1 = val;
                  print("date and time ${valueChanged1}");
                });
              },
              // validator: (val) {
              //   setState(() => _valueToValidate1 = val);
              //   return null;
              // },
              onSaved: (val) => setState(() => _valueSaved1 = val!),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                padding: EdgeInsets.symmetric(horizontal: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("CANCEL",
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
              ),
              RaisedButton(
                onPressed: () {
                  if (validate()) {
                    final task = SubTask(
                      id: DateTime.now().toString(),
                      mainTodoId: _category,
                      subTask: _addTaskFieldController.text,
                      createdTime: DateTime.now(),
                      dateTime: valueChanged1,
                      userEmail: user!.email!,
                    );
                    final provider =
                        Provider.of<TodosProvider>(context, listen: false);
                    provider.addSubTodo(task);

                    _addTaskFieldController.clear();

                    Navigator.of(context).pop();
                    // print(valueChanged1);
                    // print(_addTaskFieldController.text.toString());
                    // print(_category);
                  }
                },
                color: UIConstant.blue,
                padding: EdgeInsets.symmetric(horizontal: 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  bool validate() {
    if (_addTaskFieldController.text.isEmpty) {
      UIConstant().ToastMassage("enter task at First");
      return false;
    } else if (_category == null) {
      UIConstant().ToastMassage("Please Choose list");
      return false;
    }
    return true;
  }
}
