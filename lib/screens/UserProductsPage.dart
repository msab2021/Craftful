import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/product.dart';
import 'package:lead_app/screens/EditProductScreen.dart';
import 'package:lead_app/screens/productDetailPage2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProductsPage extends StatefulWidget {
  String userId;

  UserProductsPage({super.key, required this.userId});

  @override
  _UserProductsPageState createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts(widget.userId);
  }

  Future<List<Product>> fetchProducts(String userId) async {
    final response =
        await http.get(Uri.parse('${API.Get_dataById}?user_id=$userId'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Products'),
        ),
        body: CustomScrollView(slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "All products",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          FutureBuilder<List<Product>>(
            future: fetchProducts(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage2(
                                  product: snapshot.data![index]),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1.5,
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      snapshot.data![index].prd_description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.price_check,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "\$${snapshot.data![index].prd_price}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProductScreen(
                                              product: snapshot.data![index]),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          'prd_id',
                                          snapshot.data![index].prd_id
                                              .toString());
                        
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
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Delete'),
                                                onPressed: () async {
                                                  await deleteProduct();
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                  setState(() {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          'Product deleted successfully',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.green,
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
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Text('${snapshot.error}'),
                );
              }

              // By default, show a loading spinner.
              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ]));
  }
}
