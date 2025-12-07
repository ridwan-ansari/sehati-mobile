
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sehati/app/common/animations/animated_in.dart';
import 'package:sehati/app/common/constants/app_assets.dart';
import 'package:sehati/app/common/utils/app_asset_utils.dart';
import 'package:sehati/app/modules/dashboard/views/feature/forum/controller/camera_controller.dart';

class PreparePostContent extends GetView<CameraControllerX> {
  const PreparePostContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              controller.selectedImage.value = null;
              controller.isNext.value = false;
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppAssetUtils.svg(
                AppAssets.cancelIcon,
                width: 24,
                height: 24,
              ),
            ),
          ),
          title: AnimatedIn(
            child: Text(
              controller.isNext.value ? "new post" : "",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          actions: [const SizedBox(width: 12.0)],
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              controller.isNext.value == false
                  ? Center(
                      child: Obx(() {
                        final file = controller.selectedImage.value;
                        if (file == null) {
                          return const SizedBox(
                            height: 512,
                            child: Center(child: AnimatedIn(child: Text("No photos"))),
                          );
                        }
                        return AnimatedIn(
                          child: Container(
                            height: 512,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(file),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  : Obx(() {
                      final file = controller.selectedImage.value;
                      if (file == null) {
                        return const SizedBox(
                          height: 250,
                          width: 250,
                          child: Center(child: AnimatedIn(child: Text("No photos"))),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(file),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              if (controller.isNext.value)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedIn(
                          child: TextField(
                            maxLines: null,
                            maxLength: 300,
                            onChanged: (v) => controller.description.value = v,
                            decoration: InputDecoration(
                              hintText: "Write a post description...",
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: TextButton(
          onPressed: controller.isNext.value
              ? () => controller.postContent()
              : () => controller.isNext.value = true,
          child: AnimatedIn(
            child: Text(
              controller.isNext.value ? "Upload" : "Next",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
