import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_event.dart';
import 'package:konektz/features/auth/presentaion/bloc/auth_state.dart';
import 'package:konektz/features/auth/presentaion/widgets/register_login_prompt.dart';
import 'package:konektz/features/auth/presentaion/widgets/auth_button.dart';
import 'package:konektz/features/auth/presentaion/widgets/auth_input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onRegister() {
    BlocProvider.of<AuthBloc>(context).add(
      RegisterEvent(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
                hint: 'Username',
                icon: Icons.person,
                controller: _usernameController,
              ),
              const SizedBox(height: 20),
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
                  if (state is AuthSuccessState) {
                    Navigator.pushNamed(context, '/login');
                  } else if (state is AuthErrorState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(onPressed: _onRegister, text: 'Register');
                },
              ),
              const SizedBox(height: 20),
              RegisterLoginPrompt(
                text: "Already have an account? ",
                actionText: "Login",
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
