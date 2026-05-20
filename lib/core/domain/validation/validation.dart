extension Validation on String {
  String? validateNullableFullName() {
    if (trim().isEmpty) {
      return null;
    }
    return validateFullName();
  }

  String? validateFirstName() {
    if (trim().isEmpty) {
      return '*first name required';
    }
    if (trim().length <= 1) {
      return '*must be more than 1 character';
    }
    return null;
  }

  String? validateLastName() {
    if (trim().isEmpty) {
      return '*last name required';
    }
    if (trim().length <= 1) {
      return '*must be more than 1 character';
    }
    return null;
  }

  String? validateName() {
    if (trim().isEmpty) {
      return '*required';
    }
    return null;
  }

  String? validateFullName() {
    if (trim().isEmpty) {
      return '*required';
    }
    if (length <= 1) {
      return 'initials are not allowed';
    }

    final split = trim().split(" ");
    if (split.length < 2) {
      return 'Full Name required';
    }

    return null;
  }

  String? validateField() {
    if (trim().isEmpty) {
      return '*required';
    }
    return null;
  }

  String? validateAccountNumber() {
    if (trim().isEmpty) {
      return '*required';
    }
    if (isAccountNumber()) {
      return null;
    }
    return 'invalid account number';
  }

  // String? validatePhone() {
  //   if (trim().isEmpty) {
  //     return '*required';
  //   }
  //   final regex = RegExp(r'^(?:\+234.{10}|234.{10}|0.{10})$');
  //   if (regex.hasMatch(this)) {
  //     return null;
  //   }
  //   return 'invalid phone number';
  // }

  String? validatePhone() {
    if (trim().isEmpty) {
      return '*required';
    }

    // Remove all non-digit characters
    final digits = replaceAll(RegExp(r'\D'), '');

    // Global phone number length (E.164 standard)
    if (digits.length < 7 || digits.length > 12) {
      return 'invalid phone number';
    }

    return null;
  }

  String? validateEmail() {
    if (trim().isEmpty) {
      return '*email address required';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (regex.hasMatch(this)) {
      return null;
    }

    return 'invalid email address';
  }

  String? validatePassword() {
    if (isEmpty) {
      '*required';
    }
    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*_ ]+).{8,}$');
    if (regex.hasMatch(this)) {
      return null;
    }

    if (!isContainUppercase()) {
      return 'must have uppercase letters';
    }

    if (!isContainLowercase()) {
      return 'must have lowercase letters';
    }

    if (!isSpecial()) {
      return 'must contain any of !@#\$%^&*_';
    }

    if (length < 8) {
      'must be at least 8 characters';
    }

    return 'invalid password';
  }

  String? validateRePassword(String password) {
    if (trim().isEmpty) return '*required';
    if (this != password) return 'password mismatch';
    return null;
  }

  String? validateIdentity() {
    if (isEmpty) {
      return '*required';
    }

    if (isPhone()) {
      return validatePhone();
    }

    if (isEmail()) {
      return validateEmail();
    }

    return 'invalid email or phone';
  }

  String? validateDate() {
    if (trim().isEmpty) {
      return '*required';
    }

    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(this)) {
      return 'invalid date format';
    }

    final parts = split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    // Year sanity check (customize as needed)
    if (year < 1900 || year > DateTime.now().year + 50) {
      return 'invalid year';
    }

    // Month check
    if (month < 1 || month > 12) {
      return 'invalid month';
    }

    // Get max days in month
    final maxDays = DateTime(year, month + 1, 0).day;

    if (day < 1 || day > maxDays) {
      return 'invalid day';
    }

    return null;
  }

  String? validateLoginPassword() {
    if (isEmpty) {
      return '*required';
    }
    return null;
  }

  String removeDecimalPart() {
    if (contains('.')) {
      return split('.')[0];
    }
    return this;
  }

  bool isContainUppercase() {
    return RegExp(r'^(?=.*[A-Z]).+$').hasMatch(this);
  }

  bool isContainLowercase() {
    return RegExp(r'^(?=.*[a-z]).+$').hasMatch(this);
  }

  bool isSpecial() {
    return RegExp(r'^(?=.*[!@#$%^&*_ ]).+$').hasMatch(this);
  }

  bool isNumber() {
    return RegExp(r'^(?=.*[0-9]).+$').hasMatch(this);
  }

  bool isPhone() {
    final regex = RegExp(r'^(0|\+?234)(.*)$');
    return regex.hasMatch(this);
  }

  bool isEmail() {
    final regex = RegExp(r'^([a-zA-Z0-9])(.*)$');
    return regex.hasMatch(this);
  }

  bool isAccountNumber() {
    final regex = RegExp(r'^\d{10}$');
    return regex.hasMatch(this);
  }
}

extension Validate on List<bool> {
  bool validate() {
    return !any((element) {
      return !element;
    });
  }
}

extension ValidateDropdown on dynamic {
  String? validate() {
    if (this == null) {
      return '*required';
    }
    return null;
  }
}
