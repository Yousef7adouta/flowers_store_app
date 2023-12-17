//  // ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

import '../constants/colors.dart';

// class MyTextField extends StatelessWidget {
//   final TextInputType Type;
//   final bool Ispassword;
//   final String hint;
//   final Icon iconx;
//   MyTextField({
//     super.key,
//     required this.Type,
//     required this.Ispassword,
//     required this.hint,
//     required this.iconx,
//   });

//   @override
//   Widget build(BuildContext context) {
// return TextField(
//   keyboardType: Type,
//   obscureText: false,
//   decoration: InputDecoration(
//     suffixIcon: iconx,
//     suffixIconColor:  Color.fromARGB(164, 107, 107, 240),
//     hintText: "Please Enter Your Email",
//     enabledBorder:
//         OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
//     focusedBorder:
//         OutlineInputBorder(borderSide: BorderSide(color:Color.fromARGB(132, 107, 107, 240))),
//     filled: true,
//     fillColor:  Color.fromARGB(45, 91, 91, 92),
//     contentPadding: EdgeInsets.all(8),
//   ),
// );
//   }
// }
const MyTextFiel = InputDecoration(
  suffixIconColor: color1,
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color:color2 )),
  filled: true,
  fillColor:color3,
  contentPadding: EdgeInsets.all(8),
);
