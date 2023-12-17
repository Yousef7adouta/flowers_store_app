// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/Register.dart';
import 'package:flower_app/pages/home.dart';
import 'package:flower_app/pages/resetpassword.dart';
import 'package:flower_app/widgets/signin_google.dart';
import 'package:flower_app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myemailcontl = TextEditingController();
  final mypasscontrl = TextEditingController();
  bool isClicked = false;
  bool isVisable = false;

  istrue() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  signin() async {
    istrue();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myemailcontl.text, password: mypasscontrl.text);
      istrue();
       // ignore: use_build_context_synchronously
       showSnackBar(context, "Sing in Successful");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, "No user found for that email.");
        istrue();
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password provided for that user.");
        istrue();
      } else {
        showSnackBar(context, "please enter wright email and password");

        istrue();
      }
    }
  }

  @override
  void dispose() {
    myemailcontl.dispose();
    mypasscontrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final google = Provider.of<GoogleSignInProvider>(context);
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("assets/Login.gif")),
        
              TextField(
                controller: myemailcontl,
                keyboardType: TextInputType.emailAddress,
                decoration: MyTextFiel.copyWith(
                    hintText: "Enter Your Email",
                    suffixIcon: Icon(Icons.mail),
                    enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context))),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: mypasscontrl,
                keyboardType: TextInputType.emailAddress,
                obscureText: isVisable ? false : true,
                decoration: MyTextFiel.copyWith(
                    hintText: "Enter Your PassWord",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisable = !isVisable;
                        });
                      },
                      icon: isVisable
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context))),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    signin();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(color2),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  child: isClicked
                      ? SizedBox(
                          height: 50,
                          width: 45,
                          //     margin: EdgeInsets.all(2),
                          child: SpinKitFadingFour(
                            color: Color.fromARGB(255, 225, 234, 241),
                            size: 40,
                          ),
                        )
                      : Text(
                          "Log in",
                          style: TextStyle(fontSize: 19),
                        )
        
                  // MyTextField(Ispassword: false,hint: "Please Enter Your Email",Type: TextInputType.emailAddress,iconx: Icon(Icons.mail),),
                  ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ResetPasword()));
                },
                child: Text(
                  "Forgot Your Password?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do you have an account ?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 0.6,
                    color: Color.fromARGB(255, 0, 0, 0),
                  )),
                  Text(
                    "OR",
                    style: TextStyle(
                      color: Color.fromARGB(255, 128, 128, 204),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.6,
                    color: Color.fromARGB(255, 0, 0, 0),
                  )),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    google.googlelogin();
                  },
                  child: SvgPicture.asset(
                    "assets/google.svg",
                    color: Color.fromARGB(150, 102, 45, 236),
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
