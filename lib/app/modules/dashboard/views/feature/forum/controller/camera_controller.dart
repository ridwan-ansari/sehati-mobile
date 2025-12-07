import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sehati/app/common/utils/snackbar_utils.dart';
import 'package:sehati/app/data/services/forum_service.dart';

class CameraControllerX extends GetxController {
  final _service = ForumService();
  RxBool showFab = false.obs;
  final ImagePicker picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isNext = false.obs;
  RxString description = "".obs;
  Future<void> pickFromGallery() async {
    try {
      final photo = await picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        selectedImage.value = File(photo.path);
      }
    } catch (_) {}
  }

  Future<void> postContent() async {
    EasyLoading.show();

    if (selectedImage.value == null || selectedImage.value!.path.isEmpty) {
      SnackbarUtils.show('photo not recognized');
      EasyLoading.dismiss();
      return;
    }

    final status = await _service.createPost(
      caption: description.value,
      filePath: selectedImage.value!.path,
    );

    if (status) {
      selectedImage.value = null;
      isNext.value = false;
      Get.toNamed('/dashboard');
      EasyLoading.dismiss();
      return;
    }

    EasyLoading.dismiss();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 0), () {
      showFab.value = true;
    });
  }

  @override
  void onClose() {
    selectedImage.value = null;
    isNext.value = false;
    super.onClose();
  }
}
