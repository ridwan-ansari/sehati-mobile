import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/data/services/language_service.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  late AuthController controller;
  String _otpCode = '';
  bool _isComplete = false;

  int _submitTimestamp = 0;
  static const int _graceMs = 300;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
  }

  void _onCodeChanged(String code) {
    final elapsed = DateTime.now().millisecondsSinceEpoch - _submitTimestamp;
    if (elapsed < _graceMs) return;
    setState(() {
      _otpCode = code;
      _isComplete = false;
    });
  }

  void _onSubmit(String verificationCode) {
    _submitTimestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _otpCode = verificationCode;
      _isComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments?['email'] ?? "";

    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = (screenWidth / 6).clamp(36.0, 52.0);

    return Obx(() {
      Get.find<LanguageService>().currentLanguage.value;
      final isLoading = controller.isLoading.value;

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            AppStrings.get(AppStrings.otpKeyTitle),
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppStrings.get(AppStrings.otpKeyMessage),
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 24),

              OtpTextField(
                numberOfFields: 6,
                borderColor: Colors.orange,
                enabledBorderColor: Colors.grey.shade300,
                focusedBorderColor: Colors.orange,
                borderRadius: BorderRadius.circular(12),
                showFieldAsBox: true,
                fieldWidth: fieldWidth - 8,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                onCodeChanged: _onCodeChanged,
                onSubmit: _onSubmit,
              ),
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_isComplete && !isLoading)
                        ? Colors.orange
                        : Colors.grey.shade300,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (_isComplete && !isLoading)
                      ? () async {
                          await controller.verifyOtp(email, _otpCode);
                        }
                      : null,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          AppStrings.get(AppStrings.otpKeyVerify),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        controller.resendOtp();
                      },
                child: Text(
                  AppStrings.get(AppStrings.otpKeyResend),
                  style: TextStyle(
                    color: isLoading ? Colors.grey : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
