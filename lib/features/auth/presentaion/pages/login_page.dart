import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_event.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_state.dart';
import 'package:konektz/features/auth/presentaion/widgets/auth_button.dart';
import 'package:konektz/features/auth/presentaion/widgets/auth_input_field.dart';
import 'package:konektz/features/auth/presentaion/widgets/register_login_prompt.dart';
import 'package:konektz/core/presentation/widgets/snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLogin() {
    context.read<AuthBloc>().add(
      LoginEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthInputField(
                hint: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              AuthInputField(
                hint: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticatedState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/message',
                      (_) => false,
                    );
                  } else if (state is AuthErrorState) {
                    showSnackBar(context, state.error, Colors.red.shade700);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(onPressed: _onLogin, text: 'Login');
                },
              ),
              const SizedBox(height: 20),
              RegisterLoginPrompt(
                text: "Don't have an account? ",
                actionText: 'Register',
                onTap: () => Navigator.pushNamed(context, '/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
