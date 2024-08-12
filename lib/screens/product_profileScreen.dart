import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  Future<void> _refreshProduct() async {
    var response = await http.post(Uri.parse(API.update_product_state), body: {
      'prd_id': widget.product.prd_id.toString(),
      'state': 'accepted'
    });
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        product = Product.fromJson(jsonResponse);
      });
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.prd_name),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProduct,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(
                  Uri.parse(API.images + widget.product.prd_image).toString(),
                  fit: BoxFit.cover,
                ),
              ),
              Text('Name: ${widget.product.prd_name}',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text('Price: ${widget.product.prd_price}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Text('Quantity: ${widget.product.prd_quantity}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              Text('Description: ${widget.product.prd_description}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              widget.product.state == 'accepted'
                  ? Text('State: ${widget.product.state}',
                      style: Theme.of(context).textTheme.titleMedium)
                  : ElevatedButton(
                      child: const Text('Accept'),
                      onPressed: () async {
                        var response = await http
                            .post(Uri.parse(API.update_product_state), body: {
                          'prd_id': widget.product.prd_id.toString(),
                          'state': 'accepted'
                        });
                        if (response.statusCode == 200) {
                          setState(() {
                            widget.product.state = 'accepted';
                          });
                        } else {
                          // Handle the error
                          print('Failed to update the product state');
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
