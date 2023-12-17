import 'package:flower_app/widgets/flowers.dart';
import 'package:flutter/material.dart';

class ProviderClass with ChangeNotifier {
  List SelectedProduct = [];
  double Price=0;

  add_product(Flowers flowers) {
    SelectedProduct.add(flowers);
    Price+=flowers.price.round();
    notifyListeners();
  }
    remove_product(Flowers flowers) {
    SelectedProduct.remove(flowers);
    Price-=flowers.price.round();
    notifyListeners();
  }
}
