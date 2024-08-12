import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:lead_app/screens/ProductDetailPage.dart';

class ProductsPage extends StatefulWidget {
  final int catId;
  final String catName;

  const ProductsPage({super.key, required this.catId, required this.catName});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future<List<Product>> fetchProducts(int catId) async {
    final response = await http
        .get(Uri.parse('${API.product_cat}?cat_id=$catId'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products for category $catId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catName),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(widget.catId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // Adjusted aspect ratio for better fit
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.network(
                              Uri.parse(API.images +
                                      snapshot.data![index].prd_image)
                                  .toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].prd_name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                snapshot.data![index].prd_description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Price: \$${snapshot.data![index].prd_price}",
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
