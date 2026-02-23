class UserEntity {
  final String id;
  final String email;
  final String username;
  final String? token;
  final String? createdAt;
  final String? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.token,
    this.createdAt,
    this.updatedAt,
  });
}
