import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/constants/colors.dart';
import 'package:flower_app/pages/home.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/widgets/userimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../widgets/getdatafromfirestore.dart';
import 'package:path/path.dart' show basename;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final credential = FirebaseAuth.instance.currentUser!;
  File? imgPath;
  String? imgName;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  uploadImage(ImageSource imageSource) async {
    final pickedImg = await ImagePicker().pickImage(source: imageSource);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999);
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            },
            label: const Text(
              "logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        leading: GestureDetector(
            onTap: () =>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
                  return const HomePage();
                })),
            child: const Icon(Icons.arrow_back)),
        backgroundColor: grean,
        title: const Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: color4),
                  child: Stack(
                    children: [
                      imgPath == null
                          ?const ImgeUser()
                          : ClipOval(
                              child: Image.file(
                                imgPath!,
                                width: 145,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                          right: -20,
                          bottom: -20,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                      const Color.fromARGB(255, 104, 114, 252)),
                              child: IconButton(
                                  onPressed: () async {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await uploadImage(
                                                          ImageSource.camera);
                                                      if (imgPath != null) {
                                                        //upload image
                                                        final storageRef =
                                                            FirebaseStorage
                                                                .instance
                                                                .ref(
                                                                    "user-imgs/$imgName");
                                                        await storageRef
                                                            .putFile(imgPath!);
                                                        //get imageLink
                                                        String url =
                                                            await storageRef
                                                                .getDownloadURL();

                                                        users
                                                            .doc(credential.uid)
                                                            .update({
                                                          "imgurl": url
                                                        });
                                                      }
                                                      //Navigator.pop(context);
                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons.camera,
                                                          size: 30,
                                                        ),
                                                        Text(
                                                          "Take photo form camera",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await uploadImage(
                                                          ImageSource.gallery);
                                                      if (imgPath != null) {
                                                        //upload image
                                                        final storageRef =
                                                            FirebaseStorage
                                                                .instance
                                                                .ref(
                                                                    "user-imgs/$imgName");
                                                        await storageRef
                                                            .putFile(imgPath!);
                                                        //get imageLink
                                                        String url =
                                                            await storageRef
                                                                .getDownloadURL();

                                                        users
                                                            .doc(credential.uid)
                                                            .update({
                                                          "imgurl": url
                                                        });
                                                      }
                                                      //Navigator.pop(context);
                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .photo_camera_back_rounded,
                                                          size: 30,
                                                        ),
                                                        Text(
                                                          "Take photo form galary",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });

                                    ////////////////////
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: color1,
                                  )),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 177, 255),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text(
                  "Info from firebase Auth",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Email: ${credential.email}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    //

                    "Created date:   ${DateFormat("MMMM d, y").format(credential.metadata.creationTime!)}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    //
                    "Last Signed In: ${DateFormat("MMMM d, y").format(credential.metadata.lastSignInTime!)}",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            credential.delete();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginPage();
                            }));
                          });
                        },
                        child: const Text(
                          "Delete User",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 55,
              ),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 131, 177, 255),
                          borderRadius: BorderRadius.circular(11)),
                      child: const Text(
                        "Info from firebase firestore",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))),
              GetDataFromFirestore(
                documentId: credential.uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
