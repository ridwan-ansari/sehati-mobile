import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/constants/app_colors.dart';
import 'package:sehati/app/common/localization/app_strings.dart';
import 'package:sehati/app/common/widgets/custom_appbar.dart';
import '../controller/forum_controller.dart';

class TakePhotoPage extends GetView<ForumController> {
  const TakePhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: AppStrings.get(AppStrings.forumKeyTakePhoto),
        showBackButton: true,
      ),
      body: FutureBuilder<void>(
        future: controller.initializeCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CameraPreview(controller.cameraController!),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildCaptureButton(),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: AppColors.orangeLight));
          }
        },
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: () => controller.takePhoto(),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
