import 'package:flutter/material.dart';
import 'package:konektz/core/theme.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const AuthButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: DefaultColors.buttonColor,
        // foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}