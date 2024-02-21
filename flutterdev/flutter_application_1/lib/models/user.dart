class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String role;
  final String image;
  final int phoneNumber;
  final bool verified;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.image,
    required this.phoneNumber,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['Username'],
      email: json['Email'],
      password: json['Password'],
      role: json['Role'],
      image: json['image'],
      phoneNumber: json['PhoneNumber'],
      verified: json['Verified'],
    );
  }
}
