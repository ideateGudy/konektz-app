/// Pure Dart domain-layer validator.
class AuthValidator {
  const AuthValidator();

  // ── Email ──────────────────────────────────────────────────────────────────

  /// Returns an error message or null if the email is valid.
  String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return 'Email is required';

    // RFC-5322 simplified pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) return 'Enter a valid email address';

    return null;
  }

  // ── Password ───────────────────────────────────────────────────────────────

  /// Returns an error message or null if the password meets requirements.
  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // ── Username ───────────────────────────────────────────────────────────────

  /// Returns an error message or null if the username is valid.
  String? validateUsername(String username) {
    final trimmed = username.trim();
    if (trimmed.isEmpty) return 'Username is required';
    if (trimmed.length < 3) return 'Username must be at least 3 characters';
    if (trimmed.length > 30) return 'Username must be 30 characters or fewer';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Throws a [ValidationException] if any field is invalid.
  /// Validates all fields and collects all errors before throwing.
  void validateLoginFields({required String email, required String password}) {
    final errors = <String>[?validateEmail(email), ?validatePassword(password)];
    if (errors.isNotEmpty) throw ValidationException(errors);
  }

  void validateRegisterFields({
    required String username,
    required String email,
    required String password,
  }) {
    final errors = <String>[
      ?validateUsername(username),
      ?validateEmail(email),
      ?validatePassword(password),
    ];
    if (errors.isNotEmpty) throw ValidationException(errors);
  }
}

// ── Exception ─────────────────────────────────────────────────────────────────

class ValidationException implements Exception {
  final List<String> errors;

  const ValidationException(this.errors);

  /// First error message — convenient for SnackBars.
  String get first => errors.first;

  @override
  String toString() => errors.join('\n');
}
