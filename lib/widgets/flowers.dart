

class Flowers {
  String path;
  double price;
  String location;

  Flowers({
    required this.price,
    required this.path,
    this.location="Main Branch"
    
  });
}

final List<Flowers> items = [
  Flowers(path: "assets/4.webp", price: 20.99,location: "Yousef shop"),
  Flowers(path: "assets/7.webp", price: 45.99),
  Flowers(path: "assets/5.jpg", price: 80.99),
  Flowers(path: "assets/6.png", price: 71.99),
  Flowers(path: "assets/4.webp", price: 18.99),
  Flowers(path: "assets/3.webp", price: 18.99),
];
