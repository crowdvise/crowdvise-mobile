import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

enum UserRole { designer, customer }

enum GenderType { male, female, nonBinary, preferNotToSay }

enum StrengthLevel { none, weak, fair, good, strong, excellent }

//function that converts enum to String

String toUserRoleString(UserRole role) {
  switch (role) {
    case UserRole.designer:
      return 'designer';
    case UserRole.customer:
      return 'customer';
  }
}

UserRole fromUserRoleString(String userRole) {
  switch (userRole) {
    case 'designer':
      return UserRole.designer;
    case 'customer':
      return UserRole.customer;
    default:
      throw Exception('Unknown user role');
  }
}

String toGenderTypeString(GenderType role) {
  switch (role) {
    case GenderType.male:
      return 'male';
    case GenderType.female:
      return 'female';
    case GenderType.nonBinary:
      return 'nonBinary';
    case GenderType.preferNotToSay:
      return 'preferNotToSay';
  }
}

GenderType fromGenderTypeString(String userRole) {
  switch (userRole) {
    case 'male':
      return GenderType.male;
    case 'female':
      return GenderType.female;
    case 'nonBinary':
      return GenderType.nonBinary;
    case 'preferNotToSay':
      return GenderType.preferNotToSay;
    default:
      throw Exception('Unknown gender type');
  }
}

String getMessage(StrengthLevel level) {
  switch (level) {
    case StrengthLevel.excellent:
      return 'Excellent password! Your password is secure and meets all safety standards.';
    case StrengthLevel.strong:
      return 'Strong password! Your password meets the security requirements.';
    case StrengthLevel.good:
      return 'Good password. Add more character types and ensure it\'s at least 12 characters long.';
    case StrengthLevel.fair:
      return 'Fair password. Add uppercase letters, numbers, symbols, and ensure 12+ characters.';
    case StrengthLevel.weak:
      return 'Weak password. Use at least 12 characters with uppercase, lowercase, numbers, and symbols.';
    case StrengthLevel.none:
      return '';
  }
}

Color getColor(StrengthLevel level) {
  switch (level) {
    case StrengthLevel.excellent:
      return success400; // Success 400
    case StrengthLevel.strong:
      return success400; // Success 400
    case StrengthLevel.good:
      return warning400; // Warning color
    case StrengthLevel.fair:
      return warning400; // Warning color
    case StrengthLevel.weak:
      return error400; // Error color
    case StrengthLevel.none:
      return neutral100;
  }
}
