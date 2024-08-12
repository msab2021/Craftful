class Product {
  int prd_id;
  int prd_code;
  String prd_name;
  int prd_price;
  String prd_image;
  String prd_description;
  int prd_quantity;
  int catID;
  int user_id;
  String state;
  // final String cat_name;

  // rest of your code

  Product({
    required this.prd_id,
    required this.prd_code,
    required this.prd_name,
    required this.prd_price,
    required this.prd_image,
    required this.prd_description,
    required this.prd_quantity,
    required this.catID,
    required this.user_id,
    required this.state,
    // required this.cat_name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      prd_id: json['prd_id'],
      prd_code: json['prd_code'],
      prd_name: json['prd_name'],
      prd_price: json['prd_price'],
      prd_image: json['prd_image'],
      prd_description: json['prd_description'],
      prd_quantity: json['prd_quantity'],
      catID: json['catID'],
      user_id: json['user_id'],
      state: json['state'],
    );
  }
  factory Product.fromJson1(Map<String, dynamic> json) {
    return Product(
      prd_id: int.parse(json['prd_id'].toString()),
      prd_code: int.parse(json['prd_code'].toString()),
      prd_name: json['prd_name'],
      prd_price: int.parse(json['prd_price'].toString()),
      prd_image: json['prd_image'],
      prd_description: json['prd_description'],
      prd_quantity: int.parse(json['prd_quantity'].toString()),
      catID: int.parse(json['catID'].toString()),
      user_id: int.parse(json['user_id'].toString()),
      state: json['state'],
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product && other.prd_id == prd_id;
  }

  @override
  int get hashCode => prd_id.hashCode;
}

// cat_name: json['cat_name'],