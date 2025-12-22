import 'package:flutter/material.dart';

extension ToastExtension on BuildContext {
  void showToast(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = const Color(0xFF323232),
    Color textColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void showSuccessToast(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    showToast(
      message,
      duration: duration,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void showErrorToast(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showToast(
      message,
      duration: duration,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void showWarningToast(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    showToast(
      message,
      duration: duration,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }
}
