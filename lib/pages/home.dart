
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/details.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/pages/profilepage.dart';
import 'package:flower_app/widgets/flowers.dart';
import 'package:flower_app/widgets/provider_class.dart';
import 'package:flower_app/widgets/row_appbar.dart';
import 'package:flower_app/widgets/userimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final credintial = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          width: 250,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/1.jpg"),
                            fit: BoxFit.cover),
                      ),
                      currentAccountPicture: ImgeUser(),
                      accountEmail: Text("yousef2017magdy@gmail.com"),
                      accountName: Text("Youssef Mohamed",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          )),
                    ),
                    const ListTile(
                      leading: Icon(Icons.home),
                      title: Text(
                        "Home",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.production_quantity_limits),
                      title: Text(
                        "My Proudcts",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const ProfilePage();
                        }));
                      },
                      child: const ListTile(
                        leading: Icon(Icons.perm_contact_cal_sharp),
                        title: Text(
                          "profile page",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();

                        // ignore: use_build_context_synchronously
                        if (!context.mounted) return;
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }));
                      },
                      leading: const Icon(Icons.logout),
                      title: const Text(
                        "Log out",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: const Text("Developed by Yousef Mohamed © 2023",
                        style: TextStyle(fontSize: 12)))
              ])),
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: color2,
        actions: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: AppBarWedgit(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 30,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: GridTile(
                  footer: GridTileBar(
                    title: const Text(""),
                    trailing: Consumer<ProviderClass>(
                        builder: ((context, classInstancee, child) {
                      return IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: color4,
                        ),
                        onPressed: () {
                          classInstancee.add_product(items[index]);
                        },
                      );
                    })),
                    /*  */
                    leading: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: color4,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          items[index].price.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  child: Stack(children: [
                    Positioned(
                      top: -3,
                      bottom: -9,
                      right: 0,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Image.asset(items[index].path),
                      ),
                    ),
                  ]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(product: items[index]),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
