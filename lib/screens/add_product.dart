// ignore_for_file: sort_child_properties_last, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/user.dart';
// import 'package:path_provider/path_provider.dart';
// import 'List_Data.dart';

class AddData extends StatefulWidget {
  User user;

  AddData({Key? key, required this.user}) : super(key: key);

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController controllerCode = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  late String dropdownValue;
  late Future<void> fetchCategoriesFuture;

  late File _image;
  ImageProvider? _icon;

  List<String> categories = [];
  @override
  void initState() {
    super.initState();
    fetchCategoriesFuture = fetchCategories();
  }

  void addData(String userEmail) async {
    if (_icon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }
    var url = Uri.parse(API.Add_data);
    final bytes = await _image.readAsBytes();
    final base64Image = base64Encode(bytes);

    var response = await http.post(url, body: {
      "prd_code": controllerCode.text,
      "prd_name": controllerName.text,
      "prd_price": controllerPrice.text,
      "prd_image": base64Image,
      "prd_description": controllerDescription.text,
      "prd_quantity": controllerQuantity.text,
      "cat_name": dropdownValue,
      "user_email": widget.user.email
    });

    var responseData = json.decode(response.body);

    if (responseData['status'] == 'failed') {
      if (responseData['message'] == 'The product already exists') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The product already exists')),
        );
      }
    }
    Fluttertoast.showToast(msg: "The product is pending for approval");
    controllerCode.clear();
    controllerName.clear();
    controllerPrice.clear();
    controllerQuantity.clear();
    controllerDescription.clear();
    setState(() {
      _icon = null;
      dropdownValue = categories[0];
    });
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _icon = FileImage(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> fetchCategories() async {
    var url = Uri.parse(API.Add_data);
    final response = await http.get(url);
    final List<dynamic> categoryList = json.decode(response.body);
    setState(() {
      categories =
          categoryList.map((item) => item['cat_name'].toString()).toList();
      dropdownValue =
          categories[0]; // Set the default value to the first category
    });
  }

  void error(BuildContext context, String error) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(error),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Data",
          style: TextStyle(fontFamily: "Netflix"),
        ),
      ),
      body: FutureBuilder<void>(
          future: fetchCategoriesFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        IconButton(
                          onPressed: () async {
                            await getImage();
                            setState(() {});
                          },
                          icon: _icon != null
                              ? Container(
                                  width: 100.0, // Set your desired width
                                  height: 150.0,
                                  // Set your desired height
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: _icon!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.image, size: 50.0),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        TextField(
                          controller: controllerCode,
                          style: const TextStyle(
                              fontFamily: "Netflix", fontSize: 15),
                          decoration: const InputDecoration(
                              hintText: "Item code",
                              hintStyle: TextStyle(fontFamily: "Netflix"),
                              labelText: "Item code",
                              labelStyle: TextStyle(fontFamily: "Netflix")),
                        ),
                        TextField(
                          controller: controllerName,
                          style: const TextStyle(
                              fontFamily: "Netflix", fontSize: 15),
                          decoration: const InputDecoration(
                              hintText: "Item name",
                              hintStyle: TextStyle(fontFamily: "Netflix"),
                              labelText: "Item name",
                              labelStyle: TextStyle(fontFamily: "Netflix")),
                        ),
                        TextField(
                          controller: controllerPrice,
                          style: const TextStyle(
                              fontFamily: "Netflix", fontSize: 15),
                          decoration: const InputDecoration(
                              hintText: "Item price",
                              hintStyle: TextStyle(fontFamily: "Netflix"),
                              labelText: "Item price"),
                        ),
                        TextField(
                          controller: controllerQuantity,
                          style: const TextStyle(
                              fontFamily: "Netflix", fontSize: 15),
                          decoration: const InputDecoration(
                              hintText: "Quantity", labelText: "Quantity"),
                        ),
                        TextField(
                          controller: controllerDescription,
                          style: const TextStyle(
                              fontFamily: "Netflix", fontSize: 15),
                          decoration: const InputDecoration(
                              hintText: "Description",
                              labelText: "Description"),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                        ),
                        DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, 'home');
                                },
                                child: const Text(
                                  "Back",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.blueAccent)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (controllerName.value.text.isEmpty) {
                                    setState(() {
                                      error(context, "Name can't be empty");
                                    });
                                  } else if (controllerName.value.text.length <
                                      3) {
                                    error(context,
                                        "Item name must be at least 5 character");
                                    error(
                                        context, "Fill in the data correctly!");
                                  } else if (controllerCode
                                      .value.text.isEmpty) {
                                    setState(() {
                                      error(
                                          context, "Item code can't be empty");
                                      error(context,
                                          "Fill in the data correctly!");
                                    });
                                  } else if (controllerCode.value.text.length !=
                                      3) {
                                    setState(() {
                                      error(context,
                                          "Code must contain 3 numbers");
                                      error(context,
                                          "Fill in the data correctly!");
                                    });
                                  } else if (controllerPrice
                                      .value.text.isEmpty) {
                                    setState(() {
                                      error(
                                          context, "Item Price can't be empty");
                                      error(context,
                                          "Fill in the data correctly!");
                                    });
                                  } else if (controllerPrice.value.text
                                      .contains(RegExp(r'[a-zA-Z]'))) {
                                    setState(() {
                                      error(context,
                                          "Fill in numbers only in price");
                                      error(context,
                                          "Fill in the data correctly!");
                                    });
                                  } else if (controllerQuantity
                                      .value.text.isEmpty) {
                                    setState(() {
                                      error(context, "Price cannot be empty");
                                      error(context,
                                          "Fill in the data correctly!");
                                    });
                                  } else if (controllerQuantity.value.text
                                      .contains(RegExp(r'[a-zA-Z]'))) {
                                    setState(() {
                                      error(context,
                                          "Fill in numbers only in quantity");
                                      error(context,
                                          "Fill in the data correctly!");
                                    });
                                  }
                                  //  else if (controllerQuantity
                                  //         .value.text.length < 4) {
                                  //   setState(() {
                                  //     error(context,
                                  //         "Price is not in the correct format");
                                  //     error(
                                  //         context, "Fill in the data correctly!");
                                  //   });
                                  // }
                                  else {
                                    addData(widget.user.email);

                                    // Navigator.pushReplacement(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return const ListData();
                                    // }));
                                  }
                                },
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.blueAccent)),
                                child: const Text(
                                  "Add Product",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
