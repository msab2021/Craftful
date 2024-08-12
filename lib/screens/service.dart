// ignore_for_file: unused_field

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/product.dart';
import 'package:lead_app/models/user.dart';
import 'package:lead_app/screens/All_users.dart';
import 'package:lead_app/screens/List_product_page.dart';
import 'package:lead_app/screens/ProductDetailPage.dart';
import 'package:lead_app/screens/UserProductsPage.dart';
import 'package:lead_app/screens/User_detils_Page.dart';
import 'package:lead_app/screens/add_product.dart';
import 'package:lead_app/screens/cart_page.dart';

import 'package:lead_app/screens/product_page.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class service extends StatefulWidget {
  User user;
  service({super.key, required this.user});

  @override
  State<service> createState() => _serviceState();
}

class _serviceState extends State<service> {
  late Future<List<Product>> _productsFuture;
  late Future<List<Map<String, dynamic>>> _categoryFuture;
  late Future<List<User>> _usersFuture;

  Future<List<User>> fetchUsersWithAcceptedProducts() async {
    final response = await http.get(Uri.parse(API.get_accepted_prd));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await http.get(Uri.parse(API.Get_categories));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse(API.Get_data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Product.fromJson1(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  final List images = [
    {"id": 5, "image_path": "assets/images/craftful.jpeg"},
    {
      "id": 4,
      "image_path":
          "assets/images/la-compagnie-robinson-nijXsx-oI7Y-unsplash.jpg"
    },
    {"id": 1, "image_path": "assets/images/gettyimages-77516999-170667a.jpg"},
    {
      "id": 2,
      "image_path": "assets/images/annie-spratt-TywjkDHf0Ps-unsplash.jpg"
    },
    {
      "id": 3,
      "image_path": "assets/images/kristina-balic-M13V8hgvm-E-unsplash.jpg"
    },
  ];
  final Map<int, IconData> categoryIcons = {
    0: FontAwesomeIcons.gem, // Accessories & Jewelry
    1: FontAwesomeIcons.bagShopping, // Bags & Wallets
    2: FontAwesomeIcons.spa, // Beauty & Self-care
    3: FontAwesomeIcons.shirt, // Clothes
    4: FontAwesomeIcons.film, // Entertainment
    5: FontAwesomeIcons.gift, // Gifts
    6: FontAwesomeIcons.couch, // Home Accessories & Living
    7: FontAwesomeIcons.utensils, // Kitchen & Dining
    8: FontAwesomeIcons.penFancy, // Stationery
  };

  CarouselController? carouselController;
  int current = 0;
  final int _cardCount = 4;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController();
    _productsFuture = fetchAllProducts();
    _categoryFuture = fetchCategories();
    _usersFuture = fetchUsersWithAcceptedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final products = snapshot.data!;
            return FutureBuilder<List<User>>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final users = snapshot.data!;
                    return Scaffold(
                        appBar: AppBar(
                          title: const Text('Home'),
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: ProductUserSearchDelegate(
                                      products, users),
                                );
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart),
                            ),
                          ],
                        ),
                        drawer: Drawer(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              const DrawerHeader(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/craftful.jpeg'),
                                        fit: BoxFit.cover)),
                                child: Text(
                                  'Menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              ListTile(
                                leading:
                                    const Icon(LineAwesomeIcons.plus_circle),
                                title: const Text('Add product'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddData(user: widget.user),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('User Product'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserProductsPage(
                                            userId: widget.user.id)),
                                  );
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.shopping_cart),
                                title: const Text('Cart'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('Settings'),
                                onTap: () {
                                  Navigator.pushNamed(context, 'settings');
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.info),
                                title: const Text('About Us'),
                                onTap: () {
                                  Navigator.pushNamed(context, 'about');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('Logout'),
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, 'login');
                                },
                              ),
                            ],
                          ),
                        ),
                        body: CustomScrollView(slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                CarouselSlider(
                                  items: images
                                      .map((e) => Image.asset(
                                            e["image_path"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            alignment: Alignment.topCenter,
                                          ))
                                      .toList(),
                                  options: CarouselOptions(
                                    height: 200,
                                    autoPlay: true,
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    pauseAutoPlayOnTouch: true,
                                    viewportFraction: 1,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        current = index;
                                      });
                                    },
                                  ),
                                  carouselController: carouselController,
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: images.map((e) {
                                      int index = images.indexOf(e);
                                      return GestureDetector(
                                        onTap: () {
                                          carouselController!
                                              .animateToPage(index);
                                        },
                                        child: Container(
                                          width: current == index ? 17 : 7,
                                          height: 10,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: current == index
                                                ? Colors.blue
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height:
                                  130, // Adjusted height to accommodate larger cards
                              width: MediaQuery.of(context).size.width,
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: _categoryFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        var category = snapshot.data![index];
                                        int catId = category['cat_id'];
                                        String catName = category['cat_name'];
                                        IconData catIcon =
                                            categoryIcons[catId] ??
                                                Icons.category;

                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductsPage(
                                                        catId: catId,
                                                        catName: catName),
                                              ),
                                            );
                                                                                    },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blue.shade100,
                                                    child: Icon(
                                                      catIcon,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Flexible(
                                                    child: Text(
                                                      catName,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
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

                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Home Decor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    // or TextButton for Flutter 2.0+
                                    child: const Text('See More'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AllDoctorsPage(), // navigate to the page that displays all cards
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder<List<Product>>(
                            future: _productsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var acceptedProducts = snapshot.data!
                                    .where((product) =>
                                        product.state == 'accepted')
                                    .toList();

                                return SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      var product = acceptedProducts[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailPage(
                                                product: product,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          margin: const EdgeInsets.all(8.0),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(15),
                                                ),
                                                child: AspectRatio(
                                                  aspectRatio: 1.5,
                                                  child: Image.network(
                                                    Uri.parse(API.images +
                                                            product.prd_image)
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.prd_name,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Colors.black87,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      product.prd_description,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                          "\$${product.prd_price}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: 8,
                                  ),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return SliverToBoxAdapter(
                                  child: Center(
                                    child: Text(
                                      "${snapshot.error}",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }

                              // By default, show a loading spinner.
                              return const SliverToBoxAdapter(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            },
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Our Heroes',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    child: const Text('See More'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AllUsersPage(
                                            fetchUsersWithAcceptedProducts:
                                                fetchUsersWithAcceptedProducts(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FutureBuilder<List<User>>(
                            future: fetchUsersWithAcceptedProducts(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      User user = snapshot.data![index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDetailPage(user: user),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    API.images + user.image,
                                                    height: 200,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    alignment:
                                                        Alignment.topCenter,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  user.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.email,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        user.email,
                                                        style: const TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: 4,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return SliverToBoxAdapter(
                                  child: Center(
                                    child: Text(
                                      "${snapshot.error}",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              }

                              // By default, show a loading spinner.
                              return const SliverToBoxAdapter(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            },
                          ),
                        ]));
                  }
                });
          }
        });
  }
}

class ProductUserSearchDelegate extends SearchDelegate<dynamic> {
  final List<Product> products;
  final List<User> users;

  ProductUserSearchDelegate(this.products, this.users);
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
        close(
            context,
            Product(
              prd_id: 0,
              prd_code: 0,
              prd_name: '',
              prd_price: 0,
              prd_image: '',
              prd_description: '',
              prd_quantity: 0,
              catID: 0,
              user_id: 0,
              state: '',
            ));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final productResults = products.where((product) =>
        product.prd_name.toLowerCase().contains(query.toLowerCase()) ||
        product.prd_price.toString().contains(query) ||
        product.prd_quantity.toString().contains(query));

    final userResults = users.where((user) =>
        user.name.toLowerCase().contains(query.toLowerCase()) ||
        user.email.toLowerCase().contains(query.toLowerCase()) ||
        user.phone.toLowerCase().contains(query.toLowerCase()));

    // Combine the results
    final allResults = [...productResults, ...userResults];

    return ListView(
      children: allResults
          .map((result) {
            if (result is Product) {
              return ListTile(
                title: Text(result.prd_name),
                subtitle: Text(
                    'Price: ${result.prd_price},Quantity: ${result.prd_quantity}'),
                onTap: () {
                  close(context, result);
                },
              );
            } else if (result is User) {
              return ListTile(
                title: Text(result.name),
                subtitle:
                    Text('Email: ${result.email}, Phone: ${result.phone}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(user: result),
                    ),
                  );
                },
              );
            }
            return null;
          })
          .where((widget) => widget != null)
          .toList()
          .cast<Widget>(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productSuggestions = products.where((product) =>
        product.prd_name.toLowerCase().startsWith(query.toLowerCase()) ||
        product.prd_price.toString().startsWith(query) ||
        product.prd_quantity.toString().startsWith(query));

    final userSuggestions = users.where((user) =>
        user.name.toLowerCase().startsWith(query.toLowerCase()) ||
        user.email.toLowerCase().startsWith(query.toLowerCase()) ||
        user.phone.toLowerCase().startsWith(query.toLowerCase()));

    // Combine the suggestions
    final allSuggestions = [...productSuggestions, ...userSuggestions];

    return ListView(
      children: allSuggestions
          .map((suggestion) {
            if (suggestion is Product) {
              return ListTile(
                title: Text(suggestion.prd_name),
                subtitle: Text(
                    'Price: ${suggestion.prd_price}, Quantity: ${suggestion.prd_quantity}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: suggestion),
                    ),
                  );
                },
              );
            } else if (suggestion is User) {
              return ListTile(
                title: Text(suggestion.name),
                subtitle: Text(
                    'Email: ${suggestion.email}, Phone: ${suggestion.phone}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(user: suggestion),
                    ),
                  );
                },
              );
            }
            return null;
          })
          .where((widget) => widget != null)
          .toList()
          .cast<Widget>(),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: fetchCategories(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return DefaultTabController(
//             length: snapshot.data!.length,
//             child: Scaffold(
//               appBar: AppBar(
//   title: Text('All Doctors'),
//   actions: [
//     IconButton(
//       icon: Icon(Icons.search),
//       onPressed: () {
//         showSearch(
//           context: context,
//           delegate: ProductSearch(products),
//         );
//       },
//     ),
//   ],
//   bottom: TabBar(
//     isScrollable: true,
//     tabs: snapshot.data!
//         .map((category) => Tab(text: category['cat_name']))
//         .toList(),
//   ),
// ),
//               body: TabBarView(
//                 children: snapshot.data!.map((category) {
//                   int? catID = category['catID'];
//                   print('catID: $catID'); // print the catID to the console
//                   if (catID == null) {
//                     // catID is null, return an empty container or some other widget
//                     return Container();
//                   }
//                   return FutureBuilder<List<Product>>(
//                     future: fetchProducts(catID),
//                     builder: (context, productSnapshot) {
//                       print(
//                           'productSnapshot: ${productSnapshot.data}'); // print the product data to the console
//                       if (productSnapshot.hasData) {
//                         return ListView.builder(
//                           itemCount: productSnapshot.data!.length,
//                           itemBuilder: (context, index) {
//                             Product product = productSnapshot.data![index];
//                             return Card(
//                               child: Column(
//                                 children: <Widget>[
//                                   Image.network(product
//                                       .prd_image), // display the product image
//                                   Text(product
//                                       .prd_name), // display the product name
//                                   Text(product
//                                       .prd_description), // display the product description
//                                   Text(
//                                       'Price: ${product.prd_price}'), // display the product price
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       } else if (productSnapshot.hasError) {
//                         return Text('${productSnapshot.error}');
//                       }

//                       // By default, show a loading spinner.
//                       return CircularProgressIndicator();
//                     },
//                   );
//                 }).toList(),
//               ),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         }

//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }

  //       body: Column(children: [
  //         Stack(
  //           children: [
  //     CarouselSlider(
  //       items: images
  //           .map((e) => Image.asset(
  //                 e["image_path"],
  //                 fit: BoxFit.cover,
  //                 width: double.infinity,
  //               ))
  //           .toList(),
  //       options: CarouselOptions(
  //         height: 200,
  //         autoPlay: true,
  //         scrollPhysics: BouncingScrollPhysics(),
  //         autoPlayInterval: Duration(seconds: 3),
  //         autoPlayAnimationDuration: Duration(milliseconds: 800),
  //         autoPlayCurve: Curves.fastOutSlowIn,
  //         pauseAutoPlayOnTouch: true,
  //         viewportFraction: 1,
  //         aspectRatio: 2.0,
  //         onPageChanged: (index, reason) {
  //           setState(() {
  //             current = index;
  //           });
  //         },
  //       ),
  //       carouselController: carouselController,
  //     ),
  //     Positioned(
  //       bottom: 0,
  //       right: 0,
  //       left: 0,
  //       child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: images.map((e) {
  //             int index = images.indexOf(e);
  //             return GestureDetector(
  //               onTap: () {
  //                 carouselController!.animateToPage(index);
  //               },
  //               child: Container(
  //                 width: current == index ? 17 : 7,
  //                 height: 8,
  //                 margin: EdgeInsets.symmetric(horizontal: 5),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   color: current == index
  //                       ? Colors.blue
  //                       : Colors.grey.shade400,
  //                 ),
  //               ),
  //             );
  //           }).toList()),
  //     )
  //   ],
  // ),
  //         Divider(
  //           indent: 20,
  //           endIndent: 20,
  //           thickness: 2,
  //         ),
  //         const Padding(
  //           padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
  //           child: Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text("Our Services",
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                     fontFamily: AutofillHints.language,
  //                     fontSize: 25,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black)),
  //           ),
  //         ),
  //         Container(
  //           // width: double.infinity,
  //           height: 100,
  //           width: MediaQuery.of(context)
  //               .size
  //               .width, // to make the container full width of the screen
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: 10,
  //             itemBuilder: (context, index) {
  //               return Container(
  //                 margin: EdgeInsets.all(10),
  //                 width: 100,
  //                 height: 100,
  //                 decoration: BoxDecoration(
  //                   color: Colors.blue,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Center(
  //                   child: Text("Service $index"),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         Divider(
  //           indent: 20,
  //           endIndent: 20,
  //           thickness: 2,
  //         ),
  //         CustomScrollView(
  //           slivers: <Widget>[
  //             SliverToBoxAdapter(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   'New Products',
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //             SliverGrid(
  //               delegate: SliverChildBuilderDelegate(
  //                 (BuildContext context, int index) {
  //                   return Card(
  //                     child: Column(
  //                       children: <Widget>[
  //                         // Image.asset(""), // replace with your image widget
  //                         Text("products[index].name"),
  //                         Text("ppppppp"),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //                 childCount: 10,
  //               ),
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2, // adjust to fit your needs
  //                 childAspectRatio: 0.8,
  //               ),
  //             ),
  //             SliverToBoxAdapter(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   'Best Sellers',
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //             // Add more sections as needed
  //           ],
  //         )
  //       ]));


// Card(
//   child: ListTile(
//     title: Text("Service 1"),
//     subtitle: Text("Service 1 description"),
//     trailing: Icon(Icons.arrow_forward_ios),
//   ),
// ),
// Divider(),
// Card(
//   child: ListTile(
//     title: Text("Service 2"),
//     subtitle: Text("Service 2 description"),
//     trailing: Icon(Icons.arrow_forward_ios),
//   ),
// ),
// final List<String> imgList = [
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
// ];
