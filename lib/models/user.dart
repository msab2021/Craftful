class User {
  String id;
  String name;
  String email;
  String description;
  String phone;
  String password;
  String status;
  String image;
  String role;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.description,
    required this.phone,
    required this.status,
    required this.role,
    required this.image,

  });
  Map<String, dynamic> toJson() => {
        'usr_id': id.toString(),
        'usr_name': name,
        'usr_email': email,
        'usr_password': password,
        'usr_description': description,
        'usr_phone': phone,
        'usr_status': status,
        'usr_image': image,
        'usr_state': role,
      };
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['custID'].toString(),
      name: json['username'].toString(),
      email: json['email'].toString(),
      description: json['description'].toString(),
      phone: json['phone'].toString(),
      password: json['password'].toString(),
      status: json['usr_status'].toString(),
      image: json['image'].toString(),
      role: json['role'].toString(),
    );
  }
}
