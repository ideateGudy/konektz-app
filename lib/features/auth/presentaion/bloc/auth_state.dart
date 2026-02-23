import 'package:konektz/features/auth/domain/entities/user_entity.dart';

sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

/// Emitted after a successful login — carries the authenticated user.
final class AuthAuthenticatedState extends AuthState {
  final UserEntity user;

  AuthAuthenticatedState({required this.user});
}

/// Emitted after a successful registration (not yet logged in).
final class AuthSuccessState extends AuthState {
  final String message;

  AuthSuccessState({required this.message});
}

final class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState({required this.error});
}

final class AuthLoggedOutState extends AuthState {}
