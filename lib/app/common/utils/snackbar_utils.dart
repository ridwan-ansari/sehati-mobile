import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtils {
  /// Tampilkan snackbar custom
  static void show(
    String message, {
    bool isError = true,
    bool top = false,
    int durationSeconds = 2,
  }) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: top
            ? const EdgeInsets.only(top: 50, left: 16, right: 16)
            : const EdgeInsets.only(bottom: 60, left: 16, right: 16),
        content: Align(
          alignment: top ? Alignment.topCenter : Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
               boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
                    color: isError ? Colors.red : Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }
}
