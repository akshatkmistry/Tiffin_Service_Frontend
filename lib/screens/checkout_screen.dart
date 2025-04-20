import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.upi;
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter delivery address')),
      );
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    orderProvider.addOrder(
      cartItems: cartProvider.items.values.toList(),
      total: cartProvider.totalAmount,
      paymentMethod: _selectedPaymentMethod,
      address: _addressController.text,
    );

    cartProvider.clear();
    Navigator.of(context).pushReplacementNamed('/orders');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: "Enter your address"),
            ),
            const SizedBox(height: 20),
            const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<PaymentMethod>(
              value: _selectedPaymentMethod,
              onChanged: (PaymentMethod? value) {
                if (value != null) {
                  setState(() => _selectedPaymentMethod = value);
                }
              },
              items: PaymentMethod.values.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method.name.toUpperCase()),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Consumer<CartProvider>(
              builder: (context, cart, child) => ElevatedButton(
                onPressed: cart.items.isEmpty ? null : _placeOrder,
                child: const Text("Place Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }

}