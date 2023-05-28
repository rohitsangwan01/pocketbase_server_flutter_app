import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UI {
  static const Duration snackbarOpeningTime = Duration(seconds: 2);

  static void presentError(message) => _errorSnackBar(message: message)?.show();
  static void presentSuccess(message) =>
      _successSnackBar(message: message)?.show();

  static void closeKeyboard() =>
      FocusScope.of(Get.context!).requestFocus(FocusNode());

  static Future presentBottomSheet(String msg) async {
    BuildContext? context = Get.context;
    if (context == null) {
      return null;
    }
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.zero,
        content: Container(
          height: Get.height / 9,
          color: Theme.of(context).colorScheme.secondary,
          child: Center(
            child: Text(
              msg,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  static void showLoadingBar() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  static void closeLoading({checkSnackbar = true}) {
    if (checkSnackbar) Get.closeAllSnackbars();
    if (Get.isDialogOpen == true) Get.back();
  }

  static GetSnackBar? _successSnackBar({
    required String message,
  }) {
    BuildContext? context = Get.context;
    if (context == null) {
      return null;
    }
    return GetSnackBar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.check_circle_outline,
        size: 32,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: snackbarOpeningTime,
    );
  }

  static GetSnackBar? _errorSnackBar({
    required String message,
    Duration? duration,
  }) {
    BuildContext? context = Get.context;
    if (context == null) {
      return null;
    }
    return GetSnackBar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.red,
      icon: const Icon(
        Icons.remove_circle_outline,
        size: 32,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: duration ?? snackbarOpeningTime,
    );
  }
}
