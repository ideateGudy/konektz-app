import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konektz/chat_page.dart';
import 'package:konektz/core/theme.dart';
import 'package:konektz/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:konektz/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:konektz/features/auth/domain/repositories/auth_repository.dart';
import 'package:konektz/features/auth/domain/usecases/login_use_case.dart';
import 'package:konektz/features/auth/domain/usecases/register_use_case.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:konektz/features/auth/presentaion/pages/login_page.dart';
import 'package:konektz/features/auth/presentaion/pages/register_page.dart';
import 'package:konektz/message_page.dart';

void main() {
  final AuthRepository authRepository = AuthRepositoryImplementation(
    authRemoteDatasource: AuthRemoteDatasourceImpl(),
  );
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUseCase: RegisterUseCase(repository: authRepository),
            loginUseCase: LoginUseCase(repository: authRepository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Konektz',
        theme: AppTheme.darkTheme,
        home: const RegisterPage(),
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/chat': (_) => const ChatPage(),
          '/message': (_) => const MessagePage(),
        },
      ),
    );
  }
}
