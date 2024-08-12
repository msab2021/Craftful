import 'package:flutter/material.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/components/favorite_provider.dart';
import 'package:lead_app/models/product.dart';
import 'package:lead_app/screens/productDetailPage2.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.teal,
      ),
      body: Consumer<Favorite>(
        builder: (context, favorite, child) {
          return ListView.builder(
            itemCount: favorite.items.length,
            itemBuilder: (context, index) {
              return FavoriteItemCard(favorite.items[index]);
            },
          );
        },
      ),
    );
  }
}

class FavoriteItemCard extends StatelessWidget {
  final Product product;

  const FavoriteItemCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage2(product: product),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              Uri.parse(API.images + product.prd_image).toString(),
              fit: BoxFit.cover,
              width: 100, // you can change this size
              height: 100, // and this one
            ),
            title: Text(
              product.prd_name,
              style: const TextStyle(fontSize: 20), // change the font size here
            ),
            subtitle: Text(
              "\$${product.prd_price}\nQuantity: ${product.prd_quantity}",
              style: const TextStyle(fontSize: 18), // and here
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                Provider.of<Favorite>(context, listen: false)
                    .removeItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Removed from favorites!'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
