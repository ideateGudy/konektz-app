import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterLoginPrompt extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;
  const RegisterLoginPrompt({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: actionText,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
