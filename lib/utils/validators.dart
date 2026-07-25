class Validators {
  static String? validateUsername(String username) {
    if (username.trim().isEmpty) {
      return "Username is required";
    }

    if (username.trim().length < 3) {
      return "Username must be at least 3 characters";
    }

    return null;
  }

  static String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex =
        RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email.trim())) {
      return "Enter a valid email address";
    }

    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password is required";
    }

    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  static String? validateConfirmPassword(
      String password,
      String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return "Confirm Password is required";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    return null;
  }
}