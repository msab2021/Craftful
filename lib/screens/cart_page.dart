import 'package:flutter/material.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/components/cart_provider.dart';
import 'package:lead_app/screens/checkoutPage.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      var cart = Provider.of<Cart>(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart Items"),
          backgroundColor: Colors.teal,
        ),
        body: cart.items.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          var item = cart.items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 5,
                            child: ListTile(
                              leading: Image.network(
                                API.images + item.product.prd_image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                item.product.prd_name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                '\$${item.product.prd_price.toStringAsFixed(2)}'
                                '\nQuantity: ${item.product.prd_quantity}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove, color: Colors.teal),
                                    onPressed: () {
                                      cart.removeItem(item.product);
                                    },
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.teal),
                                    onPressed: () {
                                      cart.updateQuantity(
                                          item.product, item.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total Quantity: ${cart.totalQuantity}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total Price: \$${cart.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  totalPrice:
                                      cart.totalPrice ,
                                  totalQuantity:
                                      cart.totalQuantity, 
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart_checkout),
                          label: const Text('Checkout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      );
    } catch (e) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart Items"),
        ),
        body: Center(
          child: Text('An error occurred: $e'),
        ),
      );
    }
  }
}
