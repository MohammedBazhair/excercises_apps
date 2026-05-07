class UserModel {
  final String uid;
  final String name;
  final String email;
  final String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
