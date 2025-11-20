import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/camera_controller.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/view/prepare_post_content.dart';

class TakePhotoPage extends GetView<CameraControllerX> {
  const TakePhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraAwesomeBuilder.awesome(
            saveConfig: SaveConfig.photo(),
            availableFilters: [
              AwesomeFilter.Sierra,
              AwesomeFilter.AddictiveRed,
              AwesomeFilter.AddictiveBlue,
            ],
            onMediaCaptureEvent: (event) {
              if (event.isPicture &&
                  event.status == MediaCaptureStatus.success) {
                final path = event.captureRequest.path;

                if (path != null) {
                  controller.selectedImage.value = File(path);
                  Get.to(() => const PreparePostContent());
                }
              }
            },

            onMediaTap: (mediaCapture) {
              mediaCapture.captureRequest.when(
                single: (single) {
                  if (single.file?.path != null) {
                    controller.selectedImage.value = File(single.file!.path);
                    Get.back(result: controller.selectedImage.value);
                  }
                },
                multiple: (multiple) {},
              );
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.zero,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.white, size: 65),
                  onPressed: () async {
                    await controller.pickFromGallery();
                    if (controller.selectedImage.value != null) {
                      Get.to(() => const PreparePostContent());
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 24.0),
        ],
      ),
    );
  }
}
