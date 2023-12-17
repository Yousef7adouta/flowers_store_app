import 'package:flower_app/pages/myProducts.dart';
import 'package:flower_app/widgets/provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';

class AppBarWedgit extends StatelessWidget {
  const AppBarWedgit({super.key});

// String title="";
//AppBarWedgit({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Stack(
        
        children: [
                    IconButton(
              onPressed: () {
                                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const MyProducts()));
                            },
              icon: const Icon(Icons.shopping_cart)),
          Consumer<ProviderClass>(builder: (context, classInstancee, child) {
            return Positioned(
              top: -5,
              left: -2,
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: color4,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${classInstancee.SelectedProduct.length}",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),

        ],
      ),
      Consumer<ProviderClass>(builder: ((context, classInstancee, child) {
        return Text("\$ ${classInstancee.Price}");
      })),
    ]);
  }
}
