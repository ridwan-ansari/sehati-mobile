import 'package:flutter/material.dart';
import 'package:sehati/app/modules/dashboard/views/feature/home/journal/widgets/gradien_label.dart';

class DialogUtils {
  // ---------------------------------------------------------------------------
  // CONFIRMATION DIALOG (YES / NO)
  // ---------------------------------------------------------------------------
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String yesText = "Yes",
    String noText = "No",
  }) async {
    bool confirmed = false;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(noText, style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                confirmed = true;
                Navigator.pop(context);
              },
              child: Text(yesText, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    return confirmed;
  }

  // ---------------------------------------------------------------------------
  // SEARCHABLE LIST DIALOG
  // ---------------------------------------------------------------------------
  static Future<T?> showSearchDialog<T>({
    required BuildContext context,
    required String title,
    Widget? content,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: GradientLabel(title: title, fontSize: 14),
              content: content,
            );
          },
        );
      },
    );
  } // ---------------------------------------------------------------------------

  // CUSTOM DIALOG (TITLE + CUSTOM WIDGET)
  // ---------------------------------------------------------------------------
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    Widget? content,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: content,
            );
          },
        );
      },
    );
  }
}
