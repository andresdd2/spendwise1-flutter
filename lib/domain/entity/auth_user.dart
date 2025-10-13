class AuthUser {
  final String email;
  final String token;
  final String? name;

  AuthUser({required this.email, required this.token, this.name});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      email: json['email'] as String,
      token: json['token'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'token': token, 'name': name};
  }
}