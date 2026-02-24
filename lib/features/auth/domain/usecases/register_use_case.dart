import 'package:konektz/features/auth/domain/entities/user_entity.dart';
import 'package:konektz/features/auth/domain/repositories/auth_repository.dart';
import 'package:konektz/features/auth/domain/validators/auth_validator.dart';

class RegisterUseCase {
  final AuthRepository repository;
  final AuthValidator validator;

  RegisterUseCase({
    required this.repository,
    this.validator = const AuthValidator(),
  });

  Future<UserEntity> call(String username, String email, String password) {
    validator.validateRegisterFields(
      username: username,
      email: email,
      password: password,
    );
    return repository.register(username, email, password);
  }
}
