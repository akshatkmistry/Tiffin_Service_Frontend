import 'package:flutter/foundation.dart';
import 'package:tiffin_app/providers/cart_provider.dart';

enum PaymentMethod { upi, card, cash }

class Order {
  final String id;
  final double amount;
  final DateTime date;
  final String status;
  final List<CartItem> items;
  final PaymentMethod paymentMethod;
  final String address;

  Order({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    required this.items,
    required this.paymentMethod,
    required this.address,
  });
}

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder({
    required List<CartItem> cartItems,
    required double total,
    required PaymentMethod paymentMethod,
    required String address,
  }) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        date: DateTime.now(),
        status: 'Pending',
        items: cartItems,
        paymentMethod: paymentMethod,
        address: address,
      ),
    );
    notifyListeners();
  }
}