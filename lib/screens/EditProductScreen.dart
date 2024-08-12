import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lead_app/admin/api_connection/api_connection.dart';
import 'package:lead_app/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class EditProductScreen extends StatefulWidget {
  Product product;

  EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  Future<void> _updateProduct() async {
    var response = await http.post(
      Uri.parse(Uri.parse(API.update_product_info).toString()),
      body: {
        'prd_id': widget.product.prd_id.toString(),
        'prd_name': _nameController.text,
        'prd_price': _priceController.text,
        'prd_quantity': _quantityController.text,
        'prd_description': _descriptionController.text,
        'prd_image': _imageUrl,
      },
    );

    if (response.statusCode == 200) {
      //  If the server returns a 200 OK response, then parse the JSON.
      print('Response body: ${response.body}');
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

      print('Product updated successfully');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update product');
    }
  }

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  String? _imageUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.prd_name);
    _priceController =
        TextEditingController(text: widget.product.prd_price.toString());
    _quantityController =
        TextEditingController(text: widget.product.prd_quantity.toString());
    _descriptionController =
        TextEditingController(text: widget.product.prd_description);
    _imageUrl = widget.product.prd_image;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _imageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageFile == null
                    ? _imageUrl != null
                        ? Image.network(
                            Uri.parse(API.images + _imageUrl!).toString(),
                          ) // Use Image.network here
                        : const Icon(Icons.add_a_photo)
                    : Image.file(_imageFile!),
              ),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateProduct();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
