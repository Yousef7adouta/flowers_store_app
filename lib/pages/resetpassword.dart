import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/colors.dart';
import '../widgets/textfield.dart';

class ResetPasword extends StatefulWidget {
  const ResetPasword({super.key});

  @override
  State<ResetPasword> createState() => _ResetPaswordState();
}

class _ResetPaswordState extends State<ResetPasword> {
  final myemailcontl = TextEditingController();
  bool isClicked = false;
  final _formKey = GlobalKey<FormState>();

  funcIsCliced() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  resetpasswor() async {
    funcIsCliced();
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: myemailcontl.text);
      funcIsCliced();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
      funcIsCliced();
    }
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }



  @override
  void dispose() {
    myemailcontl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextFormField(
                  validator: (email) {
                    return email!.contains(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                        ? null
                        : "Please Enter Valid Email";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: myemailcontl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: MyTextFiel.copyWith(
                      hintText: "Enter Your Email",
                      suffixIcon: const Icon(Icons.mail),
                      enabledBorder: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context))),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        resetpasswor();
                      } else {
                        showSnackBar(context, "Pleas Check Your Email");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(color2),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
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
                            "Reset Your Password",
                            style: TextStyle(fontSize: 19),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
