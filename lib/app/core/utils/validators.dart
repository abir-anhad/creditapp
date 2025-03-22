class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(emailPattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    return null;
  }

  // Phone number validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Amount validation
  static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    try {
      final amount = double.parse(value);
      if (amount <= 0) {
        return 'Amount must be greater than zero';
      }
    } catch (e) {
      return 'Please enter a valid amount';
    }

    return null;
  }

  // Date validation
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();

      if (date.isBefore(now.subtract(const Duration(days: 365)))) {
        return 'Date cannot be more than a year in the past';
      }

      if (date.isAfter(now.add(const Duration(days: 365)))) {
        return 'Date cannot be more than a year in the future';
      }
    } catch (e) {
      return 'Please enter a valid date';
    }

    return null;
  }
}