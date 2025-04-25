import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  /// Shows a success toast with customizable message
  static ToastificationItem success({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.topRight,
  }) {
    return _showToast(
      context: context,
      type: ToastificationType.success,
      message: message,
      title: title ?? 'Success',
      duration: duration,
      alignment: alignment,
      primaryColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  /// Shows an error toast with customizable message
  static ToastificationItem error({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.topRight,
  }) {
    return _showToast(
      context: context,
      type: ToastificationType.error,
      message: message,
      title: title ?? 'Error',
      duration: duration,
      alignment: alignment,
      primaryColor: Colors.red,
      icon: Icons.error_outline,
    );
  }

  /// Shows an info toast with customizable message
  static ToastificationItem info({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.topRight,
  }) {
    return _showToast(
      context: context,
      type: ToastificationType.info,
      message: message,
      title: title ?? 'Info',
      duration: duration,
      alignment: alignment,
      primaryColor: Colors.blue,
      icon: Icons.info_outline,
    );
  }

  /// Shows a warning toast with customizable message
  static ToastificationItem warning({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.topRight,
  }) {
    return _showToast(
      context: context,
      type: ToastificationType.warning,
      message: message,
      title: title ?? 'Warning',
      duration: duration,
      alignment: alignment,
      primaryColor: Colors.orange,
      icon: Icons.warning_amber_outlined,
    );
  }

  /// Private method that handles the common toast configuration
  static ToastificationItem _showToast({
    required BuildContext context,
    required ToastificationType type,
    required String message,
    required String title,
    required Duration duration,
    required Alignment alignment,
    required Color primaryColor,
    required IconData icon,
  }) {
    return toastification.show(
      context: context,
      type: type,

      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      title: Text(title),
      description: Text(message),
      alignment: alignment,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: Icon(icon),
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: false,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.onHover,
        buttonBuilder: (context, onClose) {
          return OutlinedButton.icon(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20),
            label: const Text('Close'),
          );
        },
      ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  /// Dismisses a specific toast
  static void dismiss(ToastificationItem notification) {
    toastification.dismiss( notification);
  }

  /// Dismisses all toasts
  static void dismissAll(BuildContext context) {
    toastification.dismissAll();
  }
}