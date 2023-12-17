import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../widgets/snackbar.dart';
import '../widgets/textfield.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final myemailcontl = TextEditingController();
  final mypasscontrl = TextEditingController();
  final myconfpasscontrl = TextEditingController();
  final myagecontrl = TextEditingController();
  final mygendercontrl = TextEditingController();
  final myusernamecontrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isVisable = false;
  bool isClicked = false;
  bool visableColumn = true;

  File? imgPath;
  String? imgName;

  bool isPassword8Char = false;
  bool hasDigit = false;
  bool hasLowercase = false;
  bool hasUppercase = false;
  bool specialCaharacter = false;
  bool correctEmail = false;
  bool correctPassword = false;
  bool confirme = false;

  uploadImage(ImageSource img) async {
    final pickedImg = await ImagePicker().pickImage(source: img);
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

  emailChanged(String email) {
    setState(() {
      correctEmail = false;
      if (email.isEmpty) {
        correctEmail = true;
      }
      if (email.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        correctEmail = true;
      }
    });
  }

  passwordChanged(String password) {
    setState(() {
      isPassword8Char = false;
      specialCaharacter = false;
      hasUppercase = false;
      hasLowercase = false;
      hasDigit = false;
      visableColumn = true;
      correctPassword = false;

      if (password.isEmpty) {
        visableColumn = false;
      }
      if (password.contains(RegExp(r'.{8,}'))) {
        isPassword8Char = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        hasDigit = true;
      }
      if (password.contains(RegExp(r'[a-z]'))) {
        hasLowercase = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        specialCaharacter = true;
      }
      if (isPassword8Char == true &&
          hasUppercase == true &&
          hasLowercase == true &&
          hasDigit == true &&
          specialCaharacter == true) {
        correctPassword = true;
      }
    });
  }

  istrue() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  confirmePassword(passwords) {
    setState(() {
      confirme = false;
      passwords = myconfpasscontrl.text;
      if (passwords == mypasscontrl.text) {
        confirme = true;
      }
      if (passwords.isEmpty) {
        confirme = true;
      }
    });
  }

  register() async {
    istrue();
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: myemailcontl.text,
        password: mypasscontrl.text,
      );

      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref("user-imgs/$imgName");
      await storageRef.putFile(imgPath!);
      String url = await storageRef.getDownloadURL();
/////////////////////////////////////////////////////////////////////
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users
          .doc(credential.user!.uid)
          .set({
            'username':myusernamecontrl.text,
            "imgurl": url,
            "age": myagecontrl.text,
            "password": mypasscontrl.text,
            "email": myemailcontl.text,
            "gender": mygendercontrl.text,
          })
          .then((value) => print("values added"))
          .catchError((e) => print("erorr$e"));
      
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }));
      istrue();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
        istrue();
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
        istrue();
      } else {
        showSnackBar(context, "failed to connect server please try again!.");
        istrue();
      }
    } catch (e) {
      showSnackBar(context, "failed to connect server please try again {$e}");
      istrue();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    visableColumn = false;
    super.initState();
  }

  @override
  void dispose() {
    myemailcontl.dispose();
    mypasscontrl.dispose();
    myagecontrl.dispose();
    mygendercontrl.dispose();
    myconfpasscontrl.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: color4),
                      child: Stack(
                        children: [
                          (imgPath == null)
                              ? const CircleAvatar(
                                  radius: 64,
                                  backgroundColor: white,
                                  backgroundImage:
                                      AssetImage("assets/person.png"),
                                )
                              : ClipOval(
                                  child: Image.file(
                                    imgPath!,
                                    width: 145,
                                    height: 145,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          Positioned(
                              right: -15,
                              bottom: 10,
                              child: IconButton(
                                  onPressed: () {
                                    // uploadImage(ImageSource.gallery);
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
                                                      Navigator.pop(context);
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
                                                      Navigator.pop(context);
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
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo_rounded,
                                    color: color1,
                                  )))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: myusernamecontrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: MyTextFiel.copyWith(
                          hintText: "Enter Your User Name",
                          suffixIcon: const Icon(Icons.person_rounded),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (age) {
                        emailChanged(age);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      controller: myagecontrl,
                      decoration: MyTextFiel.copyWith(
                          hintText: "Enter Your Age",
                          suffixIcon: const Icon(Icons.date_range),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (gender) {
                        emailChanged(gender);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      controller: mygendercontrl,
                      decoration: MyTextFiel.copyWith(
                          hintText: "Enter Your gender",
                          suffixIcon: const Icon(Icons.group_outlined),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (email) {
                        emailChanged(email);
                      },
                      validator: (email) {
                        // return value != null && !EmailValidator.validate(value)
                        return correctEmail ? null : "Enter a valid email";
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      controller: myemailcontl,
                      decoration: MyTextFiel.copyWith(
                          hintText: "Enter Your Email",
                          suffixIcon: const Icon(Icons.mail),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (password) {
                        passwordChanged(password);
                      },
                      validator: (value) {
                        return value!.length < 8
                            ? "Enter valid password"
                            : null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isVisable ? false : true,
                      controller: mypasscontrl,
                      decoration: MyTextFiel.copyWith(
                          hintText: "Enter Your PassWord",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisable = !isVisable;
                              });
                            },
                            icon: isVisable
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (passwords) {
                        confirmePassword(passwords);
                      },
                      validator: (value) {
                        setState(() {
                          mypasscontrl.text;
                        });
                        return value == mypasscontrl.text || confirme
                            ? null
                            : "Enter confirme password";
                      },
                      controller: myconfpasscontrl,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: MyTextFiel.copyWith(
                          hintText: "Confirme Your PassWord",
                          suffixIcon: const Icon(Icons.remove_red_eye_sharp),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: visableColumn,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(3),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isPassword8Char ? grean : white,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            96, 153, 151, 151))),
                                child: const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "The password contains at least 8 characters",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(3),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasDigit ? grean : white,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            96, 153, 151, 151))),
                                child: const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "The password contains at least one number",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(3),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasUppercase ? grean : white,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            96, 153, 151, 151))),
                                child: const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "The password contains uppercase",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(3),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasLowercase ? grean : white,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            96, 153, 151, 151))),
                                child: const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "The password contains lowercase",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(3),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: specialCaharacter ? grean : white,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            96, 153, 151, 151))),
                                child: const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "The password contains special characters",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              imgName != null &&
                              imgPath != null) {
                            await register();
                            if (!mounted) return;
                          }
                          // Navigator.pushNamed(context, "/h");
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(color2),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(20)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        child: isClicked
                            ? const SizedBox(
                                height: 50,
                                width: 45,
                                //     margin: EdgeInsets.all(2),
                                child: SpinKitFadingFour(
                                  color: Color.fromARGB(255, 225, 234, 241),
                                  size: 40,
                                ),
                              )
                            : const Text(
                                "Sing Up",
                                style: TextStyle(fontSize: 19),
                              )

                        // MyTextField(Ispassword: false,hint: "Please Enter Your Email",Type: TextInputType.emailAddress,iconx: Icon(Icons.mail),),
                        ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Do you have an account?",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
