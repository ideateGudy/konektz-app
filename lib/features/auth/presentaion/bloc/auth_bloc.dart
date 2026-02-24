import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:konektz/features/auth/domain/usecases/login_use_case.dart';
import 'package:konektz/features/auth/domain/usecases/register_use_case.dart';
import 'package:konektz/features/auth/domain/validators/auth_validator.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_event.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final FlutterSecureStorage _storage;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage,
       super(AuthInitialState()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final user = await registerUseCase(
        event.username,
        event.email,
        event.password,
      );
      emit(
        AuthSuccessState(
          message: 'Registration successful for ${user.username}',
        ),
      );
    } catch (e) {
      emit(
        AuthErrorState(
          error: e is ValidationException
              ? e.first
              : e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final user = await loginUseCase(event.email, event.password);
      if (user.token != null) {
        await _storage.write(key: 'authToken', value: user.token);
      }
      await _storage.write(key: 'userId', value: user.id);
      emit(AuthAuthenticatedState(user: user));
    } catch (e) {
      emit(
        AuthErrorState(
          error: e is ValidationException
              ? e.first
              : e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await _storage.deleteAll();
      emit(AuthLoggedOutState());
    } catch (e) {
      emit(AuthErrorState(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
