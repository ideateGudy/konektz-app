import 'package:konektz/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:konektz/features/auth/domain/entities/user_entity.dart';
import 'package:konektz/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  const AuthRepositoryImplementation({required this.authRemoteDatasource});

  @override
  Future<UserEntity> login(String email, String password) {
    return authRemoteDatasource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register(String username, String email, String password) {
    return authRemoteDatasource.register(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return authRemoteDatasource.logout();
  }
}
