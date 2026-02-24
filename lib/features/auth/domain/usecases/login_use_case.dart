import 'package:konektz/features/auth/domain/entities/user_entity.dart';
import 'package:konektz/features/auth/domain/repositories/auth_repository.dart';
import 'package:konektz/features/auth/domain/validators/auth_validator.dart';

class LoginUseCase {
  final AuthRepository repository;
  final AuthValidator validator;

  LoginUseCase({
    required this.repository,
    this.validator = const AuthValidator(),
  });

  Future<UserEntity> call(String email, String password) {
    validator.validateLoginFields(email: email, password: password);
    return repository.login(email, password);
  }
}
