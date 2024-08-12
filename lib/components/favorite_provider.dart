import 'package:flutter/foundation.dart';
import 'package:lead_app/models/product.dart';

class Favorite extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addItem(Product product) {
    if (!_items.contains(product)) {
      _items.add(product);
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }
}