import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:lead_app/screens/EditProductScreen.dart';
import 'package:lead_app/screens/product_profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  Product? product;
  late Future<List<Product>> futureProducts;
  String filterState = 'accepted';

  Future<List<Product>> fetchProducts(String state) async {
    final response =
        await http.get(Uri.parse('${API.product_state}?state=$state'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Product.fromJson1(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> deleteProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? prdId = prefs.getString('prd_id');

    if (prdId == null) {
      throw Exception('No product selected');
    }

    var response = await http.post(
      Uri.parse(Uri.parse(API.delete_product).toString()),
      body: {
        'prd_id': prdId,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('Status: ${jsonResponse['status']}');
      Fluttertoast.showToast(
        msg: jsonResponse['status'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await prefs.remove('prd_id');
      setState(() {
        print('Status: ${jsonResponse['status']}');
      });
    } else {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      futureProducts = fetchProducts(filterState);
    });
  }

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts(filterState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              String? state = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Filter products'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: const Text('Accepted'),
                          onTap: () => Navigator.pop(context, 'accepted'),
                        ),
                        ListTile(
                          title: const Text('Pending'),
                          onTap: () => Navigator.pop(context, 'pending'),
                        ),
                      ],
                    ),
                  );
                },
              );

              if (state != null) {
                setState(() {
                  filterState = state;
                  futureProducts = fetchProducts(filterState);
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _refreshProducts,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];
                  if (product.state == filterState) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(
                              Uri.parse(API.images +
                                      snapshot.data![index].prd_image)
                                  .toString(),
                              width: 50,
                              height: 50),
                          subtitle: Text(
                              'Name: ${product.prd_name}\nPrice: ${product.prd_price}\nQuantity: ${product.prd_quantity}\nState: ${product.state}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProductScreen(product: product),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'prd_id', product.prd_id.toString());
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Store the BuildContext in a separate variable
                                      final BuildContext dialogContext =
                                          context;

                                      return AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                            'Are you sure you want to delete this product?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Delete'),
                                            onPressed: () async {
                                              await deleteProduct();
                                              Navigator.of(dialogContext).pop();
                                              setState(() {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Product deleted successfully',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(); // return an empty container for non-accepted products
                  }
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
