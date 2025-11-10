import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  DateTime? lastBackPressed;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (selectedIndex != 0) {
      selectedIndex.value = 0;
      return false;
    }
    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.only(bottom: 60, left: 0, right: 0),
          content: Align(
            alignment: Alignment.bottomCenter,
            child: IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  mainAxisSize:
                      MainAxisSize.min, // << penting supaya auto-width
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Tekan sekali lagi untuk keluar",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    await SystemNavigator.pop();
    return true;
  }
}
