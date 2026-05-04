import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import '../controller/forum_controller.dart';

class PreparePostContentPage extends GetView<ForumController> {
  const PreparePostContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final File imageFile = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CustomAppBar(
        title: AppStrings.get(AppStrings.forumKeyPostContent),
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                imageFile,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.getOr('Share your health journey...', 'Bagikan perjalanan sehatmu...'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            AnimatedIn(
              child: TextField(
                controller: controller.contentController,
                maxLines: 6,
                style: const TextStyle(fontSize: 15, color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: AppStrings.getOr('Write something here...', 'Tulis sesuatu di sini...'),
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: controller.isPosting.value ? null : () => controller.submitPost(imageFile.path),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.richBrown,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: controller.isPosting.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(
                        AppStrings.get(AppStrings.commonKeySubmit).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
