class FormValidators {

  static String? fulllNameValidation(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 3) {
      return '$fieldName must be at least 3 characters';
    }
    if (value.trim().length > 40) {
      return '$fieldName must be at most 40 characters';
    }
    return null;
  }
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? number(String? value, {String fieldName = 'Number'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
    // if (!RegExp(r'^\+?\d+$').hasMatch(value)) {
      return 'Only numbers allowed';
    }

    return null;
  }

  static String? minLength(
    String? value,
    int length, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.length < length) {
      return '$fieldName must be at least $length characters';
    }
    return null;
  }

  static String? strongPassword(String? value, {String fieldName = 'Password'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final hasUpper = RegExp(r'[A-Z]');
    final hasLower = RegExp(r'[a-z]');
    final hasDigit = RegExp(r'\d');
    final hasSpecial = RegExp(r'[!@#\$&*~_()\[\]{}:;,.<>?%^+=|\\/-]');

    if (value.length < 8) {
      return '$fieldName must be at least 8 characters';
    }
    if (!hasUpper.hasMatch(value)) {
      return '$fieldName must contain at least one uppercase letter';
    }
    if (!hasLower.hasMatch(value)) {
      return '$fieldName must contain at least one lowercase letter';
    }
    if (!hasDigit.hasMatch(value)) {
      return '$fieldName must contain at least one digit';
    }
    if (!hasSpecial.hasMatch(value)) {
      return '$fieldName must contain at least one special character';
    }
    return null;
  }
}
