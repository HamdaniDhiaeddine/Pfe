typedef Validator = String? Function(String?);

class Validators {
  static String? Function(String?) required(String message) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    };
  }

  static String? Function(String?) email(String message) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Email is required';
      }
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return message;
      }
      return null;
    };
  }

  static String? Function(String?) password(String message) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Password is required';
      }
      if (value.length < 6) {
        return message;
      }
      return null;
    };
  }
}