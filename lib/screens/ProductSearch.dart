import 'package:flutter/material.dart';
import 'package:lead_app/models/product.dart';

class ProductSearch extends SearchDelegate<Product?> {
  final List<Product> products;

  ProductSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildProductList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildProductList();
  }

  Widget _buildProductList() {
    final suggestionList = query.isEmpty
        ? products
        : products.where((p) => p.prd_name.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Product product = suggestionList[index];
        return ListTile(
          leading: Image.network(product.prd_image),
          title: Text(product.prd_name),
          subtitle: Text(product.prd_description),
        );
      },
    );
  }
}
