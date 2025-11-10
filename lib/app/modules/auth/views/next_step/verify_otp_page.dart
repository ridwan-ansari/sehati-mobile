import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:sehati/app/modules/auth/controllers/auth_controller.dart';

class VerifyOtpPage extends GetView<AuthController> {
  const VerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.arguments?['email'] ?? "";
    final otpCode = "".obs;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Verify OTP", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Enter the 6-digit code sent to your email",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text("'$email'", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 24),

            OtpTextField(
              fieldWidth: 45,
              numberOfFields: 6,
              borderColor: Colors.orange,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                otpCode.value = code;
              },
              onSubmit: (String verificationCode) {
                otpCode.value = verificationCode;
              },
            ),
            const SizedBox(height: 32),

            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: otpCode.value.length == 6
                    ? () async {
                        await controller.verifyOtp(email, otpCode.value);
                      }
                    : null,
                child: const Text("Verify", style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Kirim ulang OTP
                // controller.resendOtp(email);
              },
              child: const Text(
                "Resend OTP",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
