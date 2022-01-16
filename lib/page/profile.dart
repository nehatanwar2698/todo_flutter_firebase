import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:signin/UIConstant/theme.dart';
import 'package:signin/api/firebase_api.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  File? _image;
  String? newImage;
  var mainId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 35,
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(color: Colors.red[200]),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(
                          // decoration: BoxDecoration(color: Colors.red[200]),
                          width: 200,
                          height: 200,
                          child: newImage == null
                              ? Image.network(user!.photoURL!)
                              : Image.network(newImage!),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: UIConstant.blue, // background
                          // onPrimary: Colors.yellow, // foreground
                        ),
                        onPressed: () async {
                          chooseImage();
                          print("select image");

                          // XFile? image = await ImagePicker()
                          //     .pickImage(source: ImageSource.gallery);

                          // setState(() {
                          //   _image = File(image!.path);
                          // });
                        },
                        child: Text(
                          "Select Image",
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: UIConstant.blue, // background
                          // onPrimary: Colors.yellow, // foreground
                        ),
                        onPressed: () async {
                          updateProfile(context);
                          print("update image");
                          print("new image $newImage");
                          _image == null
                              ? ""
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Uploaded successfully  !!',
                                    ),
                                  ),
                                );

                          // XFile? image = await ImagePicker()
                          //     .pickImage(source: ImageSource.gallery);

                          // setState(() {
                          //   _image = File(image!.path);
                          // });
                        },
                        child: Text(
                          "Update Profile",
                        ))
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  user!.displayName!,
                  style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  user!.email!,
                  style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("tasklist")
                      .where('isDone', isEqualTo: true)
                      .where('userEmail', isEqualTo: user!.email!)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> querySnapshot1) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("tasklist")
                          // .where('isDone', isEqualTo: false)
                          .where('userEmail', isEqualTo: user!.email!)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> querySnapshot2) {
                        if (querySnapshot1.hasError)
                          return Text("Some Error Occur");
                        if (querySnapshot2.hasError)
                          return Text("Some Error Occur");
                        if (querySnapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 200.0,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black45),
                            ),
                          );
                        } else {
                          final completeTaskList = querySnapshot1.data!.docs;
                          final TotalTaskList = querySnapshot2.data!.docs;
                          TotalTaskList.map((e) {
                            // print(e['id']);
                            mainId = e['mainTodoId'];
                          }).toList();

                          // print("complete task---$completeTaskList");
                          // print("Pending task---$PendingTaskList");

                          return Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Total  Task",
                                            style: TextStyle(
                                                color: UIConstant.blue,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            TotalTaskList == null
                                                ? ''
                                                : TotalTaskList.length
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Finished Task",
                                            style: TextStyle(
                                                color: UIConstant.blue,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            completeTaskList.length.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  chooseImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    print("image-" + image!.path);
    _image = File(image.path);
    setState(() {});
  }

  Future updateProfile(Context) async {
    if (_image == null) return;
    final filename = basename(_image!.path);
    final destination = 'profile/$filename';
    print(destination);
    UploadTask task = FirebaseApi.uploadFile(destination, _image!);

    print("imageurl--$task");
    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');

    print("mainid---$mainId");

    final docTodo = FirebaseFirestore.instance
        .collection('todo')
        .doc(mainId)
        .update({'userProfile': urlDownload})
        .then((value) => print("Image Updated on firestore"))
        .catchError((error) => print("Failed to update Image: $error"));
    setState(() {
      newImage = urlDownload;
      print("new image $newImage");
    });
  }
}





 // Stack(
                //   children: [
                //     // Container(
                //     //   width: 120,
                //     //   height: 120,
                //     //   decoration: BoxDecoration(
                //     //     border: Border.all(
                //     //         width: 4,
                //     //         color: Theme.of(context).scaffoldBackgroundColor),
                //     //     boxShadow: [
                //     //       BoxShadow(
                //     //           spreadRadius: 2,
                //     //           blurRadius: 10,
                //     //           color: Colors.black.withOpacity(0.1),
                //     //           offset: Offset(0, 10))
                //     //     ],
                //     //     shape: BoxShape.circle,
                //     //   ),
                //     // ),
                //     _image == null
                //         ? Positioned(
                //             bottom: 10,
                //             right: 10,
                //             left: 10,
                //             top: 10,
                //             child: Image.network(user!.photoURL!),
                //             // child: CircleAvatar(
                //             //   maxRadius: 40,
                //             //   backgroundImage: NetworkImage(user!.photoURL!),
                //             // )
                //           )
                //         : Positioned(
                //             bottom: 10,
                //             right: 10,
                //             left: 10,
                //             top: 10,
                //             child: Image.file(
                //               _image!,
                //               width: 200.0,
                //               height: 200.0,
                //               fit: BoxFit.fitHeight,
                //             )),
                //   ],
                // ),