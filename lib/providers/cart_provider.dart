import 'package:flutter/foundation.dart';
import 'package:tiffin_app/models/menu_item_model.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final bool isVeg;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isVeg,
  });

  double get total => price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.total;
    });
    return total;
  }

  double get total => totalAmount;

  void addItem(
    MenuItem menuItem, {
    required String id,
    required String name,
    required double price,
    required bool isVeg,
  }) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          isVeg: existingCartItem.isVeg,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          name: name,
          price: price,
          quantity: 1,
          isVeg: isVeg,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  static const int maxQuantity = 99;

  void updateQuantity(String id, bool increase) {
    if (!_items.containsKey(id)) return;
    
    final currentItem = _items[id]!;
    int newQuantity = currentItem.quantity;

    if (increase) {
      if (newQuantity >= maxQuantity) return;
      newQuantity += 1;
    } else {
      if (newQuantity <= 1) return;
      newQuantity -= 1;
    }

    _items.update(
      id,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        name: existingCartItem.name,
        price: existingCartItem.price,
        quantity: newQuantity,
        isVeg: existingCartItem.isVeg,
      ),
    );
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}