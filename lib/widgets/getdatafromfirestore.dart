// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GetDataFromFirestore({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<GetDataFromFirestore> createState() => _GetDataFromFirestoreState();
}

class _GetDataFromFirestoreState extends State<GetDataFromFirestore> {
  final usercontroler = TextEditingController();
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  myDailog(Map data, dynamic mykey) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            child: Container(
              height: 200,
              padding: EdgeInsets.all(25),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: usercontroler,
                      decoration: InputDecoration(
                        hintText: "Enter updated value",
                      ),
                      //${data["age"]}
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                users
                                    .doc(widget.documentId)
                                    .update({mykey: usercontroler.text});
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "cancel",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                        ])
                  ]),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Email: ${data['email']}",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete)),
                          IconButton(
                              onPressed: () {
                                myDailog(data, "email");
                              },
                              icon: Icon(Icons.edit)),
                        ],
                      )
                    ]),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Password: ${data['password']}",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              users
                                  .doc(credential!.uid)
                                  .update({"password": FieldValue.delete()});
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              myDailog(data, "password");
                            },
                            icon: Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Age: ${data['age']} years old",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Row(
                        children:[
                           IconButton(
                              onPressed: () {
                                users
                                    .doc(credential!.uid)
                                    .update({"password": FieldValue.delete()});
                              }, icon: Icon(Icons.delete),),
                        
                      IconButton(
                          onPressed: () {
                            myDailog(data, 'age');
                          },
                          icon: Icon(Icons.edit))
                    ])]),
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your user name: ${data['username']}",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {

                              }, icon: Icon(Icons.delete)),
                          IconButton(
                              onPressed: () {
                                myDailog(data, "username");
                              },
                              icon: Icon(Icons.edit)),
                        ],
                      )
                    ]),
                    SizedBox(height: 15,),
                                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Gender: ${data['gender']}",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.delete)),
                          IconButton(
                              onPressed: () {
                                myDailog(data, "gender");
                              },
                              icon: Icon(Icons.edit)),
                        ],
                      )
                    ]),
                    SizedBox(height: 15,),
                Center(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          users.doc(credential!.uid).delete();
                        });
                      },
                      child: Text(
                        "Delete Data",
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
