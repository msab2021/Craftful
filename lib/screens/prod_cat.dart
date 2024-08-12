import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class  ProdCat extends StatefulWidget {
  const ProdCat({super.key});

  @override
  State<ProdCat> createState() => _ProdCatState();
}


class _ProdCatState extends State<ProdCat> {
   TextEditingController controllerCode = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerStock = TextEditingController();

  void addData() {
    var url = Uri.parse("http://10/craftful/Add_data.php");

    http.post(url, body: {
      "itemcode": controllerCode.text,
      "itemname": controllerName.text,
      "price": controllerPrice.text,
      "stock": controllerStock.text
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
  // String shi = "Clothes/512-512-2007-7mx9mg0a.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
        title: const Text(
          "Add Data",
          style: TextStyle(fontFamily: "Netflix"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: controllerCode,
                  style: const TextStyle(fontFamily: "Netflix", fontSize: 15),
                  decoration: const InputDecoration(
                      hintText: "Item Code",
                      hintStyle: TextStyle(fontFamily: "Netflix"),
                      labelText: "Item Code",
                      labelStyle: TextStyle(fontFamily: "Netflix")),
                ),
                TextField(
                  controller: controllerName,
                  style: const TextStyle(fontFamily: "Netflix", fontSize: 15),
                  decoration: const InputDecoration(
                      hintText: "Item Name",
                      hintStyle: TextStyle(fontFamily: "Netflix"),
                      labelText: "Item Name"),
                ),
                TextField(
                  controller: controllerPrice,
                  style: const TextStyle(fontFamily: "Netflix", fontSize: 15),
                  decoration: const InputDecoration(
                      hintText: "Price", labelText: "Price"),
                ),
                TextField(
                  controller: controllerStock,
                  style: const TextStyle(fontFamily: "Netflix", fontSize: 15),
                  decoration: const InputDecoration(
                      hintText: "Stock", labelText: "Stock"),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // //Navigator.pop(context);
                          // Navigator.pushReplacement(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return const ListData();
                          // }));
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blueAccent)),
                        child: const Text(
                          "Back",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controllerCode.value.text.isEmpty) {
                            setState(() {
                              error(context, "ID can't be empty");
                            });
                          } else if (controllerCode.value.text
                              .contains(RegExp(r'[a-zA-Z]'))) {
                            setState(() {
                              error(context, "ID must be a number");
                              error(context, "Fill in the data correctly!");
                            });
                          } else if (controllerCode.value.text.length != 3) {
                            setState(() {
                              error(context, "ID must contain 3 numbers");
                              error(context, "Fill in the data correctly!");
                            });
                          } else if (controllerName.value.text.isEmpty) {
                            setState(() {
                              error(context, "Item name can't be empty");
                              error(context, "Fill in the data correctly!");
                            });
                          } else if (controllerName.value.text.length < 5) {
                            error(context,
                                "Item name must be at least 5 character");
                            error(context, "Fill in the data correctly!");
                          } else if (controllerPrice.value.text.isEmpty) {
                            setState(() {
                              error(context, "Price cannot be empty");
                              error(context, "Fill in the data correctly!");
                            });
                          } else if (controllerPrice.value.text
                              .contains(RegExp(r'[a-zA-Z]'))) {
                            setState(() {
                              error(context, "Fill in numbers only");
                              error(context, "Fill in the data correctly!");
                            });
                          } else if (controllerPrice.value.text.length < 4) {
                            setState(() {
                              error(context,
                                  "Price is not in the correct format");
                              error(context, "Fill in the data correctly!");
                            });
                          } else {
                            addData();
                            // Navigator.pushReplacement(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const ListData();
                            // }));
                          }
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blueAccent)),
                        child: const Text(
                          "Add Data",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      // body: Column(children: [
      //   Image.network("http://10.0.2.2/craftful/images/$shi"),
      // ]),
    );
  }
}
