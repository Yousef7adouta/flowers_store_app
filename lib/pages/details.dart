import 'package:flower_app/widgets/flowers.dart';
import 'package:flower_app/widgets/row_appbar.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class DetailsPage extends StatefulWidget {
  final Flowers product;
   const DetailsPage({super.key, required this.product});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isShowmore = true;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.product.path),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "\$ ${widget.product.price}",
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(141, 165, 22, 12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "New",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 241, 221, 35),
                        ),
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 241, 221, 35),
                        ),
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 241, 221, 35),
                        ),
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 241, 221, 35),
                        ),
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 241, 221, 35),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(90, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Color.fromARGB(155, 244, 67, 54),
                          size: 25,
                        ),
                        Text(
                          "Main Branch",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Details:",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "The first flowering plants appeared on the Earth around 140 million years ago and today they grow on every continent on the planet, from the highest mountains to the deepest valleys, and even underwater.Flowering plants come in an extensive range of colours, sizes, shapes and fragrance, with many of them producing fruits and seeds that we use every day for food cosmetics and medicines.With so much diversity and individuality, you need expert help when it comes to learning more about flowers across the world. With Interflora’s extensive guide, you can search a catalogue of flowers and learn all about their distinctive and unique characteristics",
                maxLines: isShowmore ? 3 : null,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isShowmore = !isShowmore;
                  });
                },
                child: Text(isShowmore ? "Show more" : "Show less"))
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: color2,
        actions: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: AppBarWedgit(),
          )
        ],
      ),
    );
  }
}
