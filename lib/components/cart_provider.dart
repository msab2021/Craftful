import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_app/models/cart.dart';
import 'package:lead_app/models/product.dart';
import 'package:collection/collection.dart';

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product) {
    var item = _items.firstWhereOrNull((item) => item.product == product);

    if (item != null) {
      // The product is already in the cart, so update the quantity.
      if (item.quantity < product.prd_quantity) {
        item.quantity++;
      } else {
        Fluttertoast.showToast(msg: "This quantity is not available.");
      }
    } else {
      // The product is not in the cart, so add a new CartItem.
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  void removeItem(Product product) {
    var item = _items.firstWhereOrNull((item) => item.product == product);

    if (item != null) {
      if (item.quantity > 1) {
        // If the quantity is more than 1, decrease it by 1.
        item.quantity--;
      } else {
        // If the quantity is 1, remove the CartItem from the list.
        _items.remove(item);
      }

      notifyListeners();
    }
  }

  void updateQuantity(Product product, int quantity) {
    var item = _items.firstWhere((item) => item.product == product);
    if (quantity > product.prd_quantity) {
      Fluttertoast.showToast(msg: "This quantity is not available.");
      return;
    }
    item.quantity = quantity;
    notifyListeners();
  }

  int get totalQuantity {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  double get totalPrice {
    return _items.fold(
        0.0, (total, item) => total + item.product.prd_price * item.quantity);
  }
}
