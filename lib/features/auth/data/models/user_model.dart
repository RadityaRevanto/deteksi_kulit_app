import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle backend envelope: data could be {"data": {"user": {...}, "token": "..."}} or flat
    final data = (json['data'] is Map<String, dynamic>) ? json['data'] as Map<String, dynamic> : json;
    final userJson = (data['user'] is Map<String, dynamic>) ? data['user'] as Map<String, dynamic> : data;
    final tokenStr = data['token'] as String? ?? json['token'] as String?;

    return UserModel(
      id: (userJson['uuid'] ?? userJson['id'] ?? '') as String,
      name: (userJson['full_name'] ?? userJson['name'] ?? '') as String,
      email: (userJson['email'] ?? '') as String,
      token: tokenStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'full_name': name,
      'email': email,
      'token': token,
    };
  }
}
