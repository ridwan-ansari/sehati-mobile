import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/localization/app_strings.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  DateTime? _lastBackPressed;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (selectedIndex.value != 0) {
      selectedIndex.value = 0;
      return false;
    }

    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(bottom: 60),
          content: Align(
            alignment: Alignment.bottomCenter,
            child: IntrinsicWidth(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.get(AppStrings.commonKeyExitPressAgain),
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
