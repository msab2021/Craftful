import 'package:flutter/material.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/components/cart_provider.dart';
import 'package:lead_app/models/product.dart';
import 'package:provider/provider.dart';

class ProductDetailPage2 extends StatefulWidget {
  final Product product;

  const ProductDetailPage2({super.key, required this.product});

  @override
  State<ProductDetailPage2> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage2> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.prd_name),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(
                  Uri.parse(API.images + widget.product.prd_image).toString(),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.product.prd_name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.product.prd_description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16.0),
              Text(
                "Price: \$${widget.product.prd_price}",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Quantity: ${widget.product.prd_quantity}",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Provider.of<Cart>(context, listen: false)
                      .addItem(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to cart!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                child: const Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
