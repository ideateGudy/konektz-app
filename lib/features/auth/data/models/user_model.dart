import 'package:konektz/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.token,
    super.createdAt,
    super.updatedAt,
  });

  /// Parses a full login API response.
  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final user = data['user'] as Map<String, dynamic>?;
    if (user == null) throw Exception('Invalid response: missing user data');
    return UserModel(
      id: user['id']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      username: user['username']?.toString() ?? '',
      token: (data['token'] ?? json['token'])?.toString(),
    );
  }

  /// Parses a full register API response.
  factory UserModel.fromRegisterResponse(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final user = data['user'] as Map<String, dynamic>?;
    if (user == null) throw Exception('Invalid response: missing user data');
    return UserModel(
      id: user['id']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      username: user['username']?.toString() ?? '',
      createdAt: user['created_at']?.toString(),
      updatedAt: user['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    if (token != null) 'token': token,
    if (createdAt != null) 'created_at': createdAt,
    if (updatedAt != null) 'updated_at': updatedAt,
  };
}
