typedef Validator = String? Function(String?);

class Validators {
  static Validator required([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  static Validator email([String? message]) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message ?? 'Email is required';
      }

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      );

      if (!emailRegex.hasMatch(value)) {
        return message ?? 'Please enter a valid email';
      }

      return null;
    };
  }

  static Validator minLength(int length, [String? message]) {
    return (value) {
      if (value == null || value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }
}