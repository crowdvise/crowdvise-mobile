

import 'package:crowdvise/core/domain/utils/enums.dart';

String accessToken = '';
String userType = '';
// bool isLawyer = userType.contains('lawyer');
// bool isClient = userType.contains('client');
// bool isStudent = userType.contains('student');

UserRole? currentRole;

// Shared preference keys
String onboardingKey = 'onboarding';
String tokenKey = 'token';
String userRoleKey = 'user-role';
String user = 'user';
String savedIds = 'savedIds';
String currentEmail = 'currentEmail';
