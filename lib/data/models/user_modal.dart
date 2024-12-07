class UserModel {
  final String? name;
  final String username;
  final String? phone;
  final String password;

  UserModel({
    this.name,
    required this.username,
    this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': username,
        'phone': phone,
        'password': password,
      };

  Map<String, dynamic> toLoginJson() => {
        'username': username,
        'password': password,
      };
}
