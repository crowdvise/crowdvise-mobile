import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

extension SnackbarStateless on BuildContext {
  showSuccess(String message) {
    // customFlushBar(message, 1).show(this);
    customToast(message, 1);
  }

  showError(String message) {
    // customFlushBar(message, 3).show(this);
    customToast(message, 3);
  }

  showWarning(String message) {
    // customFlushBar(message, 2).show(this);
    customToast(message, 2);
  }

  logg(String log) {
    return Logger().i(log);
  }
}

extension Snackbar on State {
  showSuccess(String message) {
    context.showSuccess(message);
  }

  logg(String log) {
    context.logg(log);
  }

  showError(String message) {
    context.showError(message);
  }

  showWarning(String message) {
    context.showWarning(message);
  }
}

customToast(String message, [type = 1]) {
  final IconData icon;
  final String title;
  final Color bgColor;
  final Color borderColor;
  final Color iconColor;
  final ToastificationType toastType;
  switch (type) {
    case 1:
      icon = Icons.check_circle_rounded;
      title = "Success";
      toastType = ToastificationType.success;
      bgColor = success50;
      borderColor = success200;
      iconColor = success600;
      break;
    case 2:
      icon = Icons.warning_rounded;
      title = "Warning";
      toastType = ToastificationType.warning;
      bgColor = warning50;
      borderColor = warning100;
      iconColor = warning500;
      break;
    default:
      icon = Icons.error_rounded;
      title = "Error";
      toastType = ToastificationType.error;
      bgColor = error50;
      borderColor = error400;
      iconColor = error500;
  }

  return toastification.show(
    type: toastType,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(title, style: TextStyle(color: neutral900)),
    description: Text(message, style: TextStyle(color: neutral600)),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    icon: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 15),
    ),
    showIcon: true, // show or hide the icon
    primaryColor: iconColor,
    backgroundColor: neutral50,
    foregroundColor: neutral700,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(4),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    // showProgressBar: true,
    closeButton: ToastCloseButton(
      showType: CloseButtonShowType.always,
      buttonBuilder: (context, onClose) {
        return IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded, color: neutral700),
        );
      },
    ),

    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    // callbacks: ToastificationCallbacks(
    //   onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
    //   onCloseButtonTap:
    //       (toastItem) => print('Toast ${toastItem.id} close button tapped'),
    //   onAutoCompleteCompleted:
    //       (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
    //   onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    // ),
  );
}

// Flushbar customFlushBar(String message, [type = 1]) {
//   final IconData icon;
//   final Color color;
//   final Color iconColor;
//   switch (type) {
//     case 1:
//       icon = Icons.check_circle;
//       color = const Color(0x5230D158);
//       iconColor = const Color(0xFF30D158);
//       break;
//     case 2:
//       icon = Icons.warning;
//       color = const Color(0x52FF9F0A);
//       iconColor = const Color(0xFFFF9F0A);
//       break;
//     default:
//       icon = Icons.error;
//       color = const Color(0x2EFF453A);
//       iconColor = const Color(0xFFFF453A);
//   }

//   return Flushbar(
//     messageText: Text(
//       message,
//       style: TextStyle(
//         fontFamily: 'Outfit',
//         fontWeight: FontWeight.w500,
//         fontSize: 18,
//         color: iconColor,
//       ),
//     ),
//     messageColor: iconColor,
//     icon: Icon(icon, color: iconColor),
//     flushbarPosition: FlushbarPosition.TOP,
//     reverseAnimationCurve: Curves.decelerate,
//     forwardAnimationCurve: Curves.decelerate,
//     shouldIconPulse: true,
//     backgroundColor: color,
//     isDismissible: true,
//     duration: const Duration(seconds: 4),
//     dismissDirection: FlushbarDismissDirection.HORIZONTAL,
//     flushbarStyle: FlushbarStyle.FLOATING,
//     boxShadows: const [],
//     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
//     borderRadius: BorderRadius.circular(8),
//   );
// }
