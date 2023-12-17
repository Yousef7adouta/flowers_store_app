

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../widgets/provider_class.dart';
import '../widgets/row_appbar.dart';
import 'home.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  @override
  Widget build(BuildContext context) {
    final carttt = Provider.of<ProviderClass>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("My Ptoducts"),
          backgroundColor: color2,
          actions: const [
            Padding(
              padding: EdgeInsets.all(10),
              child: AppBarWedgit(),
            )
          ],
          leading: GestureDetector(
            onTap: () =>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return const HomePage();
                })),
            child: const Icon(Icons.arrow_back)),
        ),
        body: Column(children: [
          SingleChildScrollView(
            child: SizedBox(
              height: 550,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: carttt.SelectedProduct.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: const Text("text"),
                        subtitle: Text(
                            "${carttt.SelectedProduct[index].price} - ${carttt.SelectedProduct[index].location}"),
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage(carttt.SelectedProduct[index].path),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              carttt.remove_product(
                                  carttt.SelectedProduct[index]);
                            },
                            icon: const Icon(Icons.remove)),
                      ),
                    );
                  }),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(146, 185, 88, 156)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
                  
        ),
            child: Text(
              "Pay \$${carttt.Price}",
              style: const TextStyle(fontSize: 19),
            ))]));
  }
}
