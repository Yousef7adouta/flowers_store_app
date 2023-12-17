//import 'package:firebase_core/firebase_core.dart';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flower_app/pages/home.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/widgets/provider_class.dart';
import 'package:flower_app/widgets/signin_google.dart';
import 'package:flower_app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  Future <void> main() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//     runApp(const MyApp());
//  }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
        options:const FirebaseOptions(
        apiKey: 'AIzaSyD7y5PXu_qqMxuxBoX7TbmKDWAt_UYavkE', 
        appId: '1:14446496763:android:9740c1e931ebeb90c5595e', 
        messagingSenderId: '14446496763',
        projectId: 'my-new-pro-85606',
        storageBucket:'my-new-pro-85606.appspot.com' )
      )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}
//  void main()async{
//       WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp();
//   runApp(const MyApp());
//  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ProviderClass();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
          title: "myApp",
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
              if (snapshot.hasError) {
                return showSnackBar(context, "Something went wrong");
              }
              if (snapshot.hasData) {
                return const HomePage(); // home() OR verify email
              } else {
                return const LoginPage();
              }
            },
          )),
    );
  }
}
